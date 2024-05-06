// Takes in 4 bit number and outputs signals corresponding to that number in hex on a seven-segment display
//
// inputs: hexValue [nibble]
// output: 7-segment display  bus
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: August 31, 2023

module sevenSegmentController(
    input logic [3:0] hexValue,
    output logic [6:0] segment
);

    logic [6:0] segmentBar;

    // segmentBar = {A, B, C, D, E, F, G}
    always_comb
        case(hexValue)
            4'h0: segmentBar <= 7'b1111110;
            4'h1: segmentBar <= 7'b0110000;
            4'h2: segmentBar <= 7'b1101101;
            4'h3: segmentBar <= 7'b1111001;
            4'h4: segmentBar <= 7'b0110011;
            4'h5: segmentBar <= 7'b1011011;
            4'h6: segmentBar <= 7'b1011111;
            4'h7: segmentBar <= 7'b1110000;
            4'h8: segmentBar <= 7'b1111111;
            4'h9: segmentBar <= 7'b1110011;
            4'hA: segmentBar <= 7'b1110111;
            4'hB: segmentBar <= 7'b0011111;
            4'hC: segmentBar <= 7'b0001101;
            4'hD: segmentBar <= 7'b0111101;
            4'hE: segmentBar <= 7'b1001111;
            4'hF: segmentBar <= 7'b1000111;
            default: segmentBar <= 7'bxxxxxxx;
        endcase

    // Perform NOT on segmentBar to invert for 7-segment display
    assign segment = ~segmentBar;

endmodule
