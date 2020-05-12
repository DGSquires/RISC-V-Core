library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
	port(
		CLK			        : in std_logic;
        RST_N               : in std_logic;
        CE_PC_N             : in std_logic;
        PC_JMP_N            : in std_logic;
		PC_ADDR_IN_31D0	    : in std_logic_vector(31 downto 0);
        
		PC_ADDR_OUT_31D0    : out std_logic_vector(31 downto 0)
		);
end PC;

architecture RTL of PC is
	
	signal COUNTER : unsigned(31 downto 0) := (others=>'0');

begin
        
	pc_proc:process(CLK)
	begin
		if rising_edge(CLK) then
            if RST_N = '0' then
				COUNTER <= (others=>'0');
            else
                if PC_JMP_N = '0' then
                    COUNTER <= unsigned(PC_ADDR_IN_31D0);
                    --PC_ADDR_OUT_31D0 <= PC_ADDR_IN_31D0;
                end if;
                if CE_PC_N = '0' then 
                    COUNTER <= COUNTER + 1;
                    PC_ADDR_OUT_31D0 <= std_logic_vector(COUNTER);
				else
					PC_ADDR_OUT_31D0 <= (others=>'Z');
                end if;
            end if;
		end if;
	end process;
	
end RTL;
