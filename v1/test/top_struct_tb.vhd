library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TOP_STRUCT_TB is
end TOP_STRUCT_TB;

architecture TB of TOP_STRUCT_TB is

    component TOP_STRUCT is
        port(
            CLK     : in std_logic;
            RST_N   : in std_logic
    );
    end component;
    
    signal CLK      : std_logic := '0';
    signal RST_N    : std_logic := '1';
    constant PERIOD : time      := 10 ns; 
    
begin

    UUT:TOP_STRUCT port map(
        CLK     => CLK,
        RST_N   => RST_N
    );
    
    CLK_PROC:process
    begin
        CLK <= '1';
        wait for PERIOD/2;
        CLK <= '0';
        wait for PERIOD/2;
    end process;
    
    RST_PROC:process
    begin
        report "Begining testbench...";
        RST_N <= '1';
        wait for PERIOD;
        RST_N <= '0';
        wait for PERIOD*2;
        RST_N <= '1';
        wait;
    end process;
    
        
end TB;

        
    