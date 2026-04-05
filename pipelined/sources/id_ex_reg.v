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
    input clk, rst,
    input [72:0] id_ex_ip,
    output reg [72:0] id_ex_op
    );
    always @(posedge clk or posedge rst) begin
        if(rst) id_ex_op <= 0;
        else id_ex_op <= id_ex_ip ;
    end
    
endmodule
