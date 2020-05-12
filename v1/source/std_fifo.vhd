-- A standard FIFO block from the internet
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
entity STD_FIFO is
	Generic (
		constant DATA_WIDTH : positive := 32;
		constant FIFO_DEPTH	: positive := 8
	);
	Port ( 
		CLK		            : in  STD_LOGIC;
		RST_N	            : in  STD_LOGIC;
		FIFO_WR_N	        : in  STD_LOGIC;
		FIFO_DATA_IN_31D0	: in  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		FIFO_RD_N	        : in  STD_LOGIC;
		FIFO_DATA_OUT_31D0	: out STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		FIFO_EMPTY_N	        : out STD_LOGIC;
		FIFO_FULL_N	        : out STD_LOGIC
	);
end STD_FIFO;
 
architecture Behavioral of STD_FIFO is

    signal FIFO_DATA_31D0   : std_logic_vector(DATA_WIDTH-1 downto 0);
    
begin

    
    
	-- Memory Pointer Process
	fifo_proc : process (CLK)
		type FIFO_Memory is array (0 to FIFO_DEPTH - 1) of STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
		variable Memory : FIFO_Memory := (others=>(others=>'0'));
		
		variable Head : natural range 0 to FIFO_DEPTH - 1;
		variable Tail : natural range 0 to FIFO_DEPTH - 1;
		
		variable Looped : boolean;
	begin
		if rising_edge(CLK) then
			if RST_N = '0' then
				Head := 0;
				Tail := 0;
				
				Looped := false;
				
				FIFO_FULL_N  <= '1';
				FIFO_EMPTY_N <= '0';
			else
				if (FIFO_RD_N = '0') then
					if ((Looped = true) or (Head /= Tail)) then
						-- Update data output
						FIFO_DATA_OUT_31D0 <= Memory(Tail);
						
						-- Update Tail pointer as needed
						if (Tail = FIFO_DEPTH - 1) then
							Tail := 0;
							
							Looped := false;
						else
							Tail := Tail + 1;
						end if;
					end if;
				else
					FIFO_DATA_OUT_31D0 <= (others=>'Z');
				end if;
				
				if (FIFO_WR_N = '0') then
					if ((Looped = false) or (Head /= Tail)) then
						-- Write Data to Memory
						Memory(Head) := FIFO_DATA_IN_31D0;
						
						-- Increment Head pointer as needed
						if (Head = FIFO_DEPTH - 1) then
							Head := 0;
							
							Looped := true;
						else
							Head := Head + 1;
						end if;
					end if;
				end if;
				
				-- Update FIFO_EMPTY_N and FIFO_FULL_N flags
				if (Head = Tail) then
					if Looped then
						FIFO_FULL_N <= '0';
					else
						FIFO_EMPTY_N <= '0';
					end if;
				else
					FIFO_EMPTY_N	<= '1';
					FIFO_FULL_N	<= '1';
				end if;
			end if;
		end if;
	end process;
		
end Behavioral;
