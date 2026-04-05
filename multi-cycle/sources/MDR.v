// mem_data_reg.v — Memory Data Register (MDR)
//
// Latches the memory read_data every clock cycle.
// This decouples the (slow) memory read from the register write:
//   Cycle N   : memory outputs data → MDR captures it
//   Cycle N+1 : MemtoReg mux routes MDR into register file write port
//
// Used only by LW — the MDR output feeds the MemtoReg mux.

module mem_data_reg (
    input        clk,
    input        rst,
    input  [31:0] mem_data,
    output reg [31:0] MDR
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            MDR <= 32'h0;
        else
            MDR <= mem_data;     // always latches — no enable needed
    end

endmodule