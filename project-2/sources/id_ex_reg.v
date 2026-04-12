`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2026 04:09:05 PM
// Design Name: 
// Module Name: id_ex_reg
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


module id_ex_reg(
    input clk,
    input rst,
    input flush,

    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input alu_src_in,
    input mem_to_reg_in,
    input [2:0] alu_op_in,

    input [31:0] rs_data_in,
    input [31:0] rt_data_in,
    input [31:0] imm_ext_in,
    input [3:0] rs_in,
    input [3:0] rt_in,
    input [3:0] rd_in,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg alu_src_out,
    output reg mem_to_reg_out,
    output reg [2:0] alu_op_out,

    output reg [31:0] rs_data_out,
    output reg [31:0] rt_data_out,
    output reg [31:0] imm_ext_out,
    output reg [3:0] rs_out,
    output reg [3:0] rt_out,
    output reg [3:0] rd_out
);

always @(posedge clk or posedge rst) begin
    if (rst || flush) begin
        reg_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        alu_src_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        alu_op_out <= 3'b000;
        rs_data_out <= 32'b0;
        rt_data_out <= 32'b0;
        imm_ext_out <= 32'b0;
        rs_out <= 4'b0;
        rt_out <= 4'b0;
        rd_out <= 4'b0;
    end else begin
        reg_write_out <= reg_write_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        alu_src_out <= alu_src_in;
        mem_to_reg_out <= mem_to_reg_in;
        alu_op_out <= alu_op_in;
        rs_data_out <= rs_data_in;
        rt_data_out <= rt_data_in;
        imm_ext_out <= imm_ext_in;
        rs_out <= rs_in;
        rt_out <= rt_in;
        rd_out <= rd_in;
    end
end

endmodule
