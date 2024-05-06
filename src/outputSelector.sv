// Lab 2 module to divide a clock and output a select signal alternating at 240Hz (120Hz refresh rate)
//
// Written by Kaitlin Lucio
// Last nodified: Sept 11, 2023

module outputSelector(
    input logic clk, reset,
    output logic ioSelect
);

logic [18:0] counter, nextCounter;
logic en, rstEn, nextIOSelect;

assign nextCounter = counter + 19'b1;
assign rstEn = reset | en;
assign en = (nextCounter == 19'h61A80);
assign nextIOSelect = ~ioSelect;

flop #(19) counterFlop(clk, rstEn, nextCounter, counter); 
flopenr #(1) ioSelectFlop(clk, reset, en, nextIOSelect, ioSelect);


endmodule