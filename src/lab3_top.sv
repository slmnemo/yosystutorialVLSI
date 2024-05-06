// Top-level module for instantiation on the FPGA including the internal oscillator
//
// Written by Kaitlin Lucio
// Last modified: Sept 25, 2023

module top(
     input  logic resetB, clk,
     input  logic [3:0] colB,
     output logic       outputSel0, outputSel1,
     output logic [3:0] rowB,
     output logic [6:0] segment,
	 output logic [2:0] led
);

    logic clk, reset, clkDiv, rowLocked, updateHexInput;
    logic [1:0] rowCounter;
    logic [3:0] row, col, rowLock, rowOut, hexInput0, hexInput1, hexInput;
    logic [7:0] rowColInput, rowColSync, rowCol;

    // Invert from pull-up resistors
    assign reset = 1'b0; // resetB pin is unassigned and pulled up so need to invert

    // Counter and demux for row output
    rowSelect rowSelector(.clk, .reset, .clkDiv, .rowCounter);
    decoder rowDecoder(.encoded(rowCounter), .decoded(row));

    // combine current row and column input into one bus for storage
    assign rowColInput = {row, col};
	
    // Invert row & col because real-world is active low but FSM is coded for active high
	// Output all zeroes once detected while iterating through rows for FSM
	mux2 #(4) rowLockMux(rowLocked, row, 4'hF, rowOut);
	assign rowB = ~rowOut;
    assign col = ~colB;
	
	assign led = {rowLocked, rowOut[3:2]};

    // Synchronize keypadInput
    //
    // Note that keypad is active high
    flop #(8) captureFlop(clk, reset, rowColInput, rowColSync); // flop 1
    flop #(8) syncFlop(clk, reset, rowColSync, rowCol); // flop 2

    // Feed synchronized inputs into FSM to debounce and update hexInput0/1

    keypadFSM #(1) keypadScanner (.clk ,.reset, .enable(clkDiv), .rowCol, .rowLocked, .rowLock, .updateInput(updateHexInput), .hexInput, .led);
    
    // flops to hold hexInput for output controller

    flopenr #(4) hexInput0Flop(.clk, .reset, .en(updateHexInput), .d(hexInput), .q(hexInput0));
    flopenr #(4) hexInput1Flop(.clk, .reset, .en(updateHexInput), .d(hexInput0), .q(hexInput1));

    // Output Controller

    outputController outputControl(.clk, .reset, .hexInput0, .hexInput1, .outputSel0, .outputSel1, .segment);

endmodule