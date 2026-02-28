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
    
    wire [31:0] adder_address, instr_address, alu_result;
    wire [31:0] mux_out, imm_out, instruction_sl2;
    wire [31:0] instruction;
    wire [31:0] result, read_data_1, read_data_2, write_data;
    wire [31:0] write_register, read_data, alu_in;
    wire [2:0] alu_ctrl;
    
    pc_register pc(
        clk, rst,
        mux_out,
        instr_address
        );
        
    adder_pc a1(instr_address, 32'd4, adder_address);
    
    instruction_memory im1(instr_address, instruction);
    
    adder_pc a2(adder_address, instruction_sl2 , alu_result);
    
    mux2to1 m1(adder_address, alu_result, pcsrc, mux_out);
    
    mux2to1 m2(instruction[20:16], instruction[15:11], reg_dst, write_register);
    
    register_memory rm1(instruction[25:21],instruction[20:16],write_register, reg_write, 
    write_data,
    clk,
    read_data_1, read_data_2 
    );
    
    sign_extension se1(
    instruction[15:0],   // bits [15:0] from instruction
    imm_out   
    );
    
    sl2 sl_2(
    imm_out, instruction_sl2    
    );
    
    mux2to1 m3(read_data_2, imm_out, alu_src, alu_in);
    
    alu alu1(
    read_data_1, alu_in /*connected to mux*/,  // operands
    alu_ctrl,
    result,
    zero       //zeroflag_for_beq, wired back to PC,PC branches only when control signal and zero flag is true
    );
    
    control_unit cu1(
    instruction[31:26],
    reg_dst, //determines which instruction field specifies dest_reg address based on the type of instruction
    alu_src, //selects second operand for alu
    reg_write,
    mem_write,
    branch,
    mem_to_reg,

    alu_op // goes to ALU to specify what operation to be done

    );
    
    data_memory dm1(
    clk,
    result,      // from ALU 
    read_data_2,    // from RD2
    mem_write,           // from CU
    read_data    // Output to Memory-to-Reg MUX, for LW
    );
    
    mux2to1 m4(read_data, result, mem_to_reg, write_data);
    
    assign pcsrc = zero & branch;
endmodule
