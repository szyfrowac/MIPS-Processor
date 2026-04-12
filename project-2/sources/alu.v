`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2026 04:37:09 PM
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
    input [31:0] a /* connected to read_data_1 */ , b /*connected to mux*/,  // operands
    input [2:0] alu_ctrl,
    output reg [31:0] result,
    output zero       //zeroflag_for_beq, wired back to PC,PC branches only when control signal and zero flag is true
    );
    assign zero = (result == 0) ;
    always @(*) begin
        case (alu_ctrl)
            3'b000: result = a + b ; // ADD
            3'b001: result = a - b ; // SUB / SUBI
            3'b010: result = a & b ; // AND
            3'b011: result = a | b ; // OR
           
            default: result = 32'b0 ;
        endcase

    end

endmodule
