`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 03:18:52 PM
// Design Name: 
// Module Name: pc_register
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


module pc_register(
    input clk, rst,
    input [31:0] adder_address,
    output reg [31:0] instr_address
    );
    
    always@(posedge clk, posedge rst) begin
    if(rst) instr_address = 32'b0;   
    else instr_address <= adder_address;
        //pc_reg = ;
    end
endmodule