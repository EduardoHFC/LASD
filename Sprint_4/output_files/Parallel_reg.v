module parallel_reg #(parameter N = 4) (input clk, rst, en, 
                                     input [N-1:0] serial_in, output reg[N-1:0] parallel_out);
  
  always @ (posedge clk, negedge rst)
    begin
      if (!rst) begin
        parallel_out <= 0;
      end
      else if (!en) begin
        parallel_out <= parallel_out;
      end
      else begin
        parallel_out <=  serial_in[N-1:0];
	end
  end
endmodule