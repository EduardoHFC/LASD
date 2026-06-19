/*Devido ao fato das instruções do tipo I possuírem operandos imediatos de 12bits e a ULA operar em
32bits, é necessário incluir um módulo extensor de sinal para viabilizar operações com imediatos
negativos.*/

module Extend(
    input  [11:0] Imm,
    output [31:0] ImmExtended
);

    assign ImmExtended = {{20{Imm[11]}}, Imm}; // ImmExtended vai receber a concatenacao do bit mais significativo repetido 20 vezes com Imm

endmodule