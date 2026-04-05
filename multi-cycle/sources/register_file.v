// register_file.v — 32 x 32-bit General Purpose Register File
//
// Two asynchronous read ports  (rd1, rd2) — data available combinationally.
// One synchronous  write port             — writes on rising clock edge.
//
// RegDst mux (outside this module) selects the write address:
//   0 → IR[20:16] = rt  (I-type: ADDI, LW)
//   1 → IR[15:11] = rd  (R-type: NAND)
//
// Register 0 is hardwired to zero (writes to it are silently ignored).
//
// Initial values (set for the 4 test instructions):
//   reg1  = 15          → ADDI reg2,reg1,40  : 15+40 = 55
//   reg3  = 0           → LW   reg4,8(reg3)  : addr=8 → mem[2]=0xDEADBEEF
//   reg5  = 0xFFFF0000  → NAND reg7,reg5,reg6: FFFF0000 & 0000FFFF = 0
//   reg6  = 0x0000FFFF                          NAND(0) = 0xFFFFFFFF
//   reg8  = 5           → BNEQ reg8,reg9,10  : 5 != 10, branch taken
//   reg9  = 10

module register_file (
    input        clk,
    input        RegWrite,
    input  [4:0] read_reg1,        // IR[25:21] = rs
    input  [4:0] read_reg2,        // IR[20:16] = rt
    input  [4:0] write_reg,        // from RegDst mux
    input  [31:0] write_data,      // from MemtoReg mux
    output [31:0] read_data1,      // → register A latch
    output [31:0] read_data2       // → register B latch
);
    reg [31:0] regs [0:31];

    integer i;
    initial begin
        // Zero all registers first
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'h0;

        // ── Instruction operand initial values ────────────────────
        // ADDI reg2, reg1, 40   → reg1=15  → result = 15+40 = 55
        regs[1]  = 32'd15;

        // LW reg4, 8(reg3)      → reg3=0   → addr = 0+8 = 8
        //                                    mem[8>>2]=mem[2]=0xDEADBEEF
        regs[3]  = 32'd0;

        // NAND reg7, reg5, reg6 → FFFF0000 & 0000FFFF = 0x00000000
        //                         NAND result          = 0xFFFFFFFF
        regs[5]  = 32'hFFFF0000;
        regs[6]  = 32'h0000FFFF;

        // BNEQ reg8, reg9, 10   → 5 != 10  → branch IS taken
        regs[8]  = 32'd5;
        regs[9]  = 32'd10;
    end

    // Asynchronous reads — always driven
    assign read_data1 = (read_reg1 == 5'b0) ? 32'h0 : regs[read_reg1];
    assign read_data2 = (read_reg2 == 5'b0) ? 32'h0 : regs[read_reg2];

    // Synchronous write — register 0 stays zero
    always @(posedge clk) begin
        if (RegWrite && write_reg != 5'b0)
            regs[write_reg] <= write_data;
    end

endmodule