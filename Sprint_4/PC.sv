/*Faça a descrição de hardware, em Verilog/SystemVerilog, do Registrador PC (Program Counter). Tal
componente é um registrador de 32 bits com uma entrada de clock (clk), uma entrada de reset (rst),
uma entrada para carregamento paralelo (PCin) e uma saída paralela (PC).*/

module PC(
    input rst,
    input clk,
    input [31:0] PCin,
    output reg [31:0] PC
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            PC <= 32'b0;
        end
        else begin
            PC <= PCin;
        end
    end

endmodule