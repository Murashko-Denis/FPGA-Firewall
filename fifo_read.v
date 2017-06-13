module fifo_read(
		input         clk,
		input         DM,
		input 		prb,
      output  reg   fifo_read
    );

reg inpacket;
reg ena, prb_tr;	
integer cnt=0; 

always @(posedge clk)
begin
prb_tr<=prb;
end

assign front_pkt = (prb & !(prb_tr));
always @(posedge clk)
begin
if (front_pkt) 
	ena<=1'b1;
end

always @(posedge clk)
begin
if (front_pkt)
		cnt=0;
if (ena)
	if(cnt<36)
		cnt=cnt+1;
	else cnt=36;
end



always @(posedge clk)
begin
	if (DM & (cnt>34)) 
		fifo_read<=1'b1;
	else fifo_read<=1'b0;
end
endmodule
