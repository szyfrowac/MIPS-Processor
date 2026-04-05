

module top_level (
    input clk,
    input rst
);
    // Status signals: datapath → control
    wire [5:0] opcode;
    wire [5:0] funct;
    wire       Zero;

    // Control signals: control → datapath
    wire       PCWrite, PCWriteCond;
    wire       IorD, MemRead, MemWrite, IRWrite;
    wire       RegDst, RegWrite, MemtoReg;
    wire       ALUSrcA;
    wire [1:0] ALUSrcB, PCSource;
    wire [1:0] ALUControl;

    control ctrl (
        .clk         (clk),
        .rst         (rst),
        .opcode      (opcode),
        .funct       (funct),
        .PCWrite     (PCWrite),
        .PCWriteCond (PCWriteCond),
        .IorD        (IorD),
        .MemRead     (MemRead),
        .MemWrite    (MemWrite),
        .IRWrite     (IRWrite),
        .RegDst      (RegDst),
        .RegWrite    (RegWrite),
        .MemtoReg    (MemtoReg),
        .ALUSrcA     (ALUSrcA),
        .ALUSrcB     (ALUSrcB),
        .PCSource    (PCSource),
        .ALUControl  (ALUControl)
    );

    datapath dp (
        .clk         (clk),
        .rst         (rst),
        .PCWrite     (PCWrite),
        .PCWriteCond (PCWriteCond),
        .IorD        (IorD),
        .MemRead     (MemRead),
        .MemWrite    (MemWrite),
        .IRWrite     (IRWrite),
        .RegDst      (RegDst),
        .RegWrite    (RegWrite),
        .MemtoReg    (MemtoReg),
        .ALUSrcA     (ALUSrcA),
        .ALUSrcB     (ALUSrcB),
        .PCSource    (PCSource),
        .ALUControl  (ALUControl),
        .opcode      (opcode),
        .funct       (funct),
        .Zero        (Zero)
    );

endmodule