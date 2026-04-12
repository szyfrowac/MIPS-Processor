`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 03:16:33 PM
// Design Name: 
// Module Name: ifid
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


module ifid(
    input clk, rst,
    input enable,
    input flush,
    input [31:0] instr,
    output reg [31:0] instr_out
    );
    
    always@(posedge clk) begin
        if (rst || flush) begin
            instr_out <= 32'b0;
        end else if (enable) begin
            instr_out <= instr;
        end
    end
endmodule
