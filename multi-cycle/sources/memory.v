// memory.v — Unified Instruction + Data Memory
//
// Key multi-cycle difference from single-cycle:
//   ONE memory block serves both instruction fetch and data access.
//   IorD control signal selects which address is used.
//
// IorD: 0 = use PC (instruction fetch)
//        1 = use ALUOut (data load/store)
//
// Read  is asynchronous  (combinational) — result appears same cycle.
// Write is synchronous   (clocked)       — happens on rising edge.
//
// Memory is word-addressed: address[31:2] indexes the word.
// Supports $readmemh for loading a test program.

module memory #(
    parameter DEPTH = 256               // number of 32-bit words
)(
    input        clk,
    input        MemRead,
    input        MemWrite,
    input  [31:0] addr,                 // from IorD mux
    input  [31:0] write_data,           // register B
    output [31:0] read_data             // to IR and MDR
);
    reg [31:0] mem [0:DEPTH-1];

    // Preload with a test program during simulation
    initial $readmemh("memory_init.mem", mem); //this mem is byte addressable

    // Asynchronous read
    assign read_data = MemRead ? mem[addr[31:2]] : 32'bx;

    // Synchronous write
    always @(posedge clk) begin
        if (MemWrite)
            mem[addr[31:2]] <= write_data;
    end

endmodule