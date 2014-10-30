`include "counter.sv"

//the high level module
module traffic_light (output bit red_o, yellow_o, green_o,
             input bit clk_i, rst_i
             );

parameter period_red = 3, period_yellow_red = 3, period_yellow = 3, period_blinky_green = 3, period_green = 3;//number of cloks of a light
bit [3:0] nr = period_red, nyr = period_yellow_red, ny = period_yellow, nbg = period_blinky_green, ng = period_green;
bit [3:0] count, max_count ;
bit start, rst, overflow;
//****************************************************************
//            Some local defs
//****************************************************************
typedef enum {RED, RST, YELLOW_RED, GREEN, BLINKY_GREEN, YELLOW} states;
states next_state_t = RST , state_t = RST; 

counter counter_inst(clk_i, rst, start, count, max_count ,overflow);

//****************************************************************
//            Finite State machine 
//****************************************************************
  
    //else begin 
    //  state_t <= next_state_t;
    // end
//end


//always_latch begin: next_state_machine
always_ff @(posedge clk_i or posedge rst_i) begin
  if (rst_i) state_t <= RST; 
   else 
     unique case(state_t)
      RST: begin
            state_t <= RED; 
           end
      RED: begin      
            if (!overflow)begin
              red_o <= 1;
              start <= 1;
              rst <= 0;
              max_count <= nr-2;
             end
             else
                  begin
                    state_t <= YELLOW_RED;
                    red_o <= 0;
                    start <= 0;
                    rst <= 1;
                  end
            end        
      YELLOW_RED: begin              
              if (!overflow)
                 begin
                    max_count <= nyr-2;
                   	rst <= 0; 
				            start <= 1;
                    red_o <= 1;
                    yellow_o <= 1;
                  end 
               else
                  begin
                    state_t <= GREEN;
                    red_o <= 0;
                    yellow_o <= 0;
                    start <= 0;
                    rst <= 1;                   
                  end 
              end
      GREEN: begin
              
              if (!overflow)begin
                rst <= 0; 
				        start <= 1;
				        max_count <= ng-2; 
                green_o <= 1;
              end
              else
                   begin
                    state_t <= BLINKY_GREEN;
                    green_o <= 0; 
                    start <= 0;
                    rst <= 1;
                   end 
              end
      BLINKY_GREEN: begin
               if (!overflow) begin
                green_o <= ~green_o;
                rst <= 0; 
				        start <= 1;
				        max_count <= nbg-2;
                end
               else
                   begin
                    green_o <= 0;
                    start <= 0;
                    rst <= 1;
                    state_t <=  YELLOW;
                   end 
               end
      YELLOW: begin
                if (!overflow) begin
                  yellow_o <= 1;
                  rst <= 0; 
				          start <= 1;
				          max_count <= ny-2;
                end
                else
                   begin
                    state_t <=  RED;
					          yellow_o <= 0;
                    start <= 0;
                    rst <= 1; 
                   end 
              end 
    endcase 
  end

    
endmodule 


module testbench;
bit clk_i, rst_i; 
bit red_o, yellow_o, green_o;  

 traffic_light #(.period_red(4)) DUT(.* , .rst_i(1'b0));

initial begin clk_i = 1'b0;
forever #10  clk_i = !clk_i;
end
endmodule

