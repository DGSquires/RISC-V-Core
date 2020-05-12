library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test is 
	port(
        DECODER_IMM_I_11D0  : in std_logic_vector(11 downto 0)
		);
end test;

architecture rtl of test is

    signal      I_REG_DATA_RD_31D0       : std_logic_vector(31 downto 0); 
    signal      I_MEM_DATA_OUT_31D0      : std_logic_vector(31 downto 0);

begin 
    process
		variable      x2       : integer := 0; 
	begin
		x2 := to_integer(resize(signed(DECODER_IMM_I_11D0(7 downto 0)),32));
		wait;
	end process;
	
							
	I_REG_DATA_RD_31D0 <= std_logic_vector(resize(signed(I_MEM_DATA_OUT_31D0(15 downto 0)),I_REG_DATA_RD_31D0'length));

end rtl;
