library verilog;
use verilog.vl_types.all;
entity counter is
    port(
        clk             : in     vl_logic;
        resetN          : in     vl_logic;
        ready           : in     vl_logic;
        count           : out    vl_logic_vector(3 downto 0);
        max_count       : in     vl_logic_vector(3 downto 0);
        overflow        : out    vl_logic
    );
end counter;
