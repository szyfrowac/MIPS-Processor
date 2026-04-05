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
    input [31:0] instr,
    output reg [31:0] instr_out
    );
    
    always@(posedge clk) begin
        if(rst) instr_out <= 0;
        else instr_out <= instr;
    end
endmodule
