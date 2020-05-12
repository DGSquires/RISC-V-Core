onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_struct_tb/UUT/CLK
add wave -noupdate /top_struct_tb/UUT/RST_N
add wave -noupdate -group CLOCK_ENABLE /top_struct_tb/UUT/CE_PC_N
add wave -noupdate -group CLOCK_ENABLE /top_struct_tb/UUT/CE_ROM_N
add wave -noupdate -group CLOCK_ENABLE /top_struct_tb/UUT/CE_DECODER_N
add wave -noupdate -group CLOCK_ENABLE /top_struct_tb/UUT/CE_REG_N
add wave -noupdate -group CLOCK_ENABLE /top_struct_tb/UUT/CE_ALU_N
add wave -noupdate -expand -group PROGRSM_COUNTER /top_struct_tb/UUT/PC_JMP_N
add wave -noupdate -expand -group PROGRSM_COUNTER /top_struct_tb/UUT/PC_ADDR_IN_31D0
add wave -noupdate -expand -group PROGRSM_COUNTER /top_struct_tb/UUT/PC_ADDR_OUT_31D0
add wave -noupdate -expand -group PROGRSM_COUNTER /top_struct_tb/UUT/PC1/COUNTER
add wave -noupdate /top_struct_tb/UUT/INSTRUCTION_31D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_OP_6D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_RD_4D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_RS1_4D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_RS2_4D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_FUNCT3_2D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_FUNCT7_6D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_IMM_B_11D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_IMM_I_11D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_IMM_J_19D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_IMM_S_11D0
add wave -noupdate -group DECODER /top_struct_tb/UUT/DECODER1/DECODER_IMM_U_19D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_OP_6D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_RD_4D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_RS1_4D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_RS2_4D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_FUNCT3_2D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_FUNCT7_6D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_IMM_B_11D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_IMM_I_11D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_IMM_J_19D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_IMM_S_11D0
add wave -noupdate -expand -group DECODER_BUF /top_struct_tb/UUT/DECODER1/DECODER_BUF_IMM_U_19D0
add wave -noupdate -expand -group REGISTER_FILE /top_struct_tb/UUT/REG_WR_N
add wave -noupdate -expand -group REGISTER_FILE /top_struct_tb/UUT/REG_DATA_RS1_31D0
add wave -noupdate -expand -group REGISTER_FILE /top_struct_tb/UUT/REG_DATA_RS2_31D0
add wave -noupdate -expand -group REGISTER_FILE /top_struct_tb/UUT/REG_FILE1/REG
add wave -noupdate -expand -group FIFO_BUFFER /top_struct_tb/UUT/FIFO_ADDR_31D0
add wave -noupdate -expand -group FIFO_BUFFER /top_struct_tb/UUT/FIFO_EMPTY_N
add wave -noupdate -expand -group FIFO_BUFFER /top_struct_tb/UUT/FIFO_FULL_N
add wave -noupdate -expand -group ALU /top_struct_tb/UUT/ALU_JMP_N
add wave -noupdate -expand -group ALU /top_struct_tb/UUT/ALU_JMP_TARGET_31D0
add wave -noupdate -expand -group ALU -expand -group WRITEBACK /top_struct_tb/UUT/ALU1/REG_WR_N
add wave -noupdate -expand -group ALU -expand -group WRITEBACK /top_struct_tb/UUT/REG_DATA_RD_31D0
add wave -noupdate -expand -group ALU -expand -group WRITEBACK /top_struct_tb/UUT/ALU1/REG_SEL_RD_4D0
add wave -noupdate -expand -group ALU -expand -group ALU_MATH -radix decimal /top_struct_tb/UUT/ALU1/ALU_PROC/x1
add wave -noupdate -expand -group ALU -expand -group ALU_MATH -radix decimal /top_struct_tb/UUT/ALU1/ALU_PROC/x2
add wave -noupdate -expand -group ALU -expand -group ALU_MATH -radix decimal /top_struct_tb/UUT/ALU1/ALU_PROC/y1
add wave -noupdate -expand -group ALU -expand -group MEMORY /top_struct_tb/UUT/ALU1/MEM_DATA_GOOD_N
add wave -noupdate -expand -group ALU -expand -group MEMORY /top_struct_tb/UUT/ALU1/MEM_WR_N
add wave -noupdate -expand -group ALU -expand -group MEMORY /top_struct_tb/UUT/ALU1/MEM_RD_N
add wave -noupdate -expand -group ALU -expand -group MEMORY /top_struct_tb/UUT/ALU1/MEM_ADDR_31D0
add wave -noupdate -expand -group ALU -expand -group MEMORY /top_struct_tb/UUT/ALU1/MEM_DATA_IN_31D0
add wave -noupdate -expand -group ALU -expand -group MEMORY /top_struct_tb/UUT/ALU1/MEM_DATA_OUT_31D0
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/x1
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/x2
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/y1
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/u1
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/s_8
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/s_16
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/u_8
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/u_16
add wave -noupdate /top_struct_tb/UUT/ALU1/ALU_PROC/test
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {186 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 210
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {36 ns} {314 ns}
