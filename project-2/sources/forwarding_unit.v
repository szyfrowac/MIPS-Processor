module forwarding_unit(
    input exmem_reg_write,
    input [3:0] exmem_rd,
    input memwb_reg_write,
    input [3:0] memwb_rd,
    input [3:0] idex_rs,
    input [3:0] idex_rt,
    output reg [1:0] forward_a,
    output reg [1:0] forward_b
);

always @(*) begin
    forward_a = 2'b00;
    forward_b = 2'b00;

    // EX/MEM has priority.
    if (exmem_reg_write && (exmem_rd != 4'd0) && (exmem_rd == idex_rs)) begin
        forward_a = 2'b10;
    end else if (memwb_reg_write && (memwb_rd != 4'd0) && (memwb_rd == idex_rs)) begin
        forward_a = 2'b01;
    end

    if (exmem_reg_write && (exmem_rd != 4'd0) && (exmem_rd == idex_rt)) begin
        forward_b = 2'b10;
    end else if (memwb_reg_write && (memwb_rd != 4'd0) && (memwb_rd == idex_rt)) begin
        forward_b = 2'b01;
    end
end

endmodule
