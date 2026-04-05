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


module ex_wb_reg(
    input clk, rst,
    input [37:0] instr,
    output reg [37:0] instr_out
    );
    
    always@(posedge clk) begin
        if(rst) instr_out <= 0;
        else instr_out <= instr;
    end
endmodule
