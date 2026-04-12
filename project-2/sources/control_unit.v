module control_unit(
    input [3:0] opcode,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg alu_src,
    output reg mem_to_reg,
    output reg [2:0] alu_op
);

// Project-specified 4-bit opcodes.
localparam OP_SUBI = 4'b0000;
localparam OP_SW_1 = 4'b0100;
localparam OP_SW_2 = 4'b0010;
localparam OP_LW   = 4'b0001;
localparam OP_AND  = 4'b1111;

always @(*) begin
    reg_write  = 1'b0;
    mem_read   = 1'b0;
    mem_write  = 1'b0;
    alu_src    = 1'b0;
    mem_to_reg = 1'b0;
    alu_op     = 3'b000;

    case (opcode)
        OP_AND: begin
            reg_write = 1'b1;
            alu_src   = 1'b0;
            alu_op    = 3'b010; // AND
        end

        OP_LW: begin
            reg_write  = 1'b1;
            mem_read   = 1'b1;
            alu_src    = 1'b1;
            mem_to_reg = 1'b1;
            alu_op     = 3'b000; // base + offset
        end

        OP_SW_1,
        OP_SW_2: begin
            mem_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 3'b000; // base + offset
        end

        OP_SUBI: begin
            reg_write = 1'b1;
            alu_src   = 1'b1;
            alu_op    = 3'b001; // SUB with immediate
        end

        default: begin
            reg_write  = 1'b0;
            mem_read   = 1'b0;
            mem_write  = 1'b0;
            alu_src    = 1'b0;
            mem_to_reg = 1'b0;
            alu_op     = 3'b000;
        end
    endcase
end

endmodule