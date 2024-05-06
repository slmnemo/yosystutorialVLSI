// Lab 2 module to divide a clock and output a select signal alternating at 1000Hz (125Hz key polling rate)
//
// Written by Kaitlin Lucio
// Last modified: Sept 23, 2023

module rowSelect(
    input logic clk, reset,
    output logic clkDiv,
    output logic [1:0] rowCounter 
);

logic [15:0] counter, nextCounter;
logic [1:0]  nextRowCounter;
logic en, rstEn, nextIOSelect;

assign nextCounter = counter + 16'b1;
assign nextRowCounter = rowCounter + 2'b1;
assign rstEn = reset | clkDiv;
assign clkDiv = (nextCounter == 16'hBB80);

flop #(16) counterFlop(clk, rstEn, nextCounter, counter); 
flopenr #(2)  rowCounterFlop(.clk, .reset, .en(clkDiv), .d(nextRowCounter), .q(rowCounter));


endmodule