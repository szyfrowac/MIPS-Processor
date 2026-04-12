`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 03:47:24 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk, rst
    );

    // IF stage
    wire [31:0] pc_curr;
    wire [31:0] pc_plus4;
    wire [31:0] instr_if;
    wire pc_write;

    // IF/ID
    wire ifid_write;
    wire ifid_flush;
    wire [31:0] instr_id;

    // ID stage decode
    wire [3:0] opcode_id;
    wire [3:0] wn_id;
    wire [3:0] rn1_id;
    wire [3:0] rn2_id;
    wire [3:0] rs_id;
    wire [3:0] rt_id;
    wire [15:0] imm16_id;
    wire [31:0] imm_ext_id;
    wire [3:0] dest_id;

    wire [31:0] rs_data_id;
    wire [31:0] rt_data_id;

    wire reg_write_id;
    wire mem_read_id;
    wire mem_write_id;
    wire alu_src_id;
    wire mem_to_reg_id;
    wire [2:0] alu_op_id;

    // Hazard signals
    wire stall;

    // ID/EX outputs
    wire reg_write_ex;
    wire mem_read_ex;
    wire mem_write_ex;
    wire alu_src_ex;
    wire mem_to_reg_ex;
    wire [2:0] alu_op_ex;
    wire [31:0] rs_data_ex;
    wire [31:0] rt_data_ex;
    wire [31:0] imm_ext_ex;
    wire [3:0] rs_ex;
    wire [3:0] rt_ex;
    wire [3:0] rd_ex;

    // EX stage
    wire [1:0] forward_a;
    wire [1:0] forward_b;
    reg [31:0] alu_in_a;
    reg [31:0] alu_in_b_from_fwd;
    wire [31:0] alu_in_b;
    wire [31:0] alu_result_ex;
    wire zero_unused;

    // EX/MEM outputs
    wire reg_write_mem;
    wire mem_read_mem;
    wire mem_write_mem;
    wire mem_to_reg_mem;
    wire [31:0] alu_result_mem;
    wire [31:0] rt_data_mem;
    wire [3:0] rd_mem;

    // MEM stage
    wire [31:0] mem_read_data;

    // MEM/WB outputs
    wire reg_write_wb;
    wire mem_to_reg_wb;
    wire [31:0] mem_data_wb;
    wire [31:0] alu_result_wb;
    wire [3:0] rd_wb;

    wire [31:0] writeback_data;

    // IF stage
    localparam OP_SW_1 = 4'b0100;
    localparam OP_SW_2 = 4'b0010;
    localparam OP_AND  = 4'b1111;

    assign pc_write = ~stall;
    assign ifid_write = ~stall;
    assign ifid_flush = 1'b0;

    pc_register pc(
        .clk(clk),
        .rst(rst),
        .enable(pc_write),
        .adder_address(pc_plus4),
        .instr_address(pc_curr)
    );

    adder_pc a1(
        .a(pc_curr),
        .b(32'd4),
        .sum(pc_plus4)
    );

    instruction_memory im1(
        .instr_address(pc_curr),
        .instruction(instr_if)
    );

    ifid if_id_reg1(
        .clk(clk),
        .rst(rst),
        .enable(ifid_write),
        .flush(ifid_flush),
        .instr(instr_if),
        .instr_out(instr_id)
    );

    // ID stage
    assign opcode_id = instr_id[31:28];
    assign wn_id = instr_id[27:24];
    assign rn1_id = instr_id[23:20];
    assign rn2_id = instr_id[19:16];
    assign imm16_id = instr_id[15:0];
    assign imm_ext_id = {{16{imm16_id[15]}}, imm16_id};
    assign rs_id = rn1_id;
    assign rt_id = (opcode_id == OP_AND) ? rn2_id :
                   ((opcode_id == OP_SW_1) || (opcode_id == OP_SW_2)) ? wn_id : 4'd0;
    assign dest_id = wn_id;

    register_memory rm1(
        .read_register_1(rs_id),
        .read_register_2(rt_id),
        .write_register(rd_wb),
        .register_write(reg_write_wb),
        .write_data(writeback_data),
        .clk(clk),
        .read_data_1(rs_data_id),
        .read_data_2(rt_data_id)
    );

    control_unit cu1(
        .opcode(opcode_id),
        .reg_write(reg_write_id),
        .mem_read(mem_read_id),
        .mem_write(mem_write_id),
        .alu_src(alu_src_id),
        .mem_to_reg(mem_to_reg_id),
        .alu_op(alu_op_id)
    );

    hazard_detection_unit hdu(
        .idex_mem_read(mem_read_ex),
        .idex_rd(rd_ex),
        .ifid_rs(rs_id),
        .ifid_rt(rt_id),
        .stall(stall)
    );

    id_ex_reg idex1(
        .clk(clk),
        .rst(rst),
        .flush(stall),
        .reg_write_in(reg_write_id),
        .mem_read_in(mem_read_id),
        .mem_write_in(mem_write_id),
        .alu_src_in(alu_src_id),
        .mem_to_reg_in(mem_to_reg_id),
        .alu_op_in(alu_op_id),
        .rs_data_in(rs_data_id),
        .rt_data_in(rt_data_id),
        .imm_ext_in(imm_ext_id),
        .rs_in(rs_id),
        .rt_in(rt_id),
        .rd_in(dest_id),
        .reg_write_out(reg_write_ex),
        .mem_read_out(mem_read_ex),
        .mem_write_out(mem_write_ex),
        .alu_src_out(alu_src_ex),
        .mem_to_reg_out(mem_to_reg_ex),
        .alu_op_out(alu_op_ex),
        .rs_data_out(rs_data_ex),
        .rt_data_out(rt_data_ex),
        .imm_ext_out(imm_ext_ex),
        .rs_out(rs_ex),
        .rt_out(rt_ex),
        .rd_out(rd_ex)
    );

    // EX stage
    forwarding_unit fu(
        .exmem_reg_write(reg_write_mem),
        .exmem_rd(rd_mem),
        .memwb_reg_write(reg_write_wb),
        .memwb_rd(rd_wb),
        .idex_rs(rs_ex),
        .idex_rt(rt_ex),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    always @(*) begin
        case (forward_a)
            2'b10: alu_in_a = alu_result_mem;
            2'b01: alu_in_a = writeback_data;
            default: alu_in_a = rs_data_ex;
        endcase

        case (forward_b)
            2'b10: alu_in_b_from_fwd = alu_result_mem;
            2'b01: alu_in_b_from_fwd = writeback_data;
            default: alu_in_b_from_fwd = rt_data_ex;
        endcase
    end

    assign alu_in_b = (alu_src_ex) ? imm_ext_ex : alu_in_b_from_fwd;

    alu alu1(
        .a(alu_in_a),
        .b(alu_in_b),
        .alu_ctrl(alu_op_ex),
        .result(alu_result_ex),
        .zero(zero_unused)
    );

    ex_mem_reg exmem1(
        .clk(clk),
        .rst(rst),
        .reg_write_in(reg_write_ex),
        .mem_read_in(mem_read_ex),
        .mem_write_in(mem_write_ex),
        .mem_to_reg_in(mem_to_reg_ex),
        .alu_result_in(alu_result_ex),
        .rt_data_in(alu_in_b_from_fwd),
        .rd_in(rd_ex),
        .reg_write_out(reg_write_mem),
        .mem_read_out(mem_read_mem),
        .mem_write_out(mem_write_mem),
        .mem_to_reg_out(mem_to_reg_mem),
        .alu_result_out(alu_result_mem),
        .rt_data_out(rt_data_mem),
        .rd_out(rd_mem)
    );

    // MEM stage
    data_memory dmem1(
        .clk(clk),
        .mem_read(mem_read_mem),
        .mem_write(mem_write_mem),
        .address(alu_result_mem),
        .write_data(rt_data_mem),
        .read_data(mem_read_data)
    );

    mem_wb_reg memwb1(
        .clk(clk),
        .rst(rst),
        .reg_write_in(reg_write_mem),
        .mem_to_reg_in(mem_to_reg_mem),
        .mem_data_in(mem_read_data),
        .alu_result_in(alu_result_mem),
        .rd_in(rd_mem),
        .reg_write_out(reg_write_wb),
        .mem_to_reg_out(mem_to_reg_wb),
        .mem_data_out(mem_data_wb),
        .alu_result_out(alu_result_wb),
        .rd_out(rd_wb)
    );

    // WB stage
    assign writeback_data = (mem_to_reg_wb) ? mem_data_wb : alu_result_wb;

    // Cycle-level debug
    always @(posedge clk) begin
        if (!rst) begin
            $display("[CYCLE] PC=%0d IF=%h ID=%h", pc_curr, instr_if, instr_id);
            $display("        EX rs=r%0d rt=r%0d rd=r%0d aluA=%h aluB=%h aluOut=%h",
                     rs_ex, rt_ex, rd_ex, alu_in_a, alu_in_b, alu_result_ex);
            $display("        MEM memRead=%b memWrite=%b addr=%h wdata=%h rdata=%h rd=r%0d",
                     mem_read_mem, mem_write_mem, alu_result_mem, rt_data_mem, mem_read_data, rd_mem);
            $display("        WB regWrite=%b memToReg=%b rd=r%0d wbData=%h",
                     reg_write_wb, mem_to_reg_wb, rd_wb, writeback_data);
            $display("        Hazard stall=%b | ForwardA=%b ForwardB=%b",
                     stall, forward_a, forward_b);
        end
    end

endmodule
