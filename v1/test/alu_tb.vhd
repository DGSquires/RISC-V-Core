-- ALU is designed using Chapter 24 & Chapter 2 of the Volume 1 RISC-V unprivillged ISA 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
    
entity ALU is
end ALU;

architecture RTL of ALU is 
    component ALU is
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
        
        REG_WR_N            : out std_logic;
        REG_DATA_RD_31D0    : out std_logic_vector(31 downto 0);
		REG_SEL_RD_4D0		: out std_logic_vector(4 downto 0);
        ALU_JMP_N           : out std_logic;
        ALU_JMP_TARGET_31D0 : out std_logic_vector(31 downto 0);
        
        MEM_WR_N            : out std_logic;
        MEM_RD_N            : out std_logic;
        MEM_ADDR_31D0       : out std_logic_vector(31 downto 0);
        MEM_DATA_IN_31D0    : out std_logic_vector(31 downto 0);
        MEM_DATA_OUT_31D0   : out std_logic_vector(31 downto 0)
        
    );
    end component;
    
    signal  CLK                 : std_logic;
    signal  RST_N               : std_logic;
      
    signal  CE_ALU_N            : std_logic;
      
    signal  DECODER_OP_6D0      : std_logic_vector(6 downto 0);
    signal  DECODER_RD_4D0      : std_logic_vector(4 downto 0);
    signal  DECODER_RS1_4D0     : std_logic_vector(4 downto 0);
    signal  DECODER_RS2_4D0     : std_logic_vector(4 downto 0);
    signal  DECODER_FUNCT3_2D0  : std_logic_vector(2 downto 0);
    signal  DECODER_FUNCT7_6D0  : std_logic_vector(6 downto 0);
    signal  DECODER_IMM_B_11D0  : std_logic_vector(11 downto 0);
    signal  DECODER_IMM_I_11D0  : std_logic_vector(11 downto 0);
    signal  DECODER_IMM_J_19D0  : std_logic_vector(19 downto 0);
    signal  DECODER_IMM_S_11D0  : std_logic_vector(11 downto 0);
    signal  DECODER_IMM_U_19D0  : std_logic_vector(19 downto 0);
      
    signal  REG_DATA_RS1_31D0   : std_logic_vector(31 downto 0); 
    signal  REG_DATA_RS2_31D0   : std_logic_vector(31 downto 0);
      
    signal  FIFO_ADDR_31D0      : std_logic_vector(31 downto 0);
      
    signal  REG_WR_N            : std_logic;
    signal  REG_DATA_RD_31D0    : std_logic_vector(31 downto 0);
    signal  REG_SEL_RD_4D0		: std_logic_vector(4 downto 0);
    signal  ALU_JMP_N           : std_logic;
    signal  ALU_JMP_TARGET_31D0 : std_logic_vector(31 downto 0);
      
    signal  MEM_WR_N            : std_logic;
    signal  MEM_RD_N            : std_logic;
    signal  MEM_ADDR_31D0       : std_logic_vector(31 downto 0);
    signal  MEM_DATA_IN_31D0    : std_logic_vector(31 downto 0);
    signal  MEM_DATA_OUT_31D0   : std_logic_vector(31 downto 0);

begin

    ALU1:ALU port map(
        CLK                 => CLK,       
        RST_N               => RST_N,                                
        CE_ALU_N            => CE_ALU_N,                           
        DECODER_OP_6D0      => DECODER_BUF_OP_6D0,    
        DECODER_RD_4D0      => DECODER_BUF_RD_4D0,    
        DECODER_RS1_4D0     => DECODER_BUF_RS1_4D0,   
        DECODER_RS2_4D0     => DECODER_BUF_RS2_4D0,   
        DECODER_FUNCT3_2D0  => DECODER_BUF_FUNCT3_2D0,
        DECODER_FUNCT7_6D0  => DECODER_BUF_FUNCT7_6D0,
        DECODER_IMM_B_11D0  => DECODER_BUF_IMM_B_11D0,
        DECODER_IMM_I_11D0  => DECODER_BUF_IMM_I_11D0,
        DECODER_IMM_J_19D0  => DECODER_BUF_IMM_J_19D0,
        DECODER_IMM_S_11D0  => DECODER_BUF_IMM_S_11D0,
        DECODER_IMM_U_19D0  => DECODER_BUF_IMM_U_19D0,        
        REG_DATA_RS1_31D0   => REG_DATA_RS1_31D0, 
        REG_DATA_RS2_31D0   => REG_DATA_RS2_31D0,         
        FIFO_ADDR_31D0      => FIFO_ADDR_31D0,                           
        REG_WR_N            => REG_WR_N,        
        REG_DATA_RD_31D0    => REG_DATA_RD_31D0,
		REG_SEL_RD_4D0		=> REG_SEL_RD_4D0,
        ALU_JMP_N           => ALU_JMP_N,          
        ALU_JMP_TARGET_31D0 => ALU_JMP_TARGET_31D0
    );
    
    
    
end RTL; 