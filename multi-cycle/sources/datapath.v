// datapath.v — Multi-Cycle Processor Datapath
//
// Structural module: instantiates and wires every submodule.
// All control signals flow IN from control.v.
// Only status signals (opcode, funct, Zero) flow OUT to control.v.
//
// Wiring follows the slide 6 datapath diagram exactly.
//
// MUX summary (from diagram):
//   IorD     (2:1) : mem address  = 0→PC,       1→ALUOut
//   ALUSrcA  (2:1) : ALU input A  = 0→PC,       1→A
//   ALUSrcB  (4:1) : ALU input B  = 00→B, 01→4, 10→sign_ext, 11→shifted
//   PCSource (4:1) : next PC      = 00→ALUResult(PC+4), 01→ALUOut(branch)
//   RegDst   (2:1) : write reg    = 0→rt(IR[20:16]), 1→rd(IR[15:11])
//   MemtoReg (2:1) : write data   = 0→ALUOut,   1→MDR
//
// branch_taken logic:
//   BNEQ branches when registers are NOT equal → Zero = 0 → branch_taken = ~Zero
//   Control asserts PCWriteCond; this module computes branch_taken = ~Zero.
//   If you later add BEQ, control can pass a separate signal to select Zero vs ~Zero.

module datapath (
    input        clk,
    input        rst,

    // ── Control inputs ────────────────────────────────────────────
    input        PCWrite,
    input        PCWriteCond,
    input        IorD,
    input        MemRead,
    input        MemWrite,
    input        IRWrite,
    input        RegDst,
    input        RegWrite,
    input        ALUSrcA,
    input  [1:0] ALUSrcB,
    input        MemtoReg,
    input  [1:0] PCSource,
    input  [1:0] ALUControl,     // comes from alu_control.v (in control.v)

    // ── Status outputs (to control.v) ─────────────────────────────
    output [5:0] opcode,         // IR[31:26]
    output [5:0] funct,          // IR[5:0]
    output       Zero            // from ALU — used for branch condition
);

    // ──────────────────────────────────────────────────────────────
    // Internal wires
    // ──────────────────────────────────────────────────────────────

    // PC
    wire [31:0] pc_out;
    wire [31:0] pc_next;

    // Memory
    wire [31:0] mem_addr;
    wire [31:0] mem_read_data;

    // IR and MDR
    wire [31:0] IR;
    wire [31:0] MDR;

    // Register file
    wire [4:0]  write_reg_addr;
    wire [31:0] write_reg_data;
    wire [31:0] reg_read1;
    wire [31:0] reg_read2;

    // Temp registers
    wire [31:0] A;
    wire [31:0] B;
    wire [31:0] ALUOut;

    // ALU inputs and output
    wire [31:0] alu_src_a;
    wire [31:0] alu_src_b;
    wire [31:0] alu_result;

    // Sign extend and shift
    wire [31:0] sign_ext_imm;
    wire [31:0] shifted_imm;

    // Branch condition (for BNEQ: branch when NOT equal → ~Zero)
    wire branch_taken = ~Zero;

    // ──────────────────────────────────────────────────────────────
    // Instruction field decode (purely combinational from IR)
    // ──────────────────────────────────────────────────────────────
    assign opcode = IR[31:26];
    assign funct  = IR[5:0];

    // ──────────────────────────────────────────────────────────────
    // MUX: IorD — memory address source
    //   0 = PC (instruction fetch)
    //   1 = ALUOut (data load/store)
    // ──────────────────────────────────────────────────────────────
    mux2 #(32) mux_iord (
        .in0 (pc_out),
        .in1 (ALUOut),
        .sel (IorD),
        .out (mem_addr)
    );

    // ──────────────────────────────────────────────────────────────
    // Memory (unified)
    // ──────────────────────────────────────────────────────────────
    memory mem (
        .clk        (clk),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .addr       (mem_addr),
        .write_data (B),           // store data always comes from register B
        .read_data  (mem_read_data)
    );

    // ──────────────────────────────────────────────────────────────
    // Instruction Register
    // ──────────────────────────────────────────────────────────────
    instruction_reg ir_reg (
        .clk      (clk),
        .rst      (rst),
        .IRWrite  (IRWrite),
        .mem_data (mem_read_data),
        .IR       (IR)
    );

    // ──────────────────────────────────────────────────────────────
    // Memory Data Register
    // ──────────────────────────────────────────────────────────────
    mem_data_reg mdr_reg (
        .clk      (clk),
        .rst      (rst),
        .mem_data (mem_read_data),
        .MDR      (MDR)
    );

    // ──────────────────────────────────────────────────────────────
    // MUX: RegDst — write register address selection
    //   0 = IR[20:16] = rt  (I-type: ADDI, LW)
    //   1 = IR[15:11] = rd  (R-type: NAND)
    // ──────────────────────────────────────────────────────────────
    mux2 #(5) mux_regdst (
        .in0 (IR[20:16]),
        .in1 (IR[15:11]),
        .sel (RegDst),
        .out (write_reg_addr)
    );

    // ──────────────────────────────────────────────────────────────
    // MUX: MemtoReg — write data selection
    //   0 = ALUOut  (R-type, ADDI result)
    //   1 = MDR     (LW: data loaded from memory)
    // ──────────────────────────────────────────────────────────────
    mux2 #(32) mux_memtoreg (
        .in0 (ALUOut),
        .in1 (MDR),
        .sel (MemtoReg),
        .out (write_reg_data)
    );

    // ──────────────────────────────────────────────────────────────
    // Register File
    // ──────────────────────────────────────────────────────────────
    register_file regfile (
        .clk        (clk),
        .RegWrite   (RegWrite),
        .read_reg1  (IR[25:21]),
        .read_reg2  (IR[20:16]),
        .write_reg  (write_reg_addr),
        .write_data (write_reg_data),
        .read_data1 (reg_read1),
        .read_data2 (reg_read2)
    );

    // ──────────────────────────────────────────────────────────────
    // Temporary Registers A, B, ALUOut
    // ──────────────────────────────────────────────────────────────
    temp_reg pipeline_latches (
        .clk        (clk),
        .rst        (rst),
        .reg_data1  (reg_read1),
        .reg_data2  (reg_read2),
        .alu_result (alu_result),
        .A          (A),
        .B          (B),
        .ALUOut     (ALUOut)
    );

   
    sign_extend se (
        .in  (IR[15:0]),
        .out (sign_ext_imm)
    );

    shift_left2 sl2 (
        .in  (sign_ext_imm),
        .out (shifted_imm)
    );

    // ──────────────────────────────────────────────────────────────
    // MUX: ALUSrcA — ALU first input
    //   0 = PC     (IF: compute PC+4 | ID: compute branch target base)
    //   1 = A      (EX: use register value)
    // ──────────────────────────────────────────────────────────────
    mux2 #(32) mux_alusrca (
        .in0 (pc_out),
        .in1 (A),
        .sel (ALUSrcA),
        .out (alu_src_a)
    );

    // ──────────────────────────────────────────────────────────────
    // MUX: ALUSrcB — ALU second input (4-to-1)
    //   00 = B             (R-type execution)
    //   01 = 32'd4         (PC increment: PC + 4)
    //   10 = sign_ext_imm  (ADDI, LW address offset)
    //   11 = shifted_imm   (branch target offset: sign_ext << 2)
    // ──────────────────────────────────────────────────────────────
    mux4 #(32) mux_alusrcb (
        .in0 (B),
        .in1 (32'd4),
        .in2 (sign_ext_imm),
        .in3 (shifted_imm),
        .sel (ALUSrcB),
        .out (alu_src_b)
    );

    // ──────────────────────────────────────────────────────────────
    // ALU
    // ──────────────────────────────────────────────────────────────
    alu main_alu (
        .A          (alu_src_a),
        .B          (alu_src_b),
        .ALUControl (ALUControl),
        .ALUResult  (alu_result),
        .Zero       (Zero)
    );

    // ──────────────────────────────────────────────────────────────
    // MUX: PCSource — next PC selection (4-to-1)
    //   00 = alu_result  (PC+4, computed in IF stage, not yet latched)
    //   01 = ALUOut      (branch target, latched from ID stage)
    //   10 = {PC[31:28], IR[25:0], 2'b00}  (jump — not needed for lab)
    //   11 = unused
    // ──────────────────────────────────────────────────────────────
    mux4 #(32) mux_pcsource (
        .in0 (alu_result),
        .in1 (ALUOut),
        .in2 ({pc_out[31:28], IR[25:0], 2'b00}),
        .in3 (32'h0),
        .sel (PCSource),
        .out (pc_next)
    );

    // ──────────────────────────────────────────────────────────────
    // Program Counter
    // ──────────────────────────────────────────────────────────────
    pc program_counter (
        .clk          (clk),
        .rst          (rst),
        .PCWrite      (PCWrite),
        .PCWriteCond  (PCWriteCond),
        .branch_taken (branch_taken),
        .pc_next      (pc_next),
        .pc_out       (pc_out)
    );

endmodule