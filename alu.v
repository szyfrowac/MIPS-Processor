`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2026 03:24:30 PM
// Design Name: 
// Module Name: alu
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


module alu(
    input  [31:0] in_1, in_2,
    input [1:0] control_signal,
    output reg [31:0] result,
    output reg zero
    );
    
    reg zero_reg = 1'b0;
    wire [31:0] sum, diff, and_res, or_res;
    wire carry_flag;
    
    ripple_adder a1(in_1, in_2, ~control_signal[0], control_signal[1], sum, carry_flag);
    
    always@(*) begin
        casex(control_signal)
            2'b00: result = in_1 & in_2;
            2'b01: result = in_1 | in_2;
            2'b1X: result = sum;
        endcase
    end
    
    always@(result) begin
        if(!result) zero = 1'b1;
        else zero = 1'b0;
    end
endmodule
