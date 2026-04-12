`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 04:24:48 PM
// Design Name: 
// Module Name: tb_pipeline
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


module tb_pipeline();

reg clk = 0, rst;

top_module dut(
    clk, rst
    );   
    
    initial begin
//        rst = 0;
//        #10
        rst = 1;
        #10
        rst = 0;
        #70
        $finish ;
    end
    
    always #5 clk = ~clk ;
    
    





endmodule
