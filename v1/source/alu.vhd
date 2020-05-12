-- ALU is designed using Chapter 24 & Chapter 2 of the Volume 1 RISC-V unprivillged ISA 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
    
entity ALU is
    port(
        CLK                 : in std_logic;
        RST_N               : in std_logic;
        
        CE_ALU_N           : in std_logic;
        
        DECODER_OP_6D0      : in std_logic_vector(6 downto 0);
        DECODER_RD_4D0      : in std_logic_vector(4 downto 0);
        DECODER_RS1_4D0     : in std_logic_vector(4 downto 0);
        DECODER_RS2_4D0     : in std_logic_vector(4 downto 0);
        DECODER_FUNCT3_2D0  : in std_logic_vector(2 downto 0);
        DECODER_FUNCT7_6D0  : in std_logic_vector(6 downto 0);
        DECODER_IMM_B_11D0  : in std_logic_vector(11 downto 0);
        DECODER_IMM_I_11D0  : in std_logic_vector(11 downto 0);
        DECODER_IMM_J_19D0  : in std_logic_vector(19 downto 0);
        DECODER_IMM_S_11D0  : in std_logic_vector(11 downto 0);
        DECODER_IMM_U_19D0  : in std_logic_vector(19 downto 0);
        
        REG_DATA_RS1_31D0   : in std_logic_vector(31 downto 0);    
        REG_DATA_RS2_31D0   : in std_logic_vector(31 downto 0);
        
        FIFO_ADDR_31D0      : in std_logic_vector(31 downto 0);
		
		MEM_DATA_GOOD_N		: in std_logic;
        MEM_DATA_OUT_31D0   : in std_logic_vector(31 downto 0);
        
        REG_WR_N            : out std_logic;
        REG_DATA_RD_31D0    : out std_logic_vector(31 downto 0);
		REG_SEL_RD_4D0		: out std_logic_vector(4 downto 0);
        ALU_JMP_N           : out std_logic;
        ALU_JMP_TARGET_31D0 : out std_logic_vector(31 downto 0);
        
        MEM_WR_N            : out std_logic;
        MEM_RD_N            : out std_logic;
        MEM_ADDR_31D0       : out std_logic_vector(31 downto 0);
        MEM_DATA_IN_31D0    : out std_logic_vector(31 downto 0)
        
    );

end ALU;

architecture RTL of ALU is 

    -- MAJOR OPCODES
    constant    C_LOAD          : std_logic_vector(6 downto 0) := "0000011";   
    constant    C_LOAD_FP       : std_logic_vector(6 downto 0) := "0000111"; 
    constant    C_CUSTOM_0      : std_logic_vector(6 downto 0) := "0001011"; 
    constant    C_MISC_MEM      : std_logic_vector(6 downto 0) := "0001111"; 
    constant    C_OP_IMM        : std_logic_vector(6 downto 0) := "0010011";
    constant    C_AUIPC         : std_logic_vector(6 downto 0) := "0010111";
    constant    C_OP_IMM_32     : std_logic_vector(6 downto 0) := "0011011";
    constant    C_48B_1         : std_logic_vector(6 downto 0) := "0011111";   

    constant    C_STORE         : std_logic_vector(6 downto 0) := "0100011";
    constant    C_STORE_FP      : std_logic_vector(6 downto 0) := "0100111";
    constant    C_CUSTOM_1      : std_logic_vector(6 downto 0) := "0101011";
    constant    C_AMO           : std_logic_vector(6 downto 0) := "0101111";
    constant    C_OP            : std_logic_vector(6 downto 0) := "0110011";
    constant    C_LUI           : std_logic_vector(6 downto 0) := "0110111";
    constant    C_OP_32         : std_logic_vector(6 downto 0) := "0111011";
    constant    C_64B           : std_logic_vector(6 downto 0) := "0111111";   

    constant    C_MADD          : std_logic_vector(6 downto 0) := "1000011";
    constant    C_MSUB          : std_logic_vector(6 downto 0) := "1000111";
    constant    C_NMSUB         : std_logic_vector(6 downto 0) := "1001011";
    constant    C_NMADD         : std_logic_vector(6 downto 0) := "1001111";
    constant    C_OP_FP         : std_logic_vector(6 downto 0) := "1010011";
    constant    C_RESERVED_1    : std_logic_vector(6 downto 0) := "1010111";
    constant    C_CUSTOM_2      : std_logic_vector(6 downto 0) := "1011011";
    constant    C_48B_2         : std_logic_vector(6 downto 0) := "1011111";   

    constant    C_BRANCH        : std_logic_vector(6 downto 0) := "1100011";
    constant    C_JALR          : std_logic_vector(6 downto 0) := "1100111";
    constant    C_RESERVED_2    : std_logic_vector(6 downto 0) := "1101011";
    constant    C_JAL           : std_logic_vector(6 downto 0) := "1101111";
    constant    C_SYSTEM        : std_logic_vector(6 downto 0) := "1110011";
    constant    C_RESERVED_3    : std_logic_vector(6 downto 0) := "1110111";
    constant    C_CUSTOM_3      : std_logic_vector(6 downto 0) := "1111011";
    constant    C_80B           : std_logic_vector(6 downto 0) := "1111111";   
    
    constant    C_F3_BEQ        : std_logic_vector(2 downto 0) := "000";
    constant    C_F3_BNE        : std_logic_vector(2 downto 0) := "001";
    constant    C_F3_BLT        : std_logic_vector(2 downto 0) := "100";
    constant    C_F3_BGE        : std_logic_vector(2 downto 0) := "101";
    constant    C_F3_BLTU       : std_logic_vector(2 downto 0) := "110";
    constant    C_F3_BGEU       : std_logic_vector(2 downto 0) := "111"; 
    
    constant    C_F3_LB         : std_logic_vector(2 downto 0) := "000";
    constant    C_F3_LH         : std_logic_vector(2 downto 0) := "001";
    constant    C_F3_LW         : std_logic_vector(2 downto 0) := "010";
    constant    C_F3_LBU        : std_logic_vector(2 downto 0) := "100";
    constant    C_F3_LHU        : std_logic_vector(2 downto 0) := "101";
    constant    C_F3_SB         : std_logic_vector(2 downto 0) := "000";
    constant    C_F3_SH         : std_logic_vector(2 downto 0) := "001";
    constant    C_F3_SW         : std_logic_vector(2 downto 0) := "010";
    
    constant    C_MEM_W         : std_logic_vector(1 downto 0) := "11";
    constant    C_MEM_H         : std_logic_vector(1 downto 0) := "10";
    constant    C_MEM_B         : std_logic_vector(1 downto 0) := "00";    

    -- STATE MACHINES
    type        T_LOAD is (A,B,C);
    signal      S_LOAD : T_LOAD;
    signal      LOAD_COUNTER_3D0         : unsigned(3 downto 0) := "0000";

    -- INTERNAL WIRES
    signal      I_ALU_JMP_N              : std_logic;
    signal      I_REG_WR_N               : std_logic;
    signal      I_REG_DATA_RD_31D0       : std_logic_vector(31 downto 0); 
    signal      I_ALU_JMP_TARGET_31D0    : std_logic_vector(31 downto 0);
    signal      I_MEM_WR_N               : std_logic;
    signal      I_MEM_RD_N               : std_logic;
    signal      I_MEM_ADDR_31D0          : std_logic_vector(31 downto 0);
    signal      I_MEM_DATA_IN_31D0       : std_logic_vector(31 downto 0);
    signal      I_MEM_DATA_OUT_31D0      : std_logic_vector(31 downto 0);
	signal 		I_ALU_BUSY_N			 : std_logic;
    
    
    
begin

	ALU_JMP_N           <= I_ALU_JMP_N;
	REG_WR_N            <= I_REG_WR_N;
	ALU_JMP_TARGET_31D0 <= I_ALU_JMP_TARGET_31D0;
	REG_DATA_RD_31D0    <= I_REG_DATA_RD_31D0;
	MEM_WR_N         	<= I_MEM_WR_N;        
	MEM_RD_N         	<= I_MEM_RD_N;         
	MEM_ADDR_31D0    	<= I_MEM_ADDR_31D0;    
	MEM_DATA_IN_31D0 	<= I_MEM_DATA_IN_31D0; 
	I_MEM_DATA_OUT_31D0	<= MEM_DATA_OUT_31D0;
	

ALU_PROC:process(CLK)
    variable x1 : integer := 0;
    variable x2 : integer := 0;
    --variable x3 : integer := 0;    
    variable y1 : integer := 0;
    variable u1 : unsigned(31 downto 0) := (others=>'0'); 
	variable s_8  : signed(7 downto 0) := (others=>'0');
	variable s_16 : signed(16 downto 0) := (others=>'0');
	variable u_8  : unsigned(7 downto 0) := (others=>'0');
	variable u_16 : unsigned(7 downto 0) := (others=>'0');
	variable test : boolean := false;
begin
if rising_edge(CLK) then
    if RST_N = '0' then
        -- reset process
        I_ALU_JMP_N            <= '1';
        I_REG_WR_N             <= '1';
        I_ALU_JMP_TARGET_31D0  <= (others=>'0');
        I_REG_DATA_RD_31D0     <= (others=>'0');               
    else
        if CE_ALU_N = '0' then
            -- active process
            REG_SEL_RD_4D0 <= DECODER_RD_4D0;
            case DECODER_OP_6D0 is 
                when C_LUI =>
                    -- LUI (load upper immediate) is used to build 32-bit constants and uses the U-type format. LUI places the U-immediate value in the top 20 bits of the destination register rd, filling in the lowest 12 bits with zeros.
                    I_ALU_JMP_N <= '1';
                    I_REG_WR_N 	<= '0'; 
                    I_REG_DATA_RD_31D0 <= DECODER_IMM_U_19D0 & "000000000000";
                    
                when C_AUIPC =>
                    -- AUIPC (add upper immediate to pc) is used to build pc-relative addresses and uses the U-type format. AUIPC forms a 32-bit offset from the 20-bit U-immediate, filling in the lowest 12 bits with zeros, adds this offset to the address of the AUIPC instruction, then places the result in register rd
                    I_ALU_JMP_N <= '1';
                    I_REG_WR_N	<= '0';
                    I_REG_DATA_RD_31D0 <= std_logic_vector(unsigned(FIFO_ADDR_31D0) + unsigned(DECODER_IMM_U_19D0 & "000000000000"));

                when C_JAL =>
                    -- The jump and link (JAL) instruction uses the J-type format, where the J-immediate encodes a signed offset in multiples of 2 bytes. The offset is sign-extended and added to the address of the jump instruction to form the jump target address. Jumps can therefore target a ±1MiB range. JAL stores the address of the instruction following the jump (pc+4) into register rd. The standard software calling convention uses x1 as the return address register and x5 as an alternate link register.
                    I_ALU_JMP_N <= '0';
                    I_REG_WR_N 	<= '0';
                    x1 := to_integer(unsigned(FIFO_ADDR_31D0));                    
                    x2 := to_integer(resize(signed(DECODER_IMM_J_19D0&'0'),32));
                    y1 := x1 + x2;
                    I_ALU_JMP_TARGET_31D0 <= std_logic_vector(to_unsigned(y1,32));           I_REG_DATA_RD_31D0 <= std_logic_vector(unsigned(FIFO_ADDR_31D0) + 1);
                    
                when C_JALR =>
                    -- The indirect jump instruction JALR (jump and link register) uses the I-type encoding. The target address is obtained by adding the sign-extended 12-bit I-immediate to the register rs1, then setting the least-significant bit of the result to zero. The address of the instruction following the jump (pc+4) is written to register rd. Register x0 can be used as the destination if the result is not required
                    I_ALU_JMP_N <= '0';
                    I_REG_WR_N <= '0';
                    x1 := to_integer(unsigned(REG_DATA_RS1_31D0)); 
                    x2 := to_integer(resize(signed(DECODER_IMM_I_11D0),32));
                    y1 := x1 + x2;
                    u1 := to_unsigned(y1,32);
                    I_ALU_JMP_TARGET_31D0 <= std_logic_vector(u1(31 downto 1) & '0'); I_REG_DATA_RD_31D0 <= std_logic_vector(unsigned(FIFO_ADDR_31D0) + 1);
                    
                when C_BRANCH =>
                    -- All branch instructions use the B-type instruction format. The 12-bit B-immediate encodes signed offsets in multiples of 2 bytes. The offset is sign-extended and added to the address of the branch instruction to give the target address. The conditional branch range is ±4KiB.
                    I_REG_WR_N <= '1';
                    x1 := to_integer(unsigned(FIFO_ADDR_31D0));                    
                    x2 := to_integer(resize(signed(DECODER_IMM_B_11D0&'0'),32));
                    y1 := x1 + x2;
                    I_ALU_JMP_TARGET_31D0 <= std_logic_vector(to_unsigned(y1,32));
                    case DECODER_FUNCT3_2D0 is 
                        when C_F3_BEQ =>
                            if unsigned(REG_DATA_RS1_31D0) = unsigned(REG_DATA_RS2_31D0) then
                                I_ALU_JMP_N <= '0';
                            else
                                I_ALU_JMP_N <= '1';
                            end if;
                        when C_F3_BNE =>
                            if unsigned(REG_DATA_RS1_31D0) /= unsigned(REG_DATA_RS2_31D0) then
                                I_ALU_JMP_N <= '0';
                            else
                                I_ALU_JMP_N <= '1';
                            end if;
                        when C_F3_BLT =>
                            if signed(REG_DATA_RS1_31D0) < signed(REG_DATA_RS2_31D0) then
                                I_ALU_JMP_N <= '0';
                            else
                                I_ALU_JMP_N <= '1';
                            end if;
                        when C_F3_BLTU =>
                            if unsigned(REG_DATA_RS1_31D0) < unsigned(REG_DATA_RS2_31D0) then
                                I_ALU_JMP_N <= '0';
                            else
                                I_ALU_JMP_N <= '1';
                            end if;
                        when C_F3_BGE =>
                            if signed(REG_DATA_RS1_31D0) > signed(REG_DATA_RS2_31D0) then
                                I_ALU_JMP_N <= '0';
                            else
                                I_ALU_JMP_N <= '1';
                            end if;
                        when C_F3_BGEU =>
                            if unsigned(REG_DATA_RS1_31D0) > unsigned(REG_DATA_RS2_31D0) then
                                I_ALU_JMP_N <= '0';
                            else
                                I_ALU_JMP_N <= '1';
                            end if;
                        when others =>
                            I_ALU_JMP_N <= '1';
                            null;
                    end case;
                    
                when C_LOAD =>
                    I_ALU_JMP_N <= '1';
                    case S_LOAD is 
                        when A =>
                            -- Calculate memory address and set mem read signal and indicate the alu is doing a multi clk load operation
                            I_REG_WR_N      <= '1';
                            I_MEM_RD_N      <= '0';
                            I_MEM_WR_N      <= '1';
                            I_ALU_BUSY_N    <= '0';  
                            S_LOAD          <= B;
                            LOAD_COUNTER_3D0<= "0000";                            
                            x1 := to_integer(unsigned(REG_DATA_RS1_31D0));                    
                            x2 := to_integer(resize(signed(DECODER_IMM_I_11D0),32));
                            y1 := x1 + x2;
                            I_MEM_ADDR_31D0 <= std_logic_vector(to_unsigned(y1,32));
                        when B => 
                            if MEM_DATA_GOOD_N = '1' then
                            -- ALU waits in an idle state until the data it has requested is ready
                                I_REG_WR_N      <= '1';
                                I_MEM_RD_N      <= '1';
                                I_MEM_WR_N      <= '1';   
                                I_ALU_BUSY_N    <= '0';                                
                            else
                            -- The reg_write flag is set and the data is passed to the rd_data bus while being formatted as requested
                                I_REG_WR_N      <= '0';
                                I_MEM_RD_N      <= '1';
                                I_MEM_WR_N      <= '1';   
                                I_ALU_BUSY_N    <= '1';
                                S_LOAD          <= A;
                                case DECODER_FUNCT3_2D0 is
                                    when C_F3_LW => 
                                        -- The LW instruction loads a 32-bit value from memory into rd.                                    
                                        I_REG_DATA_RD_31D0 <= I_MEM_DATA_OUT_31D0;
                                    when C_F3_LH => 
                                        --  LH loads a 16-bit value from memory, then sign-extends to 32-bits before storing in rd.
                                        I_REG_DATA_RD_31D0 <= std_logic_vector(resize(signed(I_MEM_DATA_OUT_31D0(15 downto 0)),I_REG_DATA_RD_31D0'length));
                                    when C_F3_LHU => 
                                        -- LHU loads a 16-bit value from memory but then zero extends to 32-bits before storing in rd.
                                        I_REG_DATA_RD_31D0 <= std_logic_vector(resize(unsigned(I_MEM_DATA_OUT_31D0(15 downto 0)),I_REG_DATA_RD_31D0'length));
                                    when C_F3_LB => 
                                        --  LB loads a 8-bit value from memory, then sign-extends to 32-bits before storing in rd.
                                        I_REG_DATA_RD_31D0 <= std_logic_vector(resize(signed(I_MEM_DATA_OUT_31D0(7 downto 0)),I_REG_DATA_RD_31D0'length));
                                    when C_F3_LBU => 
                                        -- LHU loads a 8-bit value from memory but then zero extends to 32-bits before storing in rd.   
                                        I_REG_DATA_RD_31D0 <= std_logic_vector(resize(unsigned(I_MEM_DATA_OUT_31D0(7 downto 0)),I_REG_DATA_RD_31D0'length));
									when others => 
										null;
                                end case;
                            end if;                            
                        when others => 
                            null;
                    end case;
                    
                when C_STORE =>
					I_ALU_JMP_N 	<= '1';
					I_REG_WR_N      <= '1';
					I_MEM_RD_N      <= '1';
					I_MEM_WR_N      <= '0';
					I_ALU_BUSY_N    <= '0';  
					x1 := to_integer(unsigned(REG_DATA_RS1_31D0));                    
					x2 := to_integer(resize(signed(DECODER_IMM_S_11D0),32));
					y1 := x1 + x2;
					I_MEM_ADDR_31D0 <= std_logic_vector(to_unsigned(y1,32));
					case DECODER_FUNCT3_2D0 is 
						when C_F3_SW => 
							test := true;
							I_MEM_DATA_IN_31D0 <= REG_DATA_RS2_31D0;
						when C_F3_SH => 
							I_MEM_DATA_IN_31D0 <= X"0000" & REG_DATA_RS2_31D0(15 downto 0);
						when C_F3_SB => 
							I_MEM_DATA_IN_31D0 <= X"000000" & REG_DATA_RS2_31D0(7 downto 0);
						when others =>
							null;
					end case;
                    
                when others =>
                    null;                           
            end case;                        
        else
			I_MEM_RD_N      		<= '1';
			I_MEM_WR_N      		<= '1';   
			I_ALU_BUSY_N    		<= '1';
            I_ALU_JMP_N             <= '1';
            I_REG_WR_N              <= '1';
            I_ALU_JMP_TARGET_31D0   <= (others=>'Z');
            I_REG_DATA_RD_31D0      <= (others=>'Z');
        end if;  
    end if;
end if;
end process;
    

    
end RTL; 