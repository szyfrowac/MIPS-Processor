`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 03:56:36 PM
// Design Name: 
// Module Name: ex_mem_reg
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


module ex_mem_reg(
    input clk,
    input rst,

    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,

    input [31:0] alu_result_in,
    input [31:0] rt_data_in,
    input [3:0] rd_in,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,

    output reg [31:0] alu_result_out,
    output reg [31:0] rt_data_out,
    output reg [3:0] rd_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_write_out <= 1'b0;
        mem_read_out <= 1'b0;
        mem_write_out <= 1'b0;
        mem_to_reg_out <= 1'b0;
        alu_result_out <= 32'b0;
        rt_data_out <= 32'b0;
        rd_out <= 4'b0;
    end else begin
        reg_write_out <= reg_write_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        alu_result_out <= alu_result_in;
        rt_data_out <= rt_data_in;
        rd_out <= rd_in;
    end
end

endmodule
