module instruction_reg (
    input        clk,
    input        rst,
    input        IRWrite,
    input  [31:0] mem_data,        
    output reg [31:0] IR           
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            IR <= 32'h0;
        else if (IRWrite)
            IR <= mem_data;
    end



endmodule