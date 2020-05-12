library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
    
entity CTRL is
    port(
        CLK             : in std_logic;
        RST_N           : in std_logic;
		--REG_WR_N		: in std_logic;
        --ALU_JMP_N		: in std_logic;
		
        CE_DECODER_N    : out std_logic;    
        CE_PC_N         : out std_logic;
        CE_ROM_N        : out std_logic;
        CE_REG_N        : out std_logic;
        CE_ALU_N        : out std_logic
    );
        
end CTRL;

architecture RTL of CTRL is

    type STATE_TYPE is (A,B,C,D,E,F);
    signal STATE : STATE_TYPE;
    
begin
    
    CTRL_PROC:process(CLK)
    begin   
        if rising_edge(CLK) then
            if RST_N = '0' then
                CE_DECODER_N    <= '1';      
                CE_PC_N         <= '1';
                CE_ROM_N        <= '1';
                CE_REG_N        <= '1';
                CE_ALU_N        <= '1';
                STATE           <= A;   
            else
                case STATE is
                    when A => 
                        CE_PC_N         <= '0';
                        CE_ROM_N        <= '1'; 
                        CE_DECODER_N    <= '1';   
                        CE_REG_N        <= '1';
                        CE_ALU_N        <= '1';                        
                        STATE           <= B;
                    when B =>
                        CE_PC_N         <= '1';
                        CE_ROM_N        <= '0'; 
                        CE_DECODER_N    <= '1'; 
                        CE_REG_N        <= '1'; 
                        CE_ALU_N        <= '1';
						STATE           <= C;
                    when C =>
                        CE_PC_N         <= '1';
                        CE_ROM_N        <= '1'; 
                        CE_DECODER_N    <= '0';    
                        CE_REG_N        <= '1';
                        CE_ALU_N        <= '1';
						STATE           <= D;
                    when D =>
                        CE_PC_N         <= '1';
                        CE_ROM_N        <= '1'; 
                        CE_DECODER_N    <= '1';    
                        CE_REG_N        <= '0';
                        CE_ALU_N        <= '1';
						STATE           <= E;
                    when E =>
                        CE_PC_N         <= '1';
                        CE_ROM_N        <= '1'; 
                        CE_DECODER_N    <= '1';    
                        CE_REG_N        <= '1';
                        CE_ALU_N        <= '0';
						STATE           <= F; 
                    when F =>
                        CE_PC_N         <= '1';
                        CE_ROM_N        <= '1'; 
                        CE_DECODER_N    <= '1';    
                        CE_REG_N        <= '1';
                        CE_ALU_N        <= '1';
						STATE           <= A;                        
                    when others => 
                        STATE           <= A;
                end case;
            end if;
        end if;
    end process;
	
    -- CTRL_PROC:process(CLK)
    -- begin   
        -- if rising_edge(CLK) then
            -- if RST_N = '0' then
                -- CE_DECODER_N    <= '1';      
                -- CE_PC_N         <= '1';
                -- CE_ROM_N        <= '1';
                -- CE_REG_N        <= '1';
                -- CE_ALU_N        <= '1'; 
            -- else	
				-- CE_DECODER_N    <= '0';      
                -- CE_PC_N         <= '0';
                -- CE_ROM_N        <= '0';
                -- CE_REG_N        <= '0';
                -- CE_ALU_N        <= '0'; 
			-- end if;
		-- end if;
	-- end process;
	
        
                

end RTL;
