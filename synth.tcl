# TODO: figure out how to use liberty files to get graph from DC netlist if library.tcl not functional
source ./library.tcl

source ./set_src.tcl

# Define synthesis 
set SKY130_PATH $::env(SKY130_PATH)
set LIB_WC_FILE   $SKY130_PATH/sky130_osu_sc_12T_hs_tt_1P20_25C.ccs.lib

set MODULE_NAME $::env(MODULE_NAME)
set SYNTH_DIR $::env(SYNTH_DIR)

# Process verilog files
yosys proc
yosys flatten
yosys memory
yosys opt
yosys techmap
yosys synth
yosys dfflibmap -liberty $LIB_WC_FILE
yosys abc -D 1000 -liberty $LIB_WC_FILE -dff
yosys clean
yosys write_verilog $SYNTH_DIR/${MODULE_NAME}.v



