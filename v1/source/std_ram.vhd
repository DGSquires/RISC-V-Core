-- Simple generic RAM Model

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity std_ram is
  port (
    CLK             : in std_logic;
    RST_N           : in std_logic;
    WR_N            : in std_logic;
    RD_N            : in std_logic;    
    ADDR_31D0       : in std_logic_vector;
    DATA_IN_31D0    : in std_logic_vector;
    
	DATA_GOOD_N		: out std_logic;
    DATA_OUT_31D0   : out std_logic_vector
  );
end entity std_ram;

architecture RTL of std_ram is

    constant C_DEPTH    : integer := 127;
    constant C_WIDTH    : integer := 32;
    
    type RAM_TYPE is array (0 to C_DEPTH) of std_logic_vector(31 downto 0);
    
    signal RAM : RAM_TYPE;

begin

  ram_proc: process(CLK) is
  begin
    if rising_edge(CLK) then
        if RST_N = '0' then
            -- reset proc
        else
            if WR_N = '0' then
				RAM(to_integer(unsigned(ADDR_31D0))) <= DATA_IN_31D0;
			end if;
            if RD_N = '0' then
                DATA_OUT_31D0 <= RAM(to_integer(unsigned(ADDR_31D0)));
				DATA_GOOD_N <= '0';
		    else 
				DATA_GOOD_N <= '1';
            end if;
        end if;       
	end if;
  end process ram_proc;

end architecture RTL;