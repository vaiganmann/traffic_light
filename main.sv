//the high level module
module main (output bit red_o, yellow_o, green_o,
             input logic clk_i, rst_i
             );

parameter period_red = 3, period_yellow_red = 3, period_yellow = 3, period_blinky_green = 3, period_green = 3;//number of cloks of a light
logic [3:0] nr = period_red, nyr = period_yellow_red, ny = period_yellow, nbg = period_blinky_green, ng = period_green;


//****************************************************************
//         Importing defenitions
//****************************************************************

//****************************************************************
//            Some local defs
//****************************************************************
typedef enum {RED, RST, YELLOW_RED, GREEN, BLINKY_GREEN, YELLOW/*, ROUT[0:7]*/} states;
states next_state_t = RST , state_t = RST; 


//****************************************************************
//            Finite State machine 
//****************************************************************
always_ff @(posedge clk_i or posedge rst_i) begin
    if (rst_i) state_t <= RST;   
    else begin 
      state_t <= next_state_t;
    end
end


always_comb begin: next_state_machine
     unique case(state_t)
      RST: begin
            red_o = 0;
            yellow_o = 0;
            green_o = 0;
            next_state_t = RED; 
           end
      RED: begin
            if (nr>0) red_o = 1;
             else
                  begin
                    next_state_t = YELLOW_RED;
                    //nr = period_red; 
                    red_o = 0;
                  end
            end        
      YELLOW_RED: begin
              if (nyr>0)
                 begin
                    red_o = 1;
                    yellow_o = 1;
                  end 
               else
                  begin
                    next_state_t = GREEN;
                    //nyr = period_yellow_red; 
                    red_o = 0;
                    yellow_o = 0;
                  end 
              end
      GREEN: begin
              if (ng>0) green_o = 1;
              else
                   begin
                    next_state_t = BLINKY_GREEN;
                    //ng = period_green; 
                    green_o = 0;
                   end 
              end
      BLINKY_GREEN: begin
               if (nbg>0) green_o = ~green_o;
               else
                   begin
                    next_state_t <=  YELLOW;
                    //nbg = period_blinky_green; 
                    green_o = 0;
                   end 
               end
      YELLOW: begin
                if (ny>0) yellow_o = 1;
                else
                   begin
                    next_state_t =  RED;
                    //ny = period_yellow; 
                    yellow_o = 0;
                   end 
              end  
    endcase
  end : next_state_machine
 
always_ff @(posedge clk_i or posedge rst_i) begin
  if (nr>=0 && state_t == RED) nr--;
    else nr <= period_red; 
  if (nyr>=0 && state_t == YELLOW_RED) nyr--;
    else nyr <= period_yellow_red; 
  if (ng>=0 &&  state_t == GREEN) ng--;
    else ng <= period_green;
  if (nbg>=0 && state_t == BLINKY_GREEN) nbg--;
    else nbg <= period_blinky_green;
  if (ny>=0 &&  state_t == YELLOW) ny--;
    else ny<=period_yellow;   
end
    
endmodule 




module testbench;
logic clk_i, rst_i; 
bit red_o, yellow_o, green_o;  

  main #(.period_red(4)) DUT(.* , .rst_i(1'b0));

initial begin clk_i = 1'b0;
forever #10  clk_i = !clk_i;
end
endmodule

