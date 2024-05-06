// Output controller for muxed dual 7-segment display
//
// Written by Kaitlin Lucio
// Last modified: Sept 11, 2023

module outputController(
     input  logic clk, reset,
     input  logic [3:0] hexInput0, hexInput1,
     output logic       outputSel0, outputSel1,
     output logic [6:0] segment
);

    logic ioSelect;
    logic [3:0] selectedInput;
    
    // IO selector to divide clock and select correct input and outputs using a 48MHz input clk
    outputSelector outputSelectModule(clk, reset, ioSelect);

    // Mux to select correct input based on ioSelect
    mux2 #(4) inputMux(.s(ioSelect), .d0(hexInput0), .d1(hexInput1), .q(selectedInput));

    // 7-segment display instantiation
    sevenSegmentController segmentControl(.hexValue(selectedInput), .segment);

    // Transistor select logic. Transistors are active low
    assign outputSel0 = ioSelect;
    assign outputSel1 = ~ioSelect;

endmodule