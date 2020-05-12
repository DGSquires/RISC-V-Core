library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ROM is
	port(
		CLK			        : in std_logic;
        RST_N               : in std_logic;
        CE_ROM_N            : in std_logic;
		PC_ADDR_OUT_31D0    : in std_logic_vector(31 downto 0);
        
        INSTRUCTION_31D0    : out std_logic_vector(31 downto 0)
		);
end ROM;

architecture RTL of ROM is
	
    constant C_ADDR_WIDTH    : integer  := 32;
    constant C_DATA_WIDTH    : integer  := 32;
    
    type T_ROM is array (0 to 8) of std_logic_vector(C_DATA_WIDTH-1 downto 0);
    
    signal ROM      : T_ROM     := (others=>(others=>'0'));

begin
    
	rom_proc:process(CLK)
	begin
		if rising_edge(CLK) then
            if RST_N = '0' then
                INSTRUCTION_31D0 <= (others=>'0');
            else
                if CE_ROM_N = '0' then 
					INSTRUCTION_31D0(31 downto 0) <= ROM(to_integer(unsigned(PC_ADDR_OUT_31D0)));
                    -- INSTRUCTION_31D0(31 downto 24) <= ROM(to_integer(unsigned(PC_ADDR_OUT_31D0))+3);
                    -- INSTRUCTION_31D0(23 downto 16) <= ROM(to_integer(unsigned(PC_ADDR_OUT_31D0))+2);
                    -- INSTRUCTION_31D0(15 downto 8)  <= ROM(to_integer(unsigned(PC_ADDR_OUT_31D0))+1);      
                    -- INSTRUCTION_31D0(7 downto 0)   <= ROM(to_integer(unsigned(PC_ADDR_OUT_31D0))+0);
                else
                    INSTRUCTION_31D0 <= (others=>'Z');
                end if;
            end if;
		end if;
	end process;
	
end RTL;
