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
    
    reg [31:0] mem [0:31] ;
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            mem[i] = 32'b0;
        end

        // Format: {opcode[31:28], WN[27:24], RN1[23:20], RN2[19:16], IMM[15:0]}
        // 0: SUBI r2, r3, 1989
        mem[0] = {4'b0000, 4'd2, 4'd3, 4'd0, 16'd1989};

        // 1: SW r2, 0(r5)
        mem[1] = {4'b0100, 4'd2, 4'd5, 4'd0, 16'd0};

        // 2: SW r2, 4(r5)
        mem[2] = {4'b0010, 4'd2, 4'd5, 4'd0, 16'd4};

        // 3: LW r6, 8(r5)
        mem[3] = {4'b0001, 4'd6, 4'd5, 4'd0, 16'd8};

        // 4: AND r7, r6, r8 (R-type: IMM is zero)
        mem[4] = {4'b1111, 4'd7, 4'd6, 4'd8, 16'd0};
    end
  
    
    assign instruction = mem[instr_address[31:2]]  ; //since pc is byte addressable so each instr you do pc + 4, but in memory we store words so we only consider 31:2;
    
endmodule
