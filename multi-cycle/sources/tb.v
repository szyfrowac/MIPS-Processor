

`timescale 1ns/1ps

module tb_multicycle;

    reg clk, rst;

    top_level dut (.clk(clk), .rst(rst));

    // 10ns clock — toggles every 5ns
    initial clk = 0;
    always #5 clk = ~clk;

    // ── Helper task: check a register value ───────────────────────
    task check_reg;
        input [4:0]  reg_num;
        input [31:0] expected;
        input [79:0] label;      // up to 10 ASCII chars
        begin
            if (dut.dp.regfile.regs[reg_num] === expected)
                $display("  PASS  %s : reg%0d = 0x%08h",
                          label, reg_num, expected);
            else
                $display("  FAIL  %s : reg%0d = 0x%08h  (got 0x%08h)",
                          label, reg_num, expected,
                          dut.dp.regfile.regs[reg_num]);
        end
    endtask

    // ── Helper task: check a single bit / value ───────────────────
    task check_val;
        input [31:0] actual;
        input [31:0] expected;
        input [79:0] label;
        begin
            if (actual === expected)
                $display("  PASS  %s : 0x%08h", label, expected);
            else
                $display("  FAIL  %s : got 0x%08h  expected 0x%08h",
                          label, actual, expected);
        end
    endtask

    // ── Main test sequence ────────────────────────────────────────
    initial begin
        $dumpfile("multicycle.vcd");
        $dumpvars(0, tb_multicycle);

        $display("");
        $display("========================================");
        $display("  Multi-Cycle Processor Testbench");
        $display("========================================");

        // Reset for 2 cycles
        rst = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        rst = 0;

        $display("");
        $display("Initial register state:");
        $display("  reg1  = %0d  (rs for ADDI)",
                  dut.dp.regfile.regs[1]);
        $display("  reg3  = %0d  (base for LW)",
                  dut.dp.regfile.regs[3]);
        $display("  reg5  = 0x%08h  (rs for NAND)",
                  dut.dp.regfile.regs[5]);
        $display("  reg6  = 0x%08h  (rt for NAND)",
                  dut.dp.regfile.regs[6]);
        $display("  reg8  = %0d   (rs for BNEQ)",
                  dut.dp.regfile.regs[8]);
        $display("  reg9  = %0d  (rt for BNEQ)",
                  dut.dp.regfile.regs[9]);
        $display("");

        // ── Instruction 1: ADDI reg2, reg1, 40 ───────────────────
        // Cycles: IF(1) → ID(1) → EX_MEM(1) → WB_I(1) = 4 cycles
        $display("--- Running ADDI reg2, reg1, 40 ---");
        repeat(4) @(posedge clk); #1;
        // reg2 = reg1 + 40 = 15 + 40 = 55
        check_reg(5'd2, 32'd55, "ADDI    ");
        $display("");

        // ── Instruction 2: LW reg4, 8(reg3) ──────────────────────
        // Cycles: IF(1) → ID(1) → EX_MEM(1) → MEM_R(1) → WB_L(1) = 5 cycles
        $display("--- Running LW reg4, 8(reg3) ---");
        repeat(5) @(posedge clk); #1;
        // reg3=0, offset=8 → byte addr=8 → word index=2
        // mem[2] = 0xDEADBEEF (from memory_init.mem)
        check_reg(5'd4, 32'hDEADBEEF, "LW      ");
        $display("");

        // ── Instruction 3: NAND reg7, reg5, reg6 ─────────────────
        // Cycles: IF(1) → ID(1) → EX_R(1) → WB_R(1) = 4 cycles
        $display("--- Running NAND reg7, reg5, reg6 ---");
        repeat(4) @(posedge clk); #1;
        // reg5=0xFFFF0000, reg6=0x0000FFFF
        // AND  = 0xFFFF0000 & 0x0000FFFF = 0x00000000
        // NAND = ~0x00000000             = 0xFFFFFFFF
        check_reg(5'd7, 32'hFFFFFFFF, "NAND    ");
        $display("");

        // ── Instruction 4: BNEQ reg8, reg9, 10 ───────────────────
        // Cycles: IF(1) → ID(1) → BRN(1) = 3 cycles
        // reg8=5, reg9=10 → 5 != 10 → Zero=0 → branch_taken=1
        // PC should jump to branch target (not PC+4)
        $display("--- Running BNEQ reg8, reg9, 10 ---");
        // Capture PC before the branch resolves
        // After BRN state: PC = ALUOut = (PC_of_BNEQ + 4) + (10<<2)
        // PC_of_BNEQ = instruction 4 = byte addr 12 = 0x0C
        // PC+4 = 0x10, offset=10 words = 40 bytes
        // branch target = 0x10 + 40 = 0x38
        repeat(3) @(posedge clk); #1;
        $display("  INFO  BNEQ: reg8=%0d, reg9=%0d",
                  dut.dp.regfile.regs[8],
                  dut.dp.regfile.regs[9]);
        $display("  INFO  Zero flag = %0b  (0=not equal, branch taken)",
                  dut.dp.Zero);
        // Branch target = PC_bneq+4 + (10<<2) = 0x10 + 0x28 = 0x38
        check_val(dut.dp.pc_out, 32'h38, "BNEQ PC ");
        $display("");

        // ── Summary ───────────────────────────────────────────────
        $display("========================================");
        $display("  Final register file (written regs)");
        $display("========================================");
        $display("  reg2 = %0d  (ADDI result, expect 55)",
                  dut.dp.regfile.regs[2]);
        $display("  reg4 = 0x%08h  (LW result, expect DEADBEEF)",
                  dut.dp.regfile.regs[4]);
        $display("  reg7 = 0x%08h  (NAND result, expect FFFFFFFF)",
                  dut.dp.regfile.regs[7]);
        $display("========================================");
        $display("");

        $finish;
    end

    // ── Cycle-by-cycle monitor (uncomment to debug) ───────────────
    // always @(posedge clk) begin
    //     $display("t=%3t | state=%0d | PC=0x%h | IR=0x%h | ALUOut=0x%h",
    //               $time,
    //               dut.ctrl.fsm.state,
    //               dut.dp.pc_out,
    //               dut.dp.IR,
    //               dut.dp.ALUOut);
    // end

endmodule