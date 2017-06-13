module DM
(
input clk,
input ena,
input isAccept1,
input isAccept2,
input startRule,
output reg isAcceptAll,
output reg readyReg,
output reg readyDM
);
reg [255:0] shiftReg ;
integer i;
integer size=0;

always @(posedge clk)
begin
if (ena) 
	if (startRule) begin
		shiftReg <= {254'b0,isAccept1,isAccept2};
		readyReg <= 1'b0;
		size = 2;
		end
	else begin
			shiftReg <= {shiftReg[253:0],isAccept1,isAccept2};
			if (size==254) begin
				readyReg <= 1'b1;
				end
			else  begin
				readyReg <= 1'b0;
				size = size + 2;
			end
	end
end

always @(posedge clk)
begin
	if (readyReg) begin
		isAcceptAll <= &shiftReg[255:0];
		readyDM <= 1'b1;
		end
	else begin
	readyDM <= 1'b0;
	isAcceptAll <= 1'b0;
	end
end
endmodule