`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 03:47:24 PM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk, rst
    );
    
    wire [31:0] adder_address, instruction_out, instruction_reg_out;
    wire [31:0] alu_add_branch, adder_mux_address, instr_address;
    wire [31:0] read_data_1, read_data_2, result;
    wire write_reg_in, pc_src;
    wire reg_write, zero, reg_write_wb;
    wire [73:0] id_ex_op;
    wire [2:0] alu_op;
    wire [38:0] exwbout;
    wire [31:0] write_data;
    wire [4:0] wn;
    
    // Instruction Fetch Stage
    
    pc_register pc(
        clk, rst,
        adder_address,
        instr_address
        );
        
    adder_pc a1(instr_address, 32'd4, adder_address);
    
    instruction_memory im1(
        instr_address,
        instruction_out
        );
        
    ifid if_id_reg1(
            clk, rst,
            instruction_out,
            instruction_reg_out
            );     

  // Instruction Decode Stage      
        
    register_memory rm1(
            instruction_reg_out[9:5],instruction_reg_out[4:0],wn, //5 bit input line to access registers
            reg_write_wb, // set by control signal
            write_data,
            clk,
            read_data_1, read_data_2 //spitting out the data from registers
        
    );
    
            
    control_unit cu1(
            instruction_reg_out[31:15],
            reg_write,
            alu_op // goes to ALU to specify what operation to be done
        
        
        );
       
    
    id_ex_reg idex1(
        clk, rst,
        {read_data_1, read_data_2, reg_write, alu_op, instruction_reg_out[14:10]},
        id_ex_op
        );
        
    // Execute Stage
    
    alu alu1(
        id_ex_op[72:41] /* connected to read_data_1 */ , id_ex_op[40:9] /*connected to mux*/,  // operands
        id_ex_op[7:5],
        result,
        zero       //zeroflag_for_beq, wired back to PC,PC branches only when control signal and zero flag is true
        );
    
   ex_wb_reg emr1(
            clk, rst,
            {result, id_ex_op[8], id_ex_op[4:0]},
            exwbout
            );    
    
    // Writeback stage
    
    assign write_data = exwbout[37:6];
    assign wn = exwbout[4:0];
    assign reg_write_wb = exwbout[5];
    

endmodule
