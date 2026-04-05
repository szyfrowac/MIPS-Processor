// control.v — Control Unit Wrapper
//
// Instantiates main_control (FSM) and alu_control and connects them.
// This is what datapath.v's parent (top_level.v) should instantiate.
//
// Data flow:
//   opcode, funct → main_control → ALUOp → alu_control → ALUControl
//                               → all other control signals → datapath

module control (
    input        clk,
    input        rst,
    input  [5:0] opcode,       // from datapath IR[31:26]
    input  [5:0] funct,        // from datapath IR[5:0]

    // All control outputs going to datapath
    output       PCWrite,
    output       PCWriteCond,
    output       IorD,
    output       MemRead,
    output       MemWrite,
    output       IRWrite,
    output       RegDst,
    output       RegWrite,
    output       MemtoReg,
    output       ALUSrcA,
    output [1:0] ALUSrcB,
    output [1:0] PCSource,
    output [1:0] ALUControl    // decoded by alu_control — 2-bit (3 ops only)
);
    wire [1:0] ALUOp;          // internal wire between FSM and ALU control

    main_control fsm (
        .clk         (clk),
        .rst         (rst),
        .opcode      (opcode),
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
        .ALUOp       (ALUOp)
    );

    alu_control actl (
        .ALUOp      (ALUOp),
        .funct      (funct),
        .ALUControl (ALUControl)
    );

endmodule