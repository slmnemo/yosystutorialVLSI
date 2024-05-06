// Lab 3 module to handle polled inputs translating and updating to outputs
// debounce time comes from clk divider as an enable signal
//
// Written by Kaitlin Lucio
// Last nodified: Sept 25, 2023

module keypadFSM #(parameter delayCycles=1) (
    input logic         clk, reset, enable,
    input logic [7:0]   rowCol,
    output logic        updateInput, rowLocked,
    output logic [3:0]  hexInput, rowLock,
	output logic [2:0] led
);

logic                               rstDb, ready, colTrigger, debounceTrig, rowMatch;
logic                               rowenable, colEnable, rowCapture, colCapture;
logic [3:0]                         row, col, colLock;
// logic [$clog2(delayCycles)-1:0]     debounceCounter, nextDebounceCounter; // commented, uncomment if debouncing for more than 1
logic debounceCounter, nextDebounceCounter;
typedef enum logic [1:0] {poll, debounce, update, lock} statetypes;

statetypes currentState, nextState;

assign row = rowCol[7:4];
assign col = rowCol[3:0];

assign rowMatch = |(row & rowLock) & (currentState != poll);

assign colTrigger = |(col) & ((currentState == poll) | rowMatch);
assign rowEnable = ((currentState == poll) & colTrigger);
assign colEnable = (rowEnable | rowMatch);

assign rowCapture = enable & rowEnable;
assign colCapture = enable & colEnable;

// Flops to store row and column state from polling
flopenr #(4) rowLockFlop(clk, reset, rowCapture, row, rowLock);
flopenr #(4) colLockFlop(clk, reset, colCapture, col, colLock);

// Counter logic
assign nextDebounceCounter = (debounceCounter + 1);
assign debounceTrig = (debounceCounter == delayCycles);
assign rstDb = reset | (currentState != debounce);

// Flop to store debounce counter
flopenr #(1) delayFlop(clk, rstDb, rowMatch, nextDebounceCounter, debounceCounter);

always_comb begin
    case(currentState)
        poll:       if (colTrigger)                                     nextState = debounce;
                    else                                                nextState = poll;
        debounce:   if (debounceTrig & colTrigger & rowMatch)           nextState = update;
                    else if (debounceTrig & ~colTrigger & rowMatch)     nextState = poll;
                    else                                                nextState = debounce;
        update:                                                         nextState = lock;
        lock:       if (rowMatch & ~colTrigger)                         nextState = poll;
                    else                                                nextState = lock;
        default:                                                        nextState = poll;
    endcase
end

// Flop to get next state
always_ff @(posedge clk)
    if (reset)
        currentState <= #1 poll;
    else if (enable)
        currentState <= #1 nextState;
	else
		currentState <= #1 currentState;

// Assign update input and use rowcoltohex module to get correct hex out for row/col pair
assign updateInput = (currentState == update) & enable;
rowColToHex rowColAssignment({rowLock, colLock}, hexInput);

// Assign whether to use row or rowLock as row output
assign rowLocked = ~(currentState == poll);
//assign led = {rowLocked, currentState == lock, currentState == poll};

endmodule