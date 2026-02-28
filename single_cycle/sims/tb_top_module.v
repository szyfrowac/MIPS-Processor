`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2026 11:31:08 PM
// Design Name: 
// Module Name: tb_top_module
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


module tb_top_module();

reg clk, rst;

top_module dut(
    clk, rst
);
    
initial begin 
    clk = 0;
    rst = 1;
    #50
    clk = 1;
    rst = 0;
    
    repeat(6) begin
        #50 clk = ~clk;
    end

    $finish;
end

endmodule
