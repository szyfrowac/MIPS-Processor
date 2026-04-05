module control_unit(
    input [16:0] opcode,
    output reg reg_write,
    output reg [2:0] alu_op // goes to ALU to specify what operation to be done


);

always @(*) begin

    reg_write = 0;
    alu_op = 3'b000;
        
    

    case (opcode)
            17'b101: begin
                reg_write = 1;
                alu_op    = 3'b000; // ADD
            end
                
            17'b110: begin // SUB
                reg_write = 1;
                alu_op    = 3'b001; 
            end
            
            17'b111: begin //NAND
             
                reg_write = 1;
                alu_op    = 3'b010; 
            end
            
            17'b100: begin // NOR
                reg_write = 1;
                alu_op    = 3'b011; 
            end
            
            default: begin
                reg_write = 0;
                alu_op = 3'b000;
            end
            
        endcase
    end



endmodule