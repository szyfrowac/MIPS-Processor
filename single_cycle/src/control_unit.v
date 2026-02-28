module control_unit(
    input [5:0] opcode,
    output reg  reg_dst, //determines which instruction field specifies dest_reg address based on the type of instruction
    output reg alu_src, //selects second operand for alu
    output reg reg_write,
    output reg mem_write,
    output reg branch,
    output reg mem_to_reg,

    output reg [2:0] alu_op // goes to ALU to specify what operation to be done


);

always @(*) begin
        
     {reg_dst, alu_src, mem_to_reg, reg_write, mem_write, branch} = 6'b0;
        alu_op = 3'b000; //all set to zero

    case (opcode)
            6'h00: begin // R-type (OR)
                reg_dst   = 1;
                reg_write = 1;
                alu_op    = 3'b000; // OR operation
            end
            6'h08: begin // SUBI
                alu_src   = 1;
                reg_write = 1;
                alu_op    = 3'b010;  //SUB OPERATION
            end
            6'h2B: begin // SW
                alu_src   = 1;
                mem_write = 1;
                alu_op    = 3'b001; //ADD FOR ADDRESS CALC
            end
            6'h04: begin // BEQ
                branch    = 1;
                alu_op    = 3'b010; //SUB FOR COMPARISON
            end
        endcase
    end



endmodule