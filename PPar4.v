module PPar4
#(parameter N=400)//size packet
(
input [3:0] d,
input clk,
input reset,
input strobe,
output reg ready,
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
if (index==23) begin
	Dstmac<={packet[0],packet[1],packet[2],packet[3],packet[4],packet[5],packet[6],packet[7],packet[8],packet[9],packet[10],packet[11]};
	Srcmac<={packet[12],packet[13],packet[14],packet[15],packet[16],packet[17],packet[18],packet[19],packet[20],packet[21],packet[22],packet[23]};
	end
else if (index == 31) begin
			//Type Frame
			if ({packet[24],packet[25],packet[26],packet[27]} > 16'h05DC) begin
				//EthII
				Frame <= 2'b00;
				//VLAN
				if ({packet[24],packet[25],packet[26],packet[27]}==16'h8100)begin
					vlan <= 1'b1;
					vlan_shift = 8;//4 bytes shift
					end
				else begin
					vlan <= 1'b0;
					vlan_shift = 0;
				end
			end
			//Type Frame
			else if ({packet[28],packet[29],packet[30],packet[31]}==16'hFFFF) begin
							//802.3/Novell
							Frame <= 2'b01;
							ready1 <= 1'b1;
							end
			else if ({packet[28],packet[29],packet[30],packet[31]}==16'hAAAA) begin
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

if (index == 47+vlan_shift)begin //22+vlan_shft
	//!!!! 1 clock delay !!!! - all fields in massive "-1" (and index=="+1")
	Ethproto <= {packet[24+vlan_shift],packet[25+vlan_shift],packet[26+vlan_shift],packet[27+vlan_shift]};
	Ipproto <= {packet[46+vlan_shift],packet[47+vlan_shift]};
end
//no necessary fields => ready
if ((index == 48+vlan_shift) & (Ethproto !== 16'h0800) & ((Ipproto !== 8'h06) | (Ipproto !== 8'h11) | (Ipproto !== 8'h01))) begin
	ready2<=1'b1;
end
//if ip
if (Ethproto == 16'h0800) begin
		ip_header_length <= packet[29+vlan_shift];;
		ip_shift <= (ip_header_length - 4'b0101)*8;;
		fragment_flag<= packet[40+vlan_shift][2:1];
end

if ((Ethproto == 16'h0800) & (fragment_flag==2'b00)|(fragment_flag==2'b01)) begin
	fragment_shift<={packet[40+vlan_shift][3],packet[41+vlan_shift],packet[42+vlan_shift],packet[43+vlan_shift]};
	end
else begin
	fragment_shift <=13'b0; 
	end
	
if (index == 49 + vlan_shift)begin
	if (((fragment_flag==2'b00)&(fragment_shift !== 13'h0)) | (fragment_flag==2'b01)) begin
		isFragment <= 1'b1;
		end
	else isFragment <= 1'b0; 
end

//if ip - TCP or UDP or ICMP
if ((index==68+vlan_shift)&(Ethproto==16'h0800)) begin
			srcip4<={packet[52+vlan_shift],packet[53+vlan_shift],packet[54+vlan_shift],packet[55+vlan_shift],
					   packet[56+vlan_shift],packet[57+vlan_shift],packet[58+vlan_shift],packet[59+vlan_shift]};
			dstip4<={packet[60+vlan_shift],packet[61+vlan_shift],packet[62+vlan_shift],packet[63+vlan_shift],
					   packet[64+vlan_shift],packet[65+vlan_shift],packet[66+vlan_shift],packet[67+vlan_shift]};
		end
if ((index==76+vlan_shift+ip_shift) & ((Ipproto==8'h06) | (Ipproto==8'h11))) begin
			Srcport<={packet[68+vlan_shift+ip_shift],packet[69+vlan_shift+ip_shift],packet[70+vlan_shift+ip_shift],packet[71+vlan_shift+ip_shift]};
			Dstport<={packet[72+vlan_shift+ip_shift],packet[73+vlan_shift+ip_shift],packet[74+vlan_shift+ip_shift],packet[75+vlan_shift+ip_shift]};
			ready2<=1'b1;
			end
if ((index==72+vlan_shift+ip_shift)&(Ipproto==8'h01)) begin
			icmp<={packet[68+vlan_shift+ip_shift],packet[69+vlan_shift+ip_shift],packet[70+vlan_shift+ip_shift],packet[71+vlan_shift+ip_shift]};
			ready2<=1'b1;
			end		
end
endmodule




