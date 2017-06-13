module gmii_tx(
      input         reset,
		input         clk,
		input         ena,
		input 		  fifo_empty,
    	input  [3:0]  fifo_d,
		
		
    	output  reg [3:0]  gmii_txd,
      output  reg      gmii_tx_en,
      output  reg      gmii_tx_er
      //output  reg      clk_en,
    );

	 

always @(posedge clk)
begin
if (ena) begin
   gmii_txd<=fifo_d;
	gmii_tx_er<=1'b0;
	if (fifo_empty)
		gmii_tx_en<=1'b0;
		else gmii_tx_en<=1'b1;
	end
else 
	gmii_tx_en<=1'b0;	
end

endmodule
