//the high level module
module main (output bit red_o, yellow_o, green_o,
             input logic clk_i, rst_i
             );

parameter period = 3;//number of cloks of a light
logic [3:0] n = period;


//****************************************************************
//         Importing defenitions
//****************************************************************

//****************************************************************
//            Some local defs
//****************************************************************
typedef enum {RED, RST, YELLOW_RED, GREEN, BLINKY_GREEN, YELLOW/*, ROUT[0:7]*/} states;
states state_t = RST; 


//****************************************************************
//            Finite State machine 
//****************************************************************

always_ff @(posedge clk_i or posedge rst_i) begin: state_machine
  if (rst_i) begin 
      red_o <= 0;
      yellow_o <= 0;
      green_o <= 0;
      state_t <= RST;   
  end
  begin
     unique case(state_t)
      RST: begin
             if  (!rst_i)  state_t <= RED; 
           end
      RED: begin
              if  (!rst_i)
                begin
                  if (n-->0) red_o = 1;
                  else
                   begin
                    state_t <= YELLOW_RED;
                    n = period; 
                    red_o = 0;
                   end 
                end 
              else   state_t <= RST;
            end        
      YELLOW_RED: begin
           if  (!rst_i)
                begin
                  if (n-->0)
                  begin
                    red_o = 1;
                    yellow_o = 1;
                  end 
                  else
                   begin
                    state_t <= GREEN;
                    n = period; 
                    red_o = 0;
                    yellow_o = 0;
                   end 
                end 
              else   state_t <= RST;
            end
      GREEN: begin
           if  (!rst_i)
                begin
                  if (n-->0)
                  begin
                    green_o = 1;
                  end 
                  else
                   begin
                    state_t <= BLINKY_GREEN;
                    n = period; 
                    green_o = 0;
                   end 
                end 
              else   state_t <= RST;
            end
      BLINKY_GREEN: begin
           if  (!rst_i)
                begin
                  if (n-->0) green_o = ~green_o;
                  else
                   begin
                    state_t <=  YELLOW;
                    n = period; 
                    green_o = 0;
                   end 
                end 
              else state_t <= RST;
           end
      YELLOW: begin
           if  (!rst_i)
                begin
                  if (n-->0) yellow_o = 1;
                  else
                   begin
                    state_t <=  RED;
                    n = period; 
                    yellow_o = 0;
                   end 
                end 
              else state_t <= RST;
           end  
    endcase
  end
end : state_machine


endmodule


module testbench;


logic clk_i, rst_i; 
bit red_o, yellow_o, green_o;  

  main #(.period(4)) DUT(.* , .rst_i(1'b0));

initial begin clk_i = 1'b0;
forever #10  clk_i = !clk_i;
end

endmodule
