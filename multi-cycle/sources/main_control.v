// main_control.v — Multi-Cycle Processor Main Control Unit (Moore FSM)
//
// Moore FSM: outputs depend ONLY on current state, not on inputs.
// Three always blocks (best practice):
//   Block 1 — state register     (sequential, posedge clk)
//   Block 2 — next state logic   (combinational, always @(*))
//   Block 3 — output logic       (combinational, always @(*))
//
// States (9 total — no jump, not needed for our 4 instructions):
//   S_IF     (0) : Instruction Fetch
//   S_ID     (1) : Instruction Decode / Register Fetch
//   S_EX_MEM (2) : Memory address calc (LW) / ADDI execution — shared
//   S_MEM_R  (3) : Memory Read  (LW)
//   S_WB_L   (4) : Write-back   (LW  — writes MDR into register)
//   S_WB_I   (5) : Write-back   (ADDI — writes ALUOut into register)
//   S_EX_R   (6) : Execution    (NAND R-type)
//   S_WB_R   (7) : Write-back   (NAND — writes ALUOut into register)
//   S_BRN    (8) : Branch completion (BNEQ)
//
// Opcodes from memory_init.mem:
//   R_TYPE = 6'h00  (NAND: funct=6'h21)
//   ADDI   = 6'h08
//   LW     = 6'h23
//   BNEQ   = 6'h05  (custom opcode)
//
// ALUOp encoding passed to alu_control.v:
//   2'b00 = ADD  (IF, ID, EX_MEM)
//   2'b01 = SUB  (BNEQ comparison)
//   2'b10 = funct (R-type, decoded in alu_control)

module main_control (
    input        clk,
    input        rst,
    input  [5:0] opcode,        // IR[31:26] from datapath

    // ── Control outputs to datapath ───────────────────────────────
    output reg   PCWrite,
    output reg   PCWriteCond,
    output reg   IorD,
    output reg   MemRead,
    output reg   MemWrite,
    output reg   IRWrite,
    output reg   RegDst,
    output reg   RegWrite,
    output reg   MemtoReg,
    output reg   ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [1:0] PCSource,

    // ── ALUOp to alu_control ──────────────────────────────────────
    output reg [1:0] ALUOp
);

    // ──────────────────────────────────────────────────────────────
    // State encoding
    // ──────────────────────────────────────────────────────────────
    localparam S_IF     = 4'd0,
               S_ID     = 4'd1,
               S_EX_MEM = 4'd2,
               S_MEM_R  = 4'd3,
               S_WB_L   = 4'd4,
               S_WB_I   = 4'd5,
               S_EX_R   = 4'd6,
               S_WB_R   = 4'd7,
               S_BRN    = 4'd8;

    // ──────────────────────────────────────────────────────────────
    // Opcode constants — must match memory_init.mem encodings exactly
    // ──────────────────────────────────────────────────────────────
    localparam R_TYPE = 6'h00,
               ADDI   = 6'h08,
               LW     = 6'h23,
               BNEQ   = 6'h05;

    // ──────────────────────────────────────────────────────────────
    // Block 1 — State register (sequential)
    // ──────────────────────────────────────────────────────────────
    reg [3:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S_IF;
        else
            state <= next_state;
    end

    // ──────────────────────────────────────────────────────────────
    // Block 2 — Next state logic (combinational)
    // Transitions depend on current state AND opcode (Moore still:
    // outputs don't depend on opcode, only next-state does).
    // ──────────────────────────────────────────────────────────────
    always @(*) begin
        case (state)
            S_IF: next_state = S_ID;

            S_ID: begin
                case (opcode)
                    LW     : next_state = S_EX_MEM;
                    ADDI   : next_state = S_EX_MEM;
                    R_TYPE : next_state = S_EX_R;
                    BNEQ   : next_state = S_BRN;
                    default: next_state = S_IF;    // unknown — restart
                endcase
            end

            S_EX_MEM: begin
                case (opcode)
                    LW     : next_state = S_MEM_R;
                    ADDI   : next_state = S_WB_I;
                    default: next_state = S_IF;
                endcase
            end

            S_MEM_R  : next_state = S_WB_L;
            S_WB_L   : next_state = S_IF;
            S_WB_I   : next_state = S_IF;
            S_EX_R   : next_state = S_WB_R;
            S_WB_R   : next_state = S_IF;
            S_BRN    : next_state = S_IF;

            default  : next_state = S_IF;
        endcase
    end

    // ──────────────────────────────────────────────────────────────
    // Block 3 — Output logic (combinational, Moore)
    // CRITICAL: default everything to 0 first — prevents latch inference
    // Only signals that are 1 in a given state are listed explicitly.
    // ──────────────────────────────────────────────────────────────
    always @(*) begin
        // --- defaults (all inactive) ---
        PCWrite     = 1'b0;
        PCWriteCond = 1'b0;
        IorD        = 1'b0;
        MemRead     = 1'b0;
        MemWrite    = 1'b0;
        IRWrite     = 1'b0;
        RegDst      = 1'b0;
        RegWrite    = 1'b0;
        MemtoReg    = 1'b0;
        ALUSrcA     = 1'b0;
        ALUSrcB     = 2'b00;
        PCSource    = 2'b00;
        ALUOp       = 2'b00;

        case (state)
            // ── S0: Instruction Fetch ──────────────────────────────
            // ALU computes PC+4: A=PC, B=4 → result goes directly to PC
            // Memory reads instruction at PC → IR latches it
            S_IF: begin
                MemRead  = 1'b1;
                IorD     = 1'b0;       // address = PC
                IRWrite  = 1'b1;
                ALUSrcA  = 1'b0;       // A input = PC
                ALUSrcB  = 2'b01;      // B input = 4
                ALUOp    = 2'b00;      // ADD → PC+4
                PCWrite  = 1'b1;
                PCSource = 2'b00;      // PC ← alu_result (PC+4, not yet latched)
            end

            // ── S1: Instruction Decode / Register Fetch ────────────
            // Registers A and B are read (always, regardless of instruction).
            // ALU optimistically computes branch target: PC + (imm<<2)
            // Result lands in ALUOut — used in S8 if instruction is BNEQ.
            S_ID: begin
                ALUSrcA  = 1'b0;       // A input = PC (still holds current PC)
                ALUSrcB  = 2'b11;      // B input = sign_ext shifted left 2
                ALUOp    = 2'b00;      // ADD → branch target into ALUOut
            end

            // ── S2: EX_MEM — shared for LW addr calc and ADDI exec ─
            // LW:   ALUOut = rs + sign_ext_imm  (memory address)
            // ADDI: ALUOut = rs + sign_ext_imm  (result to write back)
            // Same ALU operation — state is shared, next state differs.
            S_EX_MEM: begin
                ALUSrcA  = 1'b1;       // A input = register A (rs)
                ALUSrcB  = 2'b10;      // B input = sign_ext_imm
                ALUOp    = 2'b00;      // ADD
            end

            // ── S3: Memory Read (LW) ───────────────────────────────
            // Memory reads data at address ALUOut → MDR latches it
            S_MEM_R: begin
                MemRead  = 1'b1;
                IorD     = 1'b1;       // address = ALUOut (data address)
            end

            // ── S4: Write-back (LW) ────────────────────────────────
            // MDR → register file; destination = rt (IR[20:16])
            S_WB_L: begin
                RegWrite = 1'b1;
                RegDst   = 1'b0;       // write register = rt
                MemtoReg = 1'b1;       // write data = MDR
            end

            // ── S5: Write-back (ADDI) ──────────────────────────────
            // ALUOut → register file; destination = rt (IR[20:16])
            S_WB_I: begin
                RegWrite = 1'b1;
                RegDst   = 1'b0;       // write register = rt
                MemtoReg = 1'b0;       // write data = ALUOut
            end

            // ── S6: Execution (R-type: NAND) ───────────────────────
            // ALUOut = A NAND B; alu_control decodes funct=6'h21 → NAND
            S_EX_R: begin
                ALUSrcA  = 1'b1;       // A input = register A (rs)
                ALUSrcB  = 2'b00;      // B input = register B (rt)
                ALUOp    = 2'b10;      // R-type → alu_control decodes funct
            end

            // ── S7: Write-back (R-type: NAND) ──────────────────────
            // ALUOut → register file; destination = rd (IR[15:11])
            S_WB_R: begin
                RegWrite = 1'b1;
                RegDst   = 1'b1;       // write register = rd
                MemtoReg = 1'b0;       // write data = ALUOut
            end

            // ── S8: Branch Completion (BNEQ) ───────────────────────
            // ALU computes A - B; if result != 0 (Zero=0), branch is taken.
            // branch_taken = ~Zero (computed in datapath pc.v).
            // PCWriteCond=1: PC updates only if branch_taken=1.
            // PCSource=01: PC ← ALUOut (branch target computed in S1/ID).
            S_BRN: begin
                ALUSrcA     = 1'b1;    // A input = register A (rs=reg8)
                ALUSrcB     = 2'b00;   // B input = register B (rt=reg9)
                ALUOp       = 2'b01;   // SUB → Zero=0 means not equal
                PCWriteCond = 1'b1;    // conditional PC update
                PCSource    = 2'b01;   // PC ← ALUOut (branch target from ID)
            end

            default: begin
                // all signals already defaulted to 0 above
            end
        endcase
    end

endmodule