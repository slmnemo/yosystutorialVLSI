// Takes in a row and column of a keypad and outputs signals corresponding to that number in hex. Gives higher priority to lower column values.
//
// inputs: row[3:0], column[3:0]
// output: hex number corresponding to input row and column
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: Sept 19, 2023

module rowColToHex(
    input logic [7:0] rowCol,
    output logic [3:0] hexInput
);

always_comb
    casez(rowCol)
        8'b0001ZZZ1:    hexInput = 4'hA;
        8'b0001ZZ10:    hexInput = 4'h0;
        8'b0001Z100:    hexInput = 4'hB;
        8'b00011000:    hexInput = 4'hF;
        8'b0010ZZZ1:    hexInput = 4'h7;
        8'b0010ZZ10:    hexInput = 4'h8;
        8'b0010Z100:    hexInput = 4'h9;
        8'b00101000:    hexInput = 4'hE;
        8'b0100ZZZ1:    hexInput = 4'h4;
        8'b0100ZZ10:    hexInput = 4'h5;
        8'b0100Z100:    hexInput = 4'h6;
        8'b01001000:    hexInput = 4'hD;
        8'b1000ZZZ1:    hexInput = 4'h1;
        8'b1000ZZ10:    hexInput = 4'h2;
        8'b1000Z100:    hexInput = 4'h3;
        8'b10001000:    hexInput = 4'hC;
        default:        hexInput = 4'b0000;
    endcase



endmodule
