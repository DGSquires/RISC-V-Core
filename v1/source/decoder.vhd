library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
    
entity DECODER is
    port(
        CLK                 : in std_logic;
        CE_DECODER_N        : in std_logic;
        RST_N               : in std_logic;
        INSTRUCTION_31D0    : in std_logic_vector(31 downto 0);
        
        DECODER_OP_6D0      : out std_logic_vector(6 downto 0);
        DECODER_RD_4D0      : out std_logic_vector(4 downto 0);
        DECODER_RS1_4D0     : out std_logic_vector(4 downto 0);
        DECODER_RS2_4D0     : out std_logic_vector(4 downto 0);
        DECODER_FUNCT3_2D0  : out std_logic_vector(2 downto 0);
        DECODER_FUNCT7_6D0  : out std_logic_vector(6 downto 0);
        DECODER_IMM_B_11D0  : out std_logic_vector(11 downto 0);
        DECODER_IMM_I_11D0  : out std_logic_vector(11 downto 0);
        DECODER_IMM_J_19D0  : out std_logic_vector(19 downto 0);
        DECODER_IMM_S_11D0  : out std_logic_vector(11 downto 0);
        DECODER_IMM_U_19D0  : out std_logic_vector(19 downto 0);

        DECODER_BUF_OP_6D0      : out std_logic_vector(6 downto 0);
        DECODER_BUF_RD_4D0      : out std_logic_vector(4 downto 0);
        DECODER_BUF_RS1_4D0     : out std_logic_vector(4 downto 0);
        DECODER_BUF_RS2_4D0     : out std_logic_vector(4 downto 0);
        DECODER_BUF_FUNCT3_2D0  : out std_logic_vector(2 downto 0);
        DECODER_BUF_FUNCT7_6D0  : out std_logic_vector(6 downto 0);
        DECODER_BUF_IMM_B_11D0  : out std_logic_vector(11 downto 0);
        DECODER_BUF_IMM_I_11D0  : out std_logic_vector(11 downto 0);
        DECODER_BUF_IMM_J_19D0  : out std_logic_vector(19 downto 0);
        DECODER_BUF_IMM_S_11D0  : out std_logic_vector(11 downto 0);
        DECODER_BUF_IMM_U_19D0  : out std_logic_vector(19 downto 0)
      
    );
        
end DECODER;

architecture RTL of DECODER is 

        signal I_DECODER_OP_6D0      : std_logic_vector(6 downto 0);
        signal I_DECODER_RD_4D0      : std_logic_vector(4 downto 0);
        signal I_DECODER_RS1_4D0     : std_logic_vector(4 downto 0);
        signal I_DECODER_RS2_4D0     : std_logic_vector(4 downto 0);
        signal I_DECODER_FUNCT3_2D0  : std_logic_vector(2 downto 0);
        signal I_DECODER_FUNCT7_6D0  : std_logic_vector(6 downto 0);
        signal I_DECODER_IMM_B_11D0  : std_logic_vector(11 downto 0);
        signal I_DECODER_IMM_I_11D0  : std_logic_vector(11 downto 0);
        signal I_DECODER_IMM_J_19D0  : std_logic_vector(19 downto 0);
        signal I_DECODER_IMM_S_11D0  : std_logic_vector(11 downto 0);
        signal I_DECODER_IMM_U_19D0  : std_logic_vector(19 downto 0);

begin

        DECODER_OP_6D0      <= I_DECODER_OP_6D0;    
        DECODER_RD_4D0      <= I_DECODER_RD_4D0;    
        DECODER_RS1_4D0     <= I_DECODER_RS1_4D0;   
        DECODER_RS2_4D0     <= I_DECODER_RS2_4D0;   
        DECODER_FUNCT3_2D0  <= I_DECODER_FUNCT3_2D0;
        DECODER_FUNCT7_6D0  <= I_DECODER_FUNCT7_6D0;
        DECODER_IMM_B_11D0  <= I_DECODER_IMM_B_11D0;
        DECODER_IMM_I_11D0  <= I_DECODER_IMM_I_11D0;
        DECODER_IMM_J_19D0  <= I_DECODER_IMM_J_19D0;
        DECODER_IMM_S_11D0  <= I_DECODER_IMM_S_11D0;
        DECODER_IMM_U_19D0  <= I_DECODER_IMM_U_19D0;
        
    decode_proc:process(CLK)
    begin  
        if rising_edge(CLK) then
            if RST_N = '0' then
                I_DECODER_OP_6D0      <= (others=>'0');
                I_DECODER_RD_4D0      <= (others=>'0');
                I_DECODER_RS1_4D0     <= (others=>'0');
                I_DECODER_RS2_4D0     <= (others=>'0');
                I_DECODER_FUNCT3_2D0  <= (others=>'0');
                I_DECODER_FUNCT7_6D0  <= (others=>'0');
                I_DECODER_IMM_B_11D0  <= (others=>'0');
                I_DECODER_IMM_I_11D0  <= (others=>'0');
                I_DECODER_IMM_J_19D0  <= (others=>'0');
                I_DECODER_IMM_S_11D0  <= (others=>'0');
                I_DECODER_IMM_U_19D0  <= (others=>'0');
            else
                if CE_DECODER_N = '0' then
                    I_DECODER_OP_6D0      <= INSTRUCTION_31D0(6 downto 0);
                    I_DECODER_RD_4D0      <= INSTRUCTION_31D0(11 downto 7);
                    I_DECODER_RS1_4D0     <= INSTRUCTION_31D0(19 downto 15);
                    I_DECODER_RS2_4D0     <= INSTRUCTION_31D0(24 downto 20);
                    I_DECODER_FUNCT3_2D0  <= INSTRUCTION_31D0(14 downto 12);
                    I_DECODER_FUNCT7_6D0  <= INSTRUCTION_31D0(31 downto 25);
                    I_DECODER_IMM_B_11D0  <= INSTRUCTION_31D0(31) & INSTRUCTION_31D0(7) & INSTRUCTION_31D0(30 downto 25) & INSTRUCTION_31D0(11 downto 8);
                    I_DECODER_IMM_I_11D0  <= INSTRUCTION_31D0(31 downto 20);
                    I_DECODER_IMM_J_19D0  <= INSTRUCTION_31D0(31) & INSTRUCTION_31D0(19 downto 12) & INSTRUCTION_31D0(20) & INSTRUCTION_31D0(30 downto 21);
                    I_DECODER_IMM_S_11D0  <= INSTRUCTION_31D0(31 downto 25) & INSTRUCTION_31D0(11 downto 7);
                    I_DECODER_IMM_U_19D0  <= INSTRUCTION_31D0(31 downto 12);                    
                else
                    I_DECODER_OP_6D0      <= (others=>'Z');
                    I_DECODER_RD_4D0      <= (others=>'Z');
                    I_DECODER_RS1_4D0     <= (others=>'Z');
                    I_DECODER_RS2_4D0     <= (others=>'Z');
                    I_DECODER_FUNCT3_2D0  <= (others=>'Z');
                    I_DECODER_FUNCT7_6D0  <= (others=>'Z');
                    I_DECODER_IMM_B_11D0  <= (others=>'Z');
                    I_DECODER_IMM_I_11D0  <= (others=>'Z');
                    I_DECODER_IMM_J_19D0  <= (others=>'Z');                    
                    I_DECODER_IMM_S_11D0  <= (others=>'Z');
                    I_DECODER_IMM_U_19D0  <= (others=>'Z');                   
                end if;
                    DECODER_BUF_OP_6D0     <= I_DECODER_OP_6D0;    
                    DECODER_BUF_RD_4D0     <= I_DECODER_RD_4D0;    
                    DECODER_BUF_RS1_4D0    <= I_DECODER_RS1_4D0;   
                    DECODER_BUF_RS2_4D0    <= I_DECODER_RS2_4D0;   
                    DECODER_BUF_FUNCT3_2D0 <= I_DECODER_FUNCT3_2D0;
                    DECODER_BUF_FUNCT7_6D0 <= I_DECODER_FUNCT7_6D0;
                    DECODER_BUF_IMM_B_11D0 <= I_DECODER_IMM_B_11D0;
                    DECODER_BUF_IMM_I_11D0 <= I_DECODER_IMM_I_11D0;
                    DECODER_BUF_IMM_J_19D0 <= I_DECODER_IMM_J_19D0;
                    DECODER_BUF_IMM_S_11D0 <= I_DECODER_IMM_S_11D0;
                    DECODER_BUF_IMM_U_19D0 <= I_DECODER_IMM_U_19D0;
            end if;
        end if;
    end process;
    
end RTL; 