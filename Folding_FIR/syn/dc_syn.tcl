#erarchy Read All Files
read_file -format verilog ../src/FIR.v
current_design FIR
link
compile_ultra -retime
#Setting Clock Constraints
source -echo -verbose FIR.sdc
check_design
uniquify
set_fix_multiple_port_nets  -all -buffer_constants

#compile -map_effort high -area_effort high
compile_ultra
write -format ddc     -hierarchy -output "FIR_syn.ddc"
write_sdf -version 1.0  FIR_syn.sdf
write -format verilog -hierarchy -output FIR_syn.v
report_area -hierarchy > area.log
report_timing > timing.log
report_cell [get_cells -hier *] > cell.log
report_power -analysis_effort high -verbose > power.log
report_qor   >  FIR_syn.qor
