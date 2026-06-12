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

wire clk;
wire rst;

wire [4:0] ra1;
wire [4:0] ra2;
wire [4:0] wa3;
wire       we3;

wire [31:0] wd3;

wire [31:0] w_rd1SrcA;
wire [31:0] w_rd2;
wire [31:0] w_SrcB;
wire [31:0] w_ULAResultWd3;

// Ligações conforme o datapath do PDF
assign clk = KEY[1];
assign rst = KEY[2];

assign we3 = 1'b1;

assign ra1 = {2'b00, SW[13:11]};
assign ra2 = {2'b00, 3'b010};
assign wa3 = {2'b00, SW[16:14]};

assign wd3 = {24'b0, SW[7:0]};

BancodeRegs banco (
    .clk(clk),
    .rst(rst),
    .ra1(ra1),
    .ra2(ra2),
    .wa3(wa3),
    .we3(we3),
    .wd3(wd3),
    .rd1(w_rd1SrcA),
    .rd2(w_rd2)
);

MUX2x1 MuxULASrc (
    .Sel(SW[17]),
    .a(w_rd2),
    .b(32'h00000007),
    .Out(w_SrcB)
);

ULA ULARiscV (
    .SrcA(w_rd1SrcA),
    .SrcB(w_SrcB),
    .ULAControl(SW[10:8]),
    .Z(LEDG[0]),
    .ULAResult(w_ULAResultWd3)
);

assign w_d0x0 = w_rd1SrcA[7:0];
assign w_d1x0 = w_rd2[7:0];
assign w_d1x1 = w_SrcB[7:0];
assign w_d0x4 = w_ULAResultWd3[7:0];

assign w_d0x1 = 8'h20;
assign w_d0x2 = 8'h20;
assign w_d0x3 = 8'h20;
assign w_d0x5 = 8'h20;

assign w_d1x2 = 8'h20;
assign w_d1x3 = 8'h20;
assign w_d1x4 = 8'h20;
assign w_d1x5 = 8'h20;


assign LEDG[8] = ~KEY[1];

decodificador disp0 (
    .In(SW[3:0]),
    .Out(HEX0)
);

decodificador disp1 (
    .In(SW[7:4]),
    .Out(HEX1)
);

endmodule