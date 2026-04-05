module pc(
    input clk,rst,PCWrite,PCWriteCond,branch_taken,
    input [31:0] pc_next,
    output reg [31:0] pc_out
) ;

assign pc_enable = PCWrite | (PCWriteCond & branch_taken) ;


always @(posedge clk,posedge rst) begin

if(rst) pc_out <= 32'b0 ;
else if(pc_enable) pc_out <= pc_next ;


end





endmodule