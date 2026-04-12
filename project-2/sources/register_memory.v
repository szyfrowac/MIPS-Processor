`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2026 03:37:27 PM
// Design Name: 
// Module Name: register_memory
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


module register_memory(
    input [3:0] read_register_1,read_register_2,write_register, //4-bit register address fields per instruction format
    input register_write, // set by control signal
    input [31:0] write_data,
    input clk,
    output [31:0] read_data_1,
    output [31:0] read_data_2 //spitting out the data from registers

    );
    
    reg [31:0] mem_regs [15:0] ; //16 architectural registers, each 32-bit wide
    
    integer i;
    
    initial begin

        for( i = 0; i < 16; i = i + 1) begin
            mem_regs[i] = 32'h00000000;
        end

        // Required initial values
        mem_regs[3] = 32'h00009EEF;
        mem_regs[5] = 32'h0000000F;
        mem_regs[8] = 32'h000CFC55;

        
    end
 
    assign read_data_1 = (read_register_1 == 0)? 32'd0 : mem_regs [read_register_1] ;
   assign read_data_2 = (read_register_2  == 0)? 32'd0 : mem_regs [read_register_2] ;

  
    always @(posedge clk) begin
    if (register_write == 1 && write_register != 4'd0) begin
        mem_regs[write_register] <= write_data; 
    end
end 
   
endmodule
