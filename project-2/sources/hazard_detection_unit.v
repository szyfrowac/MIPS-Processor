module hazard_detection_unit(
    input idex_mem_read,
    input [3:0] idex_rd,
    input [3:0] ifid_rs,
    input [3:0] ifid_rt,
    output reg stall
);

always @(*) begin
    // Load-use hazard: stall IF/ID and inject bubble into ID/EX.
    if (idex_mem_read && (idex_rd != 4'd0) && ((idex_rd == ifid_rs) || (idex_rd == ifid_rt))) begin
        stall = 1'b1;
    end else begin
        stall = 1'b0;
    end
end

endmodule
