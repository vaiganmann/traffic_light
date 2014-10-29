library verilog;
use verilog.vl_types.all;
entity main is
    generic(
        period          : integer := 3
    );
    port(
        red_o           : out    vl_logic;
        yellow_o        : out    vl_logic;
        green_o         : out    vl_logic;
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of period : constant is 1;
end main;
