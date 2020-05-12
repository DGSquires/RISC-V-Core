echo ##################################################
echo # Running Script
echo ##################################################
set top_path    C:/Users/dylan/OneDrive/Documents/CPU/v1
set design_path $top_path/source
set tb_path     $top_path/test

echo ##################################################
echo # Creating Library
echo ##################################################
vlib ../design_lib 
vmap work ../design_lib

echo ##################################################
echo # Compiling Design
echo ################################################## 
vcom $design_path/pc.vhd
vcom $design_path/rom.vhd
vcom $design_path/decoder.vhd
vcom $design_path/ctrl.vhd
vcom $design_path/reg_file.vhd
vcom $design_path/top_struct.vhd
vcom $design_path/std_fifo.vhd
vcom $design_path/alu.vhd
vcom $design_path/std_ram.vhd


echo ##################################################
echo # Compiling Testbench
echo ##################################################
vcom $tb_path/top_struct_tb.vhd

echo ##################################################
echo # Simulating Design
echo ##################################################
vsim top_struct_tb
mem load -i $top_path/sim/rom_init.mem /top_struct_tb/UUT/ROM1/ROM
do wave.do
run 300