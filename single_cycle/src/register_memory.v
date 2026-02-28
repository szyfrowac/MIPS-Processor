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
    input [4:0] read_register_1,read_register_2,write_register, //5 bit input line to access registers
    input register_write, // set by control signal
    input [31:0] write_data,
    input clk,
    output [31:0] read_data_1, read_data_2 //spitting out the data from registers

    );
    
    reg [31:0] mem_regs [31:0] ; //32 bit memory file and there are 32 in total
    
    initial begin
        $readmemh("reg_init.mem", mem_regs);
    end
    
 
   assign read_data_1 = (read_register_1 == 0)? 32'b0 : mem_regs [read_register_1] ; // this a 5 bit number 0 to 31 indicating the reg number
   assign read_data_2 = (read_register_2  == 0)? 32'b0 : mem_regs [read_register_2] ;

  
    always @(posedge clk) begin
    if (register_write == 1 && write_register != 0) begin
        mem_regs[write_register] <= write_data; 
    end
end 
   
endmodule
