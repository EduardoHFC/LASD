`default_nettype none //Comando para desabilitar declaração automática de wires
module Mod_Teste (
//Clocks
input CLOCK_27, CLOCK_50,
//Chaves e Botoes
input [3:0] KEY,
input [17:0] SW,
//Displays de 7 seg e LEDs
output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
output [8:0] LEDG,
output [17:0] LEDR,
//Serial
output UART_TXD,
input UART_RXD,
inout [7:0] LCD_DATA,
output LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
//GPIO
inout [35:0] GPIO_0, GPIO_1
);
assign GPIO_1 = 36'hzzzzzzzzz;
assign GPIO_0 = 36'hzzzzzzzzz;
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;
wire [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5,
w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;
LCD_TEST MyLCD (
.iCLK ( CLOCK_50 ),
.iRST_N ( KEY[0] ),
.d0x0(w_d0x0),.d0x1(w_d0x1),.d0x2(w_d0x2),.d0x3(w_d0x3),.d0x4(w_d0x4),.d0x5(w_d0x5),
.d1x0(w_d1x0),.d1x1(w_d1x1),.d1x2(w_d1x2),.d1x3(w_d1x3),.d1x4(w_d1x4),.d1x5(w_d1x5),
.LCD_DATA( LCD_DATA ),
.LCD_RW ( LCD_RW ),
.LCD_EN ( LCD_EN ),
.LCD_RS ( LCD_RS )
);
//---------- modifique a partir daqui --------

//---------- modifique a partir daqui --------

// Clock e reset
wire clk;
wire rst;

assign clk = KEY[1];
assign rst = KEY[0];

// Sinais do PC
wire [31:0] w_PC;
wire [31:0] w_PCin;

// Instrução atual
wire [31:0] w_Inst;

// Campos da instrução
wire [6:0] w_OP;
wire [2:0] w_Funct3;
wire [6:0] w_Funct7;
wire [4:0] w_rs1;
wire [4:0] w_rs2;
wire [4:0] w_rd;

// Sinais de controle
wire       w_RegWrite;
wire       w_ULASrc;
wire [2:0] w_ULAControl;

// Banco de registradores
wire [31:0] w_rd1SrcA;
wire [31:0] w_rd2;

// Imediato estendido
wire [31:0] w_ImmExt;

// Entrada B da ULA
wire [31:0] w_SrcB;

// Resultado da ULA
wire [31:0] w_ULAResultWd3;

// Saídas auxiliares do banco de registradores
wire [31:0] w_x0;
wire [31:0] w_x1;
wire [31:0] w_x2;
wire [31:0] w_x3;
wire [31:0] w_x4;
wire [31:0] w_x5;
wire [31:0] w_x6;
wire [31:0] w_x7;


// ============================================================
// PC
// ============================================================

assign w_PCin = w_PC + 32'd4;

PC PC_rv (
    .clk(clk),
    .rst(rst),
    .PCin(w_PCin),
    .PC(w_PC)
);


// ============================================================
// Memória de instruções
// ============================================================

InstructionMemory IMEM (
    .A(w_PC),
    .RD(w_Inst)
);


// ============================================================
// Separação dos campos da instrução RISC-V
// ============================================================

assign w_OP     = w_Inst[6:0];
assign w_rd     = w_Inst[11:7];
assign w_Funct3 = w_Inst[14:12];
assign w_rs1    = w_Inst[19:15];
assign w_rs2    = w_Inst[24:20];
assign w_Funct7 = w_Inst[31:25];


// ============================================================
// Unidade de controle
// ============================================================

ControlUnit UC (
    .OP(w_OP),
    .Funct3(w_Funct3),
    .Funct7(w_Funct7),
    .RegWrite(w_RegWrite),
    .ULASrc(w_ULASrc),
    .ULAControl(w_ULAControl)
);


// ============================================================
// Extensor de sinal
// ============================================================

Extend EXT (
    .Imm(w_Inst[31:20]),
    .ImmExtended(w_ImmExt)
);


// ============================================================
// Banco de registradores
// ============================================================

BancodeRegs banco (
    .clk(clk),
    .rst(rst),

    .ra1(w_rs1),
    .ra2(w_rs2),
    .wa3(w_rd),

    .we3(w_RegWrite),
    .wd3(w_ULAResultWd3),

    .rd1(w_rd1SrcA),
    .rd2(w_rd2),

    .x0(w_x0),
    .x1(w_x1),
    .x2(w_x2),
    .x3(w_x3),
    .x4(w_x4),
    .x5(w_x5),
    .x6(w_x6),
    .x7(w_x7)
);


// ============================================================
// MUX da entrada B da ULA
// ============================================================

MUX2x1 MuxULASrc (
    .Sel(w_ULASrc),
    .a(w_rd2),
    .b(w_ImmExt),
    .Out(w_SrcB)
);


// ============================================================
// ULA
// ============================================================

ULA ULARiscV (
    .SrcA(w_rd1SrcA),
    .SrcB(w_SrcB),
    .ULAControl(w_ULAControl),
    .Z(LEDG[0]),
    .ULAResult(w_ULAResultWd3)
);


// ============================================================
// LCD - debug dos registradores e PC
// ============================================================

// Linha 0 do LCD
assign w_d0x0 = w_x0[7:0];
assign w_d0x1 = w_x1[7:0];
assign w_d0x2 = w_x2[7:0];
assign w_d0x3 = w_x3[7:0];

// PC na posição w_d0x4
assign w_d0x4 = w_PC[7:0];

assign w_d0x5 = 8'h20;

// Linha 1 do LCD
assign w_d1x0 = w_x4[7:0];
assign w_d1x1 = w_x5[7:0];
assign w_d1x2 = w_x6[7:0];
assign w_d1x3 = w_x7[7:0];

assign w_d1x4 = 8'h20;
assign w_d1x5 = 8'h20;


// ============================================================
// Displays HEX0-HEX7
// Mostram o código de máquina da instrução atual
// ============================================================

decodificador disp0 (
    .In(w_Inst[3:0]),
    .Out(HEX0)
);

decodificador disp1 (
    .In(w_Inst[7:4]),
    .Out(HEX1)
);

decodificador disp2 (
    .In(w_Inst[11:8]),
    .Out(HEX2)
);

decodificador disp3 (
    .In(w_Inst[15:12]),
    .Out(HEX3)
);

decodificador disp4 (
    .In(w_Inst[19:16]),
    .Out(HEX4)
);

decodificador disp5 (
    .In(w_Inst[23:20]),
    .Out(HEX5)
);

decodificador disp6 (
    .In(w_Inst[27:24]),
    .Out(HEX6)
);

decodificador disp7 (
    .In(w_Inst[31:28]),
    .Out(HEX7)
);


// ============================================================
// LEDs de debug
// LEDR[4:0] = sinais de controle
// ============================================================

assign LEDR[4:0] = {w_RegWrite, w_ULASrc, w_ULAControl};
assign LEDR[17:5] = 13'b0;

// LED verde para visualizar clock manual
assign LEDG[8] = ~KEY[1];
assign LEDG[7:1] = 7'b0;

// UART desativada
assign UART_TXD = 1'b1;

endmodule