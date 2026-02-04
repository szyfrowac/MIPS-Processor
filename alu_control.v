`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2026 04:36:21 PM
// Design Name: 
// Module Name: alu_control
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


module alu_control(
    input [1:0] alu_op,
    input [5:0] funct_field,
    output reg [3:0] operation
    );
    reg [3:0] r_type ;
    
    always @(*) begin
        
        casex(funct_field) 
        
        6'bxx0000 : r_type = 4'd2 ;
        6'bxx0010 : r_type = 4'd6 ;
        6'bxx0100 : r_type = 4'd0 ;
        6'bxx0101 : r_type = 4'd1 ;
        6'bxx1010 : r_type = 4'd7 ;
        default : r_type = 4'dx ;
        
        
        endcase
        
    end
    always @(*) begin
    
    casex(alu_op) 
    
    2'd0 : operation = 4'd2 ;
    2'd1 : operation = 4'd6 ;
    2'b1x : operation = r_type ;
    
    
    endcase
    
    
    
    
    end
    
endmodule
