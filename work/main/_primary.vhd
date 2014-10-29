library verilog;
use verilog.vl_types.all;
entity main is
    generic(
        period_red      : integer := 3;
        period_yellow_red: integer := 3;
        period_yellow   : integer := 3;
        period_blinky_green: integer := 3;
        period_green    : integer := 3
    );
    port(
        red_o           : out    vl_logic;
        yellow_o        : out    vl_logic;
        green_o         : out    vl_logic;
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of period_red : constant is 1;
    attribute mti_svvh_generic_type of period_yellow_red : constant is 1;
    attribute mti_svvh_generic_type of period_yellow : constant is 1;
    attribute mti_svvh_generic_type of period_blinky_green : constant is 1;
    attribute mti_svvh_generic_type of period_green : constant is 1;
end main;
