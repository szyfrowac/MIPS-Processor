`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 04:15:45 PM
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
    input [31:0] instr_address,
    output [31:0] instruction

    );
    
    reg [31:0] mem [3:0] ;

    initial begin
        mem[0] = 32'h00028C41; // ADD reg3, reg2, reg1
        mem[1] = 32'h000398A4; // NAND reg6,reg5,reg4 
        mem[2] = 32'h00022507; // NOR reg9,reg8 ,reg 7
        mem[3] = 32'h0003316A; // SUB reg12,reg11,reg10
    end
  
    
    assign instruction = mem[instr_address[31:2]]  ; //since pc is byte addressable so each instr you do pc + 4, but in memory we store words so we only consider 31:2;
    
endmodule
