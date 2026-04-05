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
    output [31:0]  read_data_1, [31:0] read_data_2 //spitting out the data from registers

    );
    
    reg [31:0] mem_regs [31:0] ; //32 bit memory file and there are 32 in total
    
    integer i;
    
    initial begin
        
        mem_regs[0] = 32'h00000000;
        mem_regs[1] = 32'hEDDE4997;
        mem_regs[2] = 32'hABAC4155;
        mem_regs[3] = 32'h00000000;
        mem_regs[4] = 32'hFF77FFFF;
        mem_regs[5] = 32'h11FF99FF;
        mem_regs[6] = 32'h00000000;
        mem_regs[7] = 32'hD1234567;
        mem_regs[8] = 32'hC011010E;
        mem_regs[9] = 32'h00000000;
        mem_regs[10] = 32'hEB129099;
        mem_regs[11] = 32'hA9FF8701;
        
        
        
        for( i = 12; i < 32; i = i + 1) begin
            mem_regs[i] = 32'h00000000;
        end
        
        
    end
 
   assign read_data_1 = (read_register_1 == 0)? 32'd0 : mem_regs [read_register_1] ; // this a 5 bit number 0 to 31 indicating the reg number
   assign read_data_2 = (read_register_2  == 0)? 32'd0 : mem_regs [read_register_2] ;

  
    always @(posedge clk) begin
    if (register_write == 1 && write_register != 0) begin
        mem_regs[write_register] <= write_data; 
    end
end 
   
endmodule
