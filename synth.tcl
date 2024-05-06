# TODO: figure out how to use liberty files to get graph from DC netlist if library.tcl not functional
source ./library.tcl

source ./set_src.tcl

# Define synthesis 
set SKY130_PATH $::env(SKY130_PATH)
set LIB_WC_FILE   $SKY130_PATH/sky130_osu_sc_12T_hs_tt_1P20_25C.ccs.lib
set MAX_DELAY $::env(MAX_DELAY)
set CLK $::env(CLK)
set CONST_FILE $::env(CONST_FILE)

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
yosys abc -D $MAX_DELAY -liberty $LIB_WC_FILE -clk $CLK -constr $CONST_FILE
yosys clean
yosys write_verilog $SYNTH_DIR/${MODULE_NAME}.v
yosys stat -liberty $LIB_WC_FILE



