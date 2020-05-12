library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TOP_STRUCT is
    port(
        CLK     : in std_logic;
        RST_N   : in std_logic
    );
end TOP_STRUCT;

architecture STRUCT of TOP_STRUCT is

    component PC is
        port(
            CLK			        : in std_logic;
            RST_N               : in std_logic;
            CE_PC_N             : in std_logic;
            PC_JMP_N            : in std_logic;
            PC_ADDR_IN_31D0	    : in std_logic_vector(31 downto 0);
            
            PC_ADDR_OUT_31D0    : out std_logic_vector(31 downto 0)
        );
    end component;
        
    component ROM is
    	port(
            CLK			        : in std_logic;
            RST_N               : in std_logic;
            CE_ROM_N            : in std_logic;
            PC_ADDR_OUT_31D0    : in std_logic_vector(31 downto 0);
            
            INSTRUCTION_31D0    : out std_logic_vector(31 downto 0)
		);
    end component;
        
    component DECODER is
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
    end component;
    
    component CTRL is
        port(
            CLK             : in std_logic;
            RST_N           : in std_logic;
            
            CE_DECODER_N    : out std_logic;    
            CE_PC_N         : out std_logic;
            CE_ROM_N        : out std_logic;
            CE_REG_N        : out std_logic;
            CE_ALU_N        : out std_logic
        );
    end component;

    component REG_FILE
        port(
            CLK                 : in std_logic;
            CE_REG_N            : in std_logic;
            RST_N               : in std_logic;
            REG_WR_N            : in std_logic;
            DECODER_RD_4D0      : in std_logic_vector(4 downto 0);
            DECODER_RS1_4D0     : in std_logic_vector(4 downto 0);
            DECODER_RS2_4D0     : in std_logic_vector(4 downto 0); 
            REG_DATA_RD_31D0        : in std_logic_vector(31 downto 0);        
--            INSTRUCTION_IN_32D0 : in std_logic_vector(31 downto 0);

            REG_DATA_RS1_31D0   : out std_logic_vector(31 downto 0);    
            REG_DATA_RS2_31D0   : out std_logic_vector(31 downto 0)
--            INSTRUCTION_OUT_32D0: out std_logic_vector(31 downto 0)
        );
    end component;
    
    component STD_FIFO
    	Generic (
            constant DATA_WIDTH : positive := 32;
            constant FIFO_DEPTH	: positive := 8
        );
        Port ( 
            CLK		            : in  std_logic;
            RST_N	            : in  std_logic;
            FIFO_WR_N	        : in  std_logic;
            FIFO_DATA_IN_31D0	: in  std_logic_vector (DATA_WIDTH - 1 downto 0);
            FIFO_RD_N	        : in  std_logic;
            FIFO_DATA_OUT_31D0	: out std_logic_vector (DATA_WIDTH - 1 downto 0);
            FIFO_EMPTY_N	        : out std_logic;
            FIFO_FULL_N	        : out std_logic
        );
    end component;
    
    component ALU
    port(
        CLK                 : in std_logic;
        RST_N               : in std_logic;      
        CE_ALU_N            : in std_logic;       
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
        REG_WR_N            : out std_logic;
        REG_DATA_RD_31D0    : out std_logic_vector(31 downto 0);
		REG_SEL_RD_4D0		: out std_logic_vector(4 downto 0);
        ALU_JMP_N           : out std_logic;
        ALU_JMP_TARGET_31D0 : out std_logic_vector(31 downto 0);       
        MEM_WR_N            : out std_logic;
        MEM_RD_N            : out std_logic;
        MEM_ADDR_31D0       : out std_logic_vector(31 downto 0);
        MEM_DATA_IN_31D0    : out std_logic_vector(31 downto 0);
        MEM_DATA_OUT_31D0   : in std_logic_vector(31 downto 0)
        
    );
    end component;
	
	component STD_RAM
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
	end component;
    
    constant DATA_WIDTH : positive := 32;
    constant FIFO_DEPTH	: positive := 8;
            
    signal CE_PC_N                  : std_logic;
    signal CE_ROM_N                 : std_logic;
    signal CE_DECODER_N             : std_logic;
    signal CE_REG_N                 : std_logic;
    signal CE_ALU_N                 : std_logic;
                                
    signal PC_JMP_N                 : std_logic;
    signal PC_ADDR_IN_31D0          : std_logic_vector(31 downto 0);
    signal PC_ADDR_OUT_31D0         : std_logic_vector(31 downto 0);
    
    signal INSTRUCTION_31D0         : std_logic_vector(31 downto 0);
    
    signal DECODER_OP_6D0           : std_logic_vector(6 downto 0);
    signal DECODER_RD_4D0           : std_logic_vector(4 downto 0);
    signal DECODER_RS1_4D0          : std_logic_vector(4 downto 0);
    signal DECODER_RS2_4D0          : std_logic_vector(4 downto 0);
    signal DECODER_FUNCT3_2D0       : std_logic_vector(2 downto 0);
    signal DECODER_FUNCT7_6D0       : std_logic_vector(6 downto 0);
    signal DECODER_IMM_B_11D0       : std_logic_vector(11 downto 0);
    signal DECODER_IMM_I_11D0       : std_logic_vector(11 downto 0);
    signal DECODER_IMM_J_19D0       : std_logic_vector(19 downto 0);
    signal DECODER_IMM_S_11D0       : std_logic_vector(11 downto 0);
    signal DECODER_IMM_U_19D0       : std_logic_vector(19 downto 0);
    signal DECODER_BUF_OP_6D0       : std_logic_vector(6 downto 0);
    signal DECODER_BUF_RD_4D0       : std_logic_vector(4 downto 0);
    signal DECODER_BUF_RS1_4D0      : std_logic_vector(4 downto 0);
    signal DECODER_BUF_RS2_4D0      : std_logic_vector(4 downto 0);
    signal DECODER_BUF_FUNCT3_2D0   : std_logic_vector(2 downto 0);
    signal DECODER_BUF_FUNCT7_6D0   : std_logic_vector(6 downto 0);
    signal DECODER_BUF_IMM_B_11D0   : std_logic_vector(11 downto 0);
    signal DECODER_BUF_IMM_I_11D0   : std_logic_vector(11 downto 0);
    signal DECODER_BUF_IMM_J_19D0   : std_logic_vector(19 downto 0);
    signal DECODER_BUF_IMM_S_11D0   : std_logic_vector(11 downto 0);
    signal DECODER_BUF_IMM_U_19D0   : std_logic_vector(19 downto 0);

    signal REG_WR_N                 : std_logic;
    signal REG_DATA_RS1_31D0        : std_logic_vector(31 downto 0);    
    signal REG_DATA_RS2_31D0        : std_logic_vector(31 downto 0);
    signal REG_DATA_RD_31D0         : std_logic_vector(31 downto 0);
    signal REG_SEL_RD_4D0    		: std_logic_vector(4 downto 0);
	    
    --signal FIFO_RD_N	            : std_logic;
    signal FIFO_ADDR_31D0	        : std_logic_vector (DATA_WIDTH - 1 downto 0);
    signal FIFO_EMPTY_N	            : std_logic;
    signal FIFO_FULL_N	            : std_logic;    
        
    signal ALU_JMP_N                : std_logic;
    signal ALU_JMP_TARGET_31D0      : std_logic_vector(31 downto 0);
	
	signal MEM_DATA_GOOD_N			: std_logic;
	signal MEM_WR_N         		: std_logic;
	signal MEM_RD_N         		: std_logic;
	signal MEM_ADDR_31D0    		: std_logic_vector(31 downto 0);
	signal MEM_DATA_IN_31D0 		: std_logic_vector(31 downto 0);
	signal MEM_DATA_OUT_31D0		: std_logic_vector(31 downto 0);
	    
begin
    
    PC1:PC port map(
        CLK			        => CLK,			    
        RST_N               => RST_N,           
        CE_PC_N             => CE_PC_N,         
        PC_JMP_N            => PC_JMP_N,        
        PC_ADDR_IN_31D0	    => PC_ADDR_IN_31D0,	
        PC_ADDR_OUT_31D0    => PC_ADDR_OUT_31D0
    );
    
    ROM1:ROM port map(
        CLK			        => CLK,			    
        RST_N               => RST_N,           
        CE_ROM_N            => CE_ROM_N,        
        PC_ADDR_OUT_31D0    => PC_ADDR_OUT_31D0,
        INSTRUCTION_31D0    => INSTRUCTION_31D0
    );
    
    DECODER1:DECODER port map(
        CLK                 => CLK,               
        CE_DECODER_N        => CE_DECODER_N,      
        RST_N               => RST_N,             
        INSTRUCTION_31D0    => INSTRUCTION_31D0,  
        DECODER_OP_6D0      => DECODER_OP_6D0,     
        DECODER_RD_4D0      => DECODER_RD_4D0,     
        DECODER_RS1_4D0     => DECODER_RS1_4D0,    
        DECODER_RS2_4D0     => DECODER_RS2_4D0,    
        DECODER_FUNCT3_2D0  => DECODER_FUNCT3_2D0,
        DECODER_FUNCT7_6D0  => DECODER_FUNCT7_6D0,
        DECODER_IMM_B_11D0  => DECODER_IMM_B_11D0,
        DECODER_IMM_I_11D0  => DECODER_IMM_I_11D0,
        DECODER_IMM_J_19D0  => DECODER_IMM_J_19D0,
        DECODER_IMM_S_11D0  => DECODER_IMM_S_11D0,
        DECODER_IMM_U_19D0  => DECODER_IMM_U_19D0,
        DECODER_BUF_OP_6D0      => DECODER_BUF_OP_6D0,    
        DECODER_BUF_RD_4D0      => DECODER_BUF_RD_4D0,    
        DECODER_BUF_RS1_4D0     => DECODER_BUF_RS1_4D0,   
        DECODER_BUF_RS2_4D0     => DECODER_BUF_RS2_4D0,   
        DECODER_BUF_FUNCT3_2D0  => DECODER_BUF_FUNCT3_2D0,
        DECODER_BUF_FUNCT7_6D0  => DECODER_BUF_FUNCT7_6D0,
        DECODER_BUF_IMM_B_11D0  => DECODER_BUF_IMM_B_11D0,
        DECODER_BUF_IMM_I_11D0  => DECODER_BUF_IMM_I_11D0,
        DECODER_BUF_IMM_J_19D0  => DECODER_BUF_IMM_J_19D0,
        DECODER_BUF_IMM_S_11D0  => DECODER_BUF_IMM_S_11D0,
        DECODER_BUF_IMM_U_19D0  => DECODER_BUF_IMM_U_19D0
    );
    
    CTRL1:CTRL port map(
        CLK                 => CLK,         
        RST_N               => RST_N,                                     
        CE_DECODER_N        => CE_DECODER_N,
        CE_PC_N             => CE_PC_N,
        CE_ROM_N            => CE_ROM_N,
        CE_REG_N            => CE_REG_N,
        CE_ALU_N            => CE_ALU_N
    );
    
    REG_FILE1:REG_FILE port map(
        CLK                 => CLK,              
        CE_REG_N            => CE_REG_N,         
        RST_N               => RST_N,            
        REG_WR_N            => REG_WR_N,         
        DECODER_RD_4D0      => REG_SEL_RD_4D0,   
        DECODER_RS1_4D0     => DECODER_RS1_4D0,  
        DECODER_RS2_4D0     => DECODER_RS2_4D0,  
        REG_DATA_RD_31D0    => REG_DATA_RD_31D0,         
        REG_DATA_RS1_31D0   => REG_DATA_RS1_31D0,
        REG_DATA_RS2_31D0   => REG_DATA_RS2_31D0
    );
    
    PC_FIFO:STD_FIFO port map(
        CLK                 => CLK,         
        RST_N               => RST_N,
        FIFO_WR_N	        => CE_ROM_N,	     
        FIFO_DATA_IN_31D0   => PC_ADDR_OUT_31D0,
        FIFO_RD_N	        => CE_REG_N,	     
        FIFO_DATA_OUT_31D0  => FIFO_ADDR_31D0,
        FIFO_EMPTY_N	    => FIFO_EMPTY_N,	     
        FIFO_FULL_N	        => FIFO_FULL_N
    );
    
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
        ALU_JMP_TARGET_31D0 => ALU_JMP_TARGET_31D0,
		MEM_DATA_GOOD_N		=> MEM_DATA_GOOD_N,	
		MEM_WR_N            => MEM_WR_N,         
		MEM_RD_N            => MEM_RD_N,         
		MEM_ADDR_31D0       => MEM_ADDR_31D0,    
		MEM_DATA_IN_31D0    => MEM_DATA_IN_31D0, 
		MEM_DATA_OUT_31D0   => MEM_DATA_OUT_31D0
    );     

	RAM1:STD_RAM port map(
		CLK             	=> CLK,
	    RST_N               => RST_N,
	    WR_N                => MEM_WR_N,
	    RD_N                => MEM_RD_N,
	    ADDR_31D0           => MEM_ADDR_31D0, 
	    DATA_IN_31D0    	=> MEM_DATA_IN_31D0,    
	    DATA_GOOD_N		    => MEM_DATA_GOOD_N,
	    DATA_OUT_31D0       => MEM_DATA_OUT_31D0
	);
	
                     
	-- WIRES
	PC_JMP_N  		<= ALU_JMP_N;     
	PC_ADDR_IN_31D0 <= ALU_JMP_TARGET_31D0;
	
end STRUCT;                 