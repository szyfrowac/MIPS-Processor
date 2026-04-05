// temp_reg.v — Pipeline Latch Registers: A, B, ALUOut
//
// These are the "invisible" registers added in the multi-cycle design.
// They hold values between clock cycles so the same functional unit
// (ALU, memory) can be reused in a later stage without re-reading.
//
// A      : holds read_data1 from register file (rs value)
// B      : holds read_data2 from register file (rt value)
// ALUOut : holds ALU result — used as branch/data address in next cycle
//
// All three latch unconditionally every cycle (no write-enable needed).
// The control FSM ensures data is valid before it is consumed.

module temp_reg (
    input        clk,
    input        rst,
    input  [31:0] reg_data1,      // from register file read port 1
    input  [31:0] reg_data2,      // from register file read port 2
    input  [31:0] alu_result,     // from ALU output
    output reg [31:0] A,
    output reg [31:0] B,
    output reg [31:0] ALUOut
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A      <= 32'h0;
            B      <= 32'h0;
            ALUOut <= 32'h0;
        end else begin
            A      <= reg_data1;
            B      <= reg_data2;
            ALUOut <= alu_result;
        end
    end

endmodule