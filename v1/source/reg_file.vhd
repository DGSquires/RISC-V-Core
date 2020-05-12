library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
    
entity REG_FILE is
    port(
        CLK                 : in std_logic;
        CE_REG_N            : in std_logic;
        RST_N               : in std_logic;
        REG_WR_N            : in std_logic;
        DECODER_RD_4D0      : in std_logic_vector(4 downto 0);
        DECODER_RS1_4D0     : in std_logic_vector(4 downto 0);
        DECODER_RS2_4D0     : in std_logic_vector(4 downto 0); 
        REG_DATA_RD_31D0        : in std_logic_vector(31 downto 0);        
--        INSTRUCTION_IN_32D0 : in std_logic_vector(31 downto 0);

        REG_DATA_RS1_31D0   : out std_logic_vector(31 downto 0);    
        REG_DATA_RS2_31D0   : out std_logic_vector(31 downto 0)
--        INSTRUCTION_OUT_32D0: out std_logic_vector(31 downto 0)
    );
        
end REG_FILE;

architecture RTL of REG_FILE is 

    constant C_REG_SIZE     : integer := 32;
    constant C_DATA_SIZE    : integer := 32;
    
    type T_REG is array(0 to C_REG_SIZE-1) of std_logic_vector(C_DATA_SIZE-1 downto 0);   
    signal REG : T_REG := (others=>(others=>'Z'));
    
begin

    REG(0) <= (others=>'0');

    REG_PROC:process(CLK)
    begin
        if rising_edge(CLK) then
            if RST_N = '0' then
                --REG(1 to 31)           <= (others=>(others=>'0'));
                REG_DATA_RS1_31D0      <= (others=>'0');
                REG_DATA_RS2_31D0      <= (others=>'0');    
            else
                if REG_WR_N = '0' then 
                    if unsigned(DECODER_RD_4D0) > 0 then
                        REG(to_integer(unsigned(DECODER_RD_4D0))) <= REG_DATA_RD_31D0;
                    end if;
                end if;
                
                if CE_REG_N = '0' then
                    REG_DATA_RS1_31D0 <= REG(to_integer(unsigned(DECODER_RS1_4D0)));
                    REG_DATA_RS2_31D0 <= REG(to_integer(unsigned(DECODER_RS2_4D0)));
                else    
                    REG_DATA_RS1_31D0      <= (others=>'Z');
                    REG_DATA_RS2_31D0      <= (others=>'Z');
                end if;
            end if;
        end if;
    end process;
    
end RTL; 