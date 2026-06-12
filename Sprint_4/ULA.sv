module ULA(
    input  logic [2:0]  ULAControl,
    input  logic [31:0] SrcA, SrcB,
    output logic        Z,
    output logic [31:0] ULAResult
);

always @ (*) begin
    case (ULAControl)

        3'b000: ULAResult = SrcA + SrcB;

        3'b001: ULAResult = SrcA + ~SrcB + 1;

        3'b010: ULAResult = SrcA & SrcB;

        3'b011: ULAResult = SrcA | SrcB;

        3'b101: begin
            if (SrcA < SrcB)
                ULAResult = 32'b1;
            else
                ULAResult = 32'b0;
        end

        default: ULAResult = 32'b0;

    endcase

    Z = (ULAResult == 32'b0);
end

endmodule