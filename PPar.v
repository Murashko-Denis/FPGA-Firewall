module PPar
#(parameter N=200)//size packet
(
input [3:0] d,
input clk,
input reset,
input strobe,
output reg ready,//additional output
output reg [1:0] Frame,
output reg [47:0] Dstmac, 
output reg [47:0] Srcmac,
output reg vlan, //for test
output reg [15:0] Ethproto,
output reg [7:0] Ipproto,
output reg [31:0] srcip4, 
output reg [31:0] dstip4,
output reg [1:0] fragment_flag,// 2
output reg [12:0] fragment_shift,// + 13
output reg [15:0] Srcport, 
output reg [15:0] Dstport, 
output reg [15:0] icmp,
output reg isFragment
);
//necessary
reg [3:0] packet [N:0];
reg [3:0] ip_header_length;
reg [5:0] ip_shift;
reg ready0,ready1,ready2;
integer i, index, vlan_shift;
//counter
//register
always @(posedge clk or posedge reset)
begin
if (reset) begin
	ready0 <= 1'b0;
	index=0;
	for (i=0;i<=N; i=i+1)
		packet[i]<=0;
	end
else if (strobe) begin
	ready0 <= 1'b0;
	for (i=0;i<=N; i=i+1) begin
		packet[i]<=0;
	end
	packet[0] <= d;
	index = 0;
	end
else begin
	 index = index+1;
	 packet[index] <= d;
	/*if (index==N-1)
		index=index;
	for (i=1;i<=N;i=i+1)
		packet[i] <= packet[i-1];
	packet[0] <= d;*/
	end
end
//Frame Dstmac Srcmac 
always @(posedge clk)
begin
if (strobe) begin
	ready1<=1'b0;
end
if (index==12) begin
	Dstmac<={packet[0],packet[1],packet[2],packet[3],packet[4],packet[5]};
	Srcmac<={packet[6],packet[7],packet[8],packet[9],packet[10],packet[11]};
	end
else if (index == 15) begin
			//Type Frame
			if ({packet[12],packet[13]} > 16'h05DC) begin
				//EthII
				Frame <= 2'b00;
				//VLAN
				if ({packet[12],packet[13]}==16'h8100)begin
					vlan <= 1'b1;
					vlan_shift = 4;//4 bytes shift
					end
				else begin
					vlan <= 1'b0;
					vlan_shift = 0;
				end
			end
			//Type Frame
			else if ({packet[14],packet[15]}==16'hFFFF) begin
							//802.3/Novell
							Frame <= 2'b01;
							ready1 <= 1'b1;
							end
			else if ({packet[14],packet[15]}==16'hAAAA) begin
							//SNAP
							Frame <= 2'b10;
							ready1 <= 1'b1;
							end
			else begin 
							//802.3/LLC
							Frame <= 2'b11;
							ready1 <= 1'b1;
							end
			end
end

//Ethproto Ipproto fragment_flag fragment_shift srcip4 dstip4
always @(posedge clk)
begin
if (strobe) begin
	ready2 <= 1'b0;
end
ready <= ready0 | ready1 | ready2;//net

if (index == 25+vlan_shift)begin //22+vlan_shft
	Ethproto <= {packet[12+vlan_shift],packet[13+vlan_shift]};
	Ipproto <= packet[23+vlan_shift];
end
//no necessary fields => ready
if ((index == 26+vlan_shift) & (Ethproto !== 16'h0800) & ((Ipproto !== 8'h06) | (Ipproto !== 8'h11) | (Ipproto !== 8'h01))) begin
	ready2<=1'b1;
end
//if ip
if (Ethproto == 16'h0800) begin
		ip_header_length <= packet[14+vlan_shift][3:0];
		ip_shift <= (ip_header_length - 4'b0101);
		fragment_flag<= packet[20+vlan_shift][6:5];
end

if ((Ethproto == 16'h0800) & (fragment_flag==2'b00)|(fragment_flag==2'b01)) begin
	fragment_shift<={packet[20+vlan_shift][4:0],packet[21+vlan_shift]};
	end
/*else begin
	fragment_shift <=13'b0; 
	end wrong logic */
//isFragment 
if (index == 27 + vlan_shift)begin
	if (((fragment_flag==2'b00)&(fragment_shift !== 13'h0)) | (fragment_flag==2'b01)) begin
		isFragment <= 1'b1;
		end
	else isFragment <= 1'b0; 
end


//if ip - TCP or UDP or ICMP
if ((index==34+vlan_shift)&(Ethproto==16'h0800)) begin
			srcip4<={packet[26+vlan_shift],packet[27+vlan_shift],packet[28+vlan_shift],packet[29+vlan_shift]};
			dstip4<={packet[30+vlan_shift],packet[31+vlan_shift],packet[32+vlan_shift],packet[33+vlan_shift]};
		end
if ((index==38+vlan_shift+ip_shift) & ((Ipproto==8'h06) | (Ipproto==8'h11))) begin
			Srcport<={packet[34+vlan_shift+ip_shift],packet[35+vlan_shift+ip_shift]};
			Dstport<={packet[36+vlan_shift+ip_shift],packet[37+vlan_shift+ip_shift]};
			ready2<=1'b1;
			end
if ((index==35+vlan_shift+ip_shift)&(Ipproto==8'h01)) begin
			icmp<={packet[34+vlan_shift+ip_shift],packet[35+vlan_shift+ip_shift]};
			ready2<=1'b1;
			end		
end
endmodule
