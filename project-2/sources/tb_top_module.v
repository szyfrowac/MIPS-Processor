`timescale 1ns / 1ps

module tb_top_module;
    reg clk;
    reg rst;

    top_module dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;

        #12;
        rst = 1'b0;

        // Run enough cycles for 5 instructions to pass through 5 pipeline stages.
        #200;

        $display("\n===== FINAL STATE =====");
        $display("r2 = %h", dut.rm1.mem_regs[2]);
        $display("r3 = %h", dut.rm1.mem_regs[3]);
        $display("r5 = %h", dut.rm1.mem_regs[5]);
        $display("r6 = %h", dut.rm1.mem_regs[6]);
        $display("r7 = %h", dut.rm1.mem_regs[7]);
        $display("r8 = %h", dut.rm1.mem_regs[8]);

        $display("mem[word 3] = %h", dut.dmem1.mem[8'h03]);
        $display("mem[word 4] = %h", dut.dmem1.mem[8'h04]);
        $display("mem[word 5] = %h", dut.dmem1.mem[8'h05]);

        $finish;
    end

endmodule
