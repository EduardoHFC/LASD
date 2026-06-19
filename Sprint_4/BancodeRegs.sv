module BancodeRegs (
    input [31:0] wd3,
    input [4:0] wa3,
    input we3,
    input clk,
    input [4:0] ra1, ra2,
    input rst,

    output [31:0] rd1,
    output [31:0] rd2,

    output [31:0] x0,
    output [31:0] x1,
    output [31:0] x2,
    output [31:0] x3,
    output [31:0] x4,
    output [31:0] x5,
    output [31:0] x6,
    output [31:0] x7
);

    reg [31:0] registradores [0:31];

    integer i;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registradores[i] <= 32'b0;
            end
        end
        else if (we3 && (wa3 != 5'b00000)) begin
            registradores[wa3] <= wd3;
        end
    end

    assign rd1 = (ra1 == 5'b00000) ? 32'b0 : registradores[ra1];
    assign rd2 = (ra2 == 5'b00000) ? 32'b0 : registradores[ra2];

    // Saídas auxiliares para debug
    assign x0 = 32'b0;
    assign x1 = registradores[1];
    assign x2 = registradores[2];
    assign x3 = registradores[3];
    assign x4 = registradores[4];
    assign x5 = registradores[5];
    assign x6 = registradores[6];
    assign x7 = registradores[7];

endmodule