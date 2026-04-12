`timescale 1ns / 1ps

module data_memory(
    input clk,
    input mem_read,
    input mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

    reg [31:0] mem [0:255];
    integer i;
    wire [7:0] word_addr;

    assign word_addr = address[9:2];

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'b0;
        end

        // Preload location used by LW r6, 8(r5) with r5=0x000F.
        // Effective byte address = 0x17 -> word index 5 when aligned by [31:2].
        mem[8'h05] = 32'h00001234;
    end

    always @(*) begin
        if (mem_read) begin
            read_data = mem[word_addr];
        end else begin
            read_data = 32'b0;
        end
    end

    always @(posedge clk) begin
        if (mem_write) begin
            mem[word_addr] <= write_data;
        end

        if ((mem_read || mem_write) && (address[1:0] != 2'b00)) begin
            $display("[DMEM] Warning: unaligned address %h, using word index %0d", address, word_addr);
        end
    end

endmodule
