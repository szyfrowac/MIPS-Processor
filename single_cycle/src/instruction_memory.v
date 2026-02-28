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

    always @(*) begin
    mem[0] = 32'h00430825; // OR reg3, reg1, reg2
    mem[1] = 32'h20A4FFEB; // SUBI reg4, reg5, 21 
    mem[2] = 32'hADCE0005; // SW reg6, 5 (reg7)
    mem[3] = 32'h11280007; // BEQ reg9, reg8, 7
end
  
    
    assign instruction = mem[instr_address[31:2]]  ; //since pc is byte addressable so each instr you do pc + 4, but in memory we store words so we only consider 31:2;
    
endmodule
