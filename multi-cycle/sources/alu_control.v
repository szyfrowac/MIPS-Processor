// alu_control.v — ALU Control Unit (trimmed for 4-instruction set)
//
// Inputs:
//   ALUOp[1:0] — from main_control FSM
//   funct[5:0] — IR[5:0], only used when ALUOp=2'b10 (R-type)
//
// Output:
//   ALUControl[1:0] — 2-bit, drives the trimmed ALU
//
// ALUOp encoding (set by main_control):
//   2'b00 → ADD  (IF: PC+4, ID: branch target, EX_MEM: ADDI/LW address)
//   2'b01 → SUB  (BNEQ: compare rs and rt)
//   2'b10 → R-type: decode funct field (only NAND supported)
//
// funct decoding (only active when ALUOp=2'b10):
//   6'h21 → NAND (matches encoding in memory_init.mem: 00A63821)
//
// ALUControl output encoding (matches alu.v):
//   2'b00 = ADD
//   2'b01 = SUB
//   2'b10 = NAND

module alu_control (
    input  [1:0] ALUOp,
    input  [5:0] funct,
    output reg [1:0] ALUControl      // 2-bit — matches trimmed alu.v
);
    // funct code for NAND — from memory_init.mem: 00A63821 → IR[5:0] = 6'h21
    localparam FUNCT_NAND = 6'h21;

    localparam ALU_ADD  = 2'b00;
    localparam ALU_SUB  = 2'b01;
    localparam ALU_NAND = 2'b10;

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = ALU_ADD;     // IF, ID, EX_MEM — always ADD

            2'b01: ALUControl = ALU_SUB;     // BNEQ — subtract for comparison

            2'b10: begin                     // R-type — check funct
                case (funct)
                    FUNCT_NAND: ALUControl = ALU_NAND;
                    default:    ALUControl = ALU_ADD;   // safe fallback
                endcase
            end

            default: ALUControl = ALU_ADD;   // 2'b11 unused — safe fallback
        endcase
    end

endmodule