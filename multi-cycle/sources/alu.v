

module alu (
    input  [31:0] A,
    input  [31:0] B,
    input  [1:0]  ALUControl,       
    output reg [31:0] ALUResult,
    output             Zero
);
    localparam ALU_ADD  = 2'b00;
    localparam ALU_SUB  = 2'b01;
    localparam ALU_NAND = 2'b10;

    assign Zero = (ALUResult == 32'h0);

    always @(*) begin
        case (ALUControl)
            ALU_ADD  : ALUResult = A + B;
            ALU_SUB  : ALUResult = A - B;
            ALU_NAND : ALUResult = ~(A & B);
            default  : ALUResult = 32'hx;   // 2'b11 unused — flag with X
        endcase
    end

endmodule