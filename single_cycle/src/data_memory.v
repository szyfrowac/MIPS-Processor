module data_memory(
    input clk,
    input [31:0] address,      // from ALU 
    input [31:0] write_data,    // from RD2
    input mem_write,           // from CU
    output [31:0] read_data    // Output to Memory-to-Reg MUX, for LW
);

    reg [31:0] mem [0:31];     


    always @(posedge clk) begin
        if (mem_write) begin
            mem[address[31:2]] <= write_data; 
        end
    end

 
    assign read_data = mem[address[31:2]];

endmodule