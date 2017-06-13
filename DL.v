module DL
(
input clk,
input ena,
//from rules
input [970:0] rule1,
input [970:0] rule2,
//fields packet from PPar
input [1:0] Frame,
input [47:0] Dstmac, 
input [47:0] Srcmac,
input [15:0] Ethproto,
input [7:0] Ipproto,
input [31:0] srcip4, 
input [31:0] dstip4,
input isFragment,
input [15:0] Srcport, 
input [15:0] Dstport, 
input [15:0] icmp,
output reg [7:0] addr1,
output reg [7:0] addr2,
output reg isAccept1,
output reg isAccept2,
output reg ready,
//output reg nextAdressExist,
output reg start,
input rst
);

//1st rule
reg Frame1_accept;
reg Dstmac1_accept;
reg Srcmac1_accept;
reg Ethproto1_accept;
reg Ipproto1_accept;
reg srcip41_accept;
reg dstip41_accept;
reg isFragment1_accept;
reg Srcport1_accept;
reg Dstport1_accept;
reg icmp1_accept;
//2nd rule
reg Frame2_accept;
reg Dstmac2_accept;
reg Srcmac2_accept;
reg Ethproto2_accept;
reg Ipproto2_accept;
reg srcip42_accept;
reg dstip42_accept;
reg isFragment2_accept;
reg Srcport2_accept;
reg Dstport2_accept;
reg icmp2_accept;

reg ready_accept; //to sync logic

//attributes packet
//wire [7:0] number1 = rule1[970:963];
wire activity1 = rule1[962];
wire action1 = rule1[961];
wire [1:0] direction1 = rule1[960:959];
wire registation1 = rule1[958];
wire [1:0] Frame1_code = rule1[957:956];
wire [1:0] Dstmac1_code = rule1[947:946];
wire [1:0] Srcmac1_code = rule1[753:752];
wire [1:0] Ethproto1_code = rule1[559:558];
wire [1:0] Ipproto1_code = rule1[493:492];
wire [1:0] srcip41_code = rule1[459:458];
wire [1:0] dstip41_code = rule1[329:328];
wire [1:0] isFragment1_rule = rule1[199:198]; // "10" bit-any, 198: "1" -fragment, "0" - dont fragment, "11" - impossible
wire [1:0] Srcport1_code = rule1[197:196];
wire [1:0] Dstport1_code = rule1[131:130];
wire [1:0] icmp1_code = rule1[65:64];

//2nd rule
//wire [7:0] number2 = rule1[970:963];
wire activity2 = rule2[962];
wire action2 = rule2[961];
wire [1:0] direction2 = rule2[960:959];
wire registation2 = rule2[958];
wire [1:0] Frame2_code = rule2[957:956];
wire [1:0] Dstmac2_code = rule2[947:946];
wire [1:0] Srcmac2_code = rule2[753:752];
wire [1:0] Ethproto2_code = rule2[559:558];
wire [1:0] Ipproto2_code = rule2[493:492];
wire [1:0] srcip42_code = rule2[459:458];
wire [1:0] dstip42_code = rule2[329:328];
wire [1:0] isFragment2_rule = rule2[199:198]; //199 bit-any, 198: "1" -fragment, "0" - dont fragment, "11" - impossible
wire [1:0] Srcport2_code = rule2[197:196];
wire [1:0] Dstport2_code = rule2[131:130];
wire [1:0] icmp2_code = rule2[65:64];

initial begin
addr1 = 8'h0;
addr2 = 8'h1;
ready = 1'b0;
end

always@(posedge clk)
begin
if (ena) begin 
	ready_accept <= 1'b1;
	case (Frame1_code)
	2'b00: Frame1_accept <= 1'b1;
	2'b01: Frame1_accept <= (Frame==rule1[949:948]) ? 1'b1 :1'b0;
	2'b10: Frame1_accept <= ((Frame==rule1[949:948])|(Frame==rule1[951:950])|(Frame==rule1[953:952])|(Frame==rule1[955:954])) ? 1'b1 :1'b0;
	2'b11: Frame1_accept <= ((Frame>=rule1[949:948])|(Frame<=rule1[951:950])) ? 1'b1 :1'b0;
	endcase
	
	case (Dstmac1_code)
	2'b00: Dstmac1_accept <= 1'b1;
	2'b01: Dstmac1_accept <= (Dstmac==rule1[801:754]) ? 1'b1 :1'b0;
	2'b10: Dstmac1_accept <= ((Dstmac==rule1[801:754])|(Dstmac==rule1[849:802])|(Dstmac==rule1[897:850])|(Dstmac==rule1[945:898])) ? 1'b1 :1'b0;
	2'b11: Dstmac1_accept <= ((Dstmac>=rule1[801:754])|(Dstmac<=rule1[849:802])) ? 1'b1 :1'b0;
	endcase
	
	case (Srcmac1_code)
	2'b00: Srcmac1_accept <= 1'b1;
	2'b01: Srcmac1_accept <= (Srcmac==rule1[607:560]) ? 1'b1 :1'b0;
	2'b10: Srcmac1_accept <= ((Srcmac==rule1[607:560])|(Srcmac==rule1[655:608])|(Srcmac==rule1[703:656])|(Srcmac==rule1[751:704])) ? 1'b1 :1'b0;
	2'b11: Srcmac1_accept <= ((Srcmac>=rule1[607:560])|(Srcmac<=rule1[655:608])) ? 1'b1 :1'b0;
	endcase
	
	case (Ethproto1_code)
	2'b00: Ethproto1_accept <= 1'b1;
	2'b01: Ethproto1_accept <= (Ethproto==rule1[509:494]) ? 1'b1 :1'b0;
	2'b10: Ethproto1_accept <= ((Ethproto==rule1[509:494])|(Ethproto==rule1[525:510])|(Ethproto==rule1[541:526])|(Ethproto==rule1[557:542])) ? 1'b1 :1'b0;
	2'b11: Ethproto1_accept <= ((Ethproto>=rule1[509:494])|(Ethproto<=rule1[525:510])) ? 1'b1 :1'b0;
	endcase
	
	case (Ipproto1_code)
	2'b00: Ipproto1_accept <= 1'b1;
	2'b01: Ipproto1_accept <= (Ipproto==rule1[467:460]) ? 1'b1 :1'b0;
	2'b10: Ipproto1_accept <= ((Ipproto==rule1[467:460])|(Ipproto==rule1[475:468])|(Ipproto==rule1[483:476])|(Ipproto==rule1[491:484])) ? 1'b1 :1'b0;
	2'b11: Ipproto1_accept <= ((Ipproto>=rule1[467:460])|(Ipproto<=rule1[475:468])) ? 1'b1 :1'b0;
	endcase
	
	case (srcip41_code)
	2'b00: srcip41_accept <= 1'b1;
	2'b01: srcip41_accept <= (srcip4==rule1[361:330]) ? 1'b1 :1'b0;
	2'b10: srcip41_accept <= ((srcip4==rule1[361:330])|(srcip4==rule1[393:362])|(srcip4==rule1[425:394])|(srcip4==rule1[457:426])) ? 1'b1 :1'b0;
	2'b11: srcip41_accept <= ((srcip4>=rule1[361:330])|(srcip4<=rule1[393:362])) ? 1'b1 :1'b0;
	endcase
	
	case (dstip41_code)
	2'b00: dstip41_accept <= 1'b1;
	2'b01: dstip41_accept <= (dstip4==rule1[231:200]) ? 1'b1 :1'b0;
	2'b10: dstip41_accept <= ((dstip4==rule1[231:200])|(dstip4==rule1[263:232])|(dstip4==rule1[295:264])|(dstip4==rule1[327:296])) ? 1'b1 :1'b0;
	2'b11: dstip41_accept <= ((dstip4>=rule1[231:200])|(dstip4<=rule1[263:232])) ? 1'b1 :1'b0;
	endcase
	
	if (isFragment1_rule == 2'b00) begin //"11" - impossible
		isFragment1_accept <= 1'b1; 
		end
	else isFragment1_accept <= (rule1[198] == isFragment) ? 1'b1 : 1'b0; //[198] - 2 bit isFragment1_rule
	
	case (Srcport1_code)
	2'b00: Srcport1_accept <= 1'b1;
	2'b01: Srcport1_accept <= (Srcport==rule1[147:132]) ? 1'b1 :1'b0;
	2'b10: Srcport1_accept <= ((Srcport==rule1[147:132])|(Srcport==rule1[163:148])|(Srcport==rule1[179:164])|(Srcport==rule1[195:180])) ? 1'b1 :1'b0;
	2'b11: Srcport1_accept <= ((Srcport>=rule1[147:132])|(Srcport<=rule1[163:148])) ? 1'b1 :1'b0;
	endcase
	
	case (Dstport1_code)
	2'b00: Dstport1_accept <= 1'b1;
	2'b01: Dstport1_accept <= (Dstport==rule1[81:66]) ? 1'b1 :1'b0;
	2'b10: Dstport1_accept <= ((Dstport==rule1[81:66])|(Dstport==rule1[97:82])|(Dstport==rule1[113:98])|(Dstport==rule1[129:114])) ? 1'b1 :1'b0;
	2'b11: Dstport1_accept <= ((Dstport>=rule1[81:66])|(Dstport<=rule1[97:82])) ? 1'b1 :1'b0;
	endcase
	
	case (icmp1_code)
	2'b00: icmp1_accept <= 1'b1;
	2'b01: icmp1_accept <= (Dstport==rule1[15:0]) ? 1'b1 :1'b0;
	2'b10: icmp1_accept <= ((Dstport==rule1[15:0])|(Dstport==rule1[31:16])|(Dstport==rule1[47:32])|(Dstport==rule1[63:48])) ? 1'b1 :1'b0;
	2'b11: icmp1_accept <= ((Dstport>=rule1[15:0])|(Dstport<=rule1[31:16])) ? 1'b1 :1'b0;
	endcase
	//end 1st rule
	
	//2nd rule
	case (Frame2_code)
	2'b00: Frame2_accept <= 1'b1;
	2'b01: Frame2_accept <= (Frame==rule2[949:948]) ? 1'b1 :1'b0;
	2'b10: Frame2_accept <= ((Frame==rule2[949:948])|(Frame==rule2[951:950])|(Frame==rule2[953:952])|(Frame==rule2[955:954])) ? 1'b1 :1'b0;
	2'b11: Frame2_accept <= ((Frame>=rule2[949:948])|(Frame<=rule2[951:950])) ? 1'b1 :1'b0;
	endcase
	
	case (Dstmac2_code)
	2'b00: Dstmac2_accept <= 1'b1;
	2'b01: Dstmac2_accept <= (Dstmac==rule2[801:754]) ? 1'b1 :1'b0;
	2'b10: Dstmac2_accept <= ((Dstmac==rule2[801:754])|(Dstmac==rule2[849:802])|(Dstmac==rule2[897:850])|(Dstmac==rule2[945:898])) ? 1'b1 :1'b0;
	2'b11: Dstmac2_accept <= ((Dstmac>=rule2[801:754])|(Dstmac<=rule2[849:802])) ? 1'b1 :1'b0;
	endcase
	
	case (Srcmac2_code)
	2'b00: Srcmac2_accept <= 1'b1;
	2'b01: Srcmac2_accept <= (Srcmac==rule2[607:560]) ? 1'b1 :1'b0;
	2'b10: Srcmac2_accept <= ((Srcmac==rule2[607:560])|(Srcmac==rule2[655:608])|(Srcmac==rule2[703:656])|(Srcmac==rule2[751:704])) ? 1'b1 :1'b0;
	2'b11: Srcmac2_accept <= ((Srcmac>=rule2[607:560])|(Srcmac<=rule2[655:608])) ? 1'b1 :1'b0;
	endcase
	
	case (Ethproto2_code)
	2'b00: Ethproto2_accept <= 1'b1;
	2'b01: Ethproto2_accept <= (Ethproto==rule2[509:494]) ? 1'b1 :1'b0;
	2'b10: Ethproto2_accept <= ((Ethproto==rule2[509:494])|(Ethproto==rule2[525:510])|(Ethproto==rule2[541:526])|(Ethproto==rule2[557:542])) ? 1'b1 :1'b0;
	2'b11: Ethproto2_accept <= ((Ethproto>=rule2[509:494])|(Ethproto<=rule2[525:510])) ? 1'b1 :1'b0;
	endcase
	
	case (Ipproto2_code)
	2'b00: Ipproto2_accept <= 1'b1;
	2'b01: Ipproto2_accept <= (Ipproto==rule2[467:460]) ? 1'b1 :1'b0;
	2'b10: Ipproto2_accept <= ((Ipproto==rule2[467:460])|(Ipproto==rule2[475:468])|(Ipproto==rule2[483:476])|(Ipproto==rule2[491:484])) ? 1'b1 :1'b0;
	2'b11: Ipproto2_accept <= ((Ipproto>=rule2[467:460])|(Ipproto<=rule2[475:468])) ? 1'b1 :1'b0;
	endcase
	
	case (srcip42_code)
	2'b00: srcip42_accept <= 1'b1;
	2'b01: srcip42_accept <= (srcip4==rule2[361:330]) ? 1'b1 :1'b0;
	2'b10: srcip42_accept <= ((srcip4==rule2[361:330])|(srcip4==rule2[393:362])|(srcip4==rule2[425:394])|(srcip4==rule2[457:426])) ? 1'b1 :1'b0;
	2'b11: srcip42_accept <= ((srcip4>=rule2[361:330])|(srcip4<=rule2[393:362])) ? 1'b1 :1'b0;
	endcase
	
	case (dstip42_code)
	2'b00: dstip42_accept <= 1'b1;
	2'b01: dstip42_accept <= (dstip4==rule2[231:200]) ? 1'b1 :1'b0;
	2'b10: dstip42_accept <= ((dstip4==rule2[231:200])|(dstip4==rule2[263:232])|(dstip4==rule2[295:264])|(dstip4==rule2[327:296])) ? 1'b1 :1'b0;
	2'b11: dstip42_accept <= ((dstip4>=rule2[231:200])|(dstip4<=rule2[263:232])) ? 1'b1 :1'b0;
	endcase
	
	if (isFragment2_rule == 2'b00) begin //"11" - impossible
		isFragment2_accept <= 1'b1; 
		end
	else isFragment2_accept <= (rule2[198] == isFragment) ? 1'b1 : 1'b0; //[198] - 2 bit isFragment1_rule
	
	case (Srcport2_code)
	2'b00: Srcport2_accept <= 1'b1;
	2'b01: Srcport2_accept <= (Srcport==rule1[147:132]) ? 1'b1 :1'b0;
	2'b10: Srcport2_accept <= ((Srcport==rule1[147:132])|(Srcport==rule1[163:148])|(Srcport==rule1[179:164])|(Srcport==rule1[195:180])) ? 1'b1 :1'b0;
	2'b11: Srcport2_accept <= ((Srcport>=rule1[147:132])|(Srcport<=rule1[163:148])) ? 1'b1 :1'b0;
	endcase
	
	case (Dstport2_code)
	2'b00: Dstport2_accept <= 1'b1;
	2'b01: Dstport2_accept <= (Dstport==rule1[81:66]) ? 1'b1 :1'b0;
	2'b10: Dstport2_accept <= ((Dstport==rule1[81:66])|(Dstport==rule1[97:82])|(Dstport==rule1[113:98])|(Dstport==rule1[129:114])) ? 1'b1 :1'b0;
	2'b11: Dstport2_accept <= ((Dstport>=rule1[81:66])|(Dstport<=rule1[97:82])) ? 1'b1 :1'b0;
	endcase
	
	case (icmp2_code)
	2'b00: icmp2_accept <= 1'b1;
	2'b01: icmp2_accept <= (Dstport==rule2[15:0]) ? 1'b1 :1'b0;
	2'b10: icmp2_accept <= ((Dstport==rule2[15:0])|(Dstport==rule2[31:16])|(Dstport==rule2[47:32])|(Dstport==rule2[63:48])) ? 1'b1 :1'b0;
	2'b11: icmp2_accept <= ((Dstport>=rule2[15:0])|(Dstport<=rule2[31:16])) ? 1'b1 :1'b0;
	endcase
	//end 2nd rule
end
else ready_accept <= 1'b0;
end

always@(posedge clk)
begin
if (rst) begin
	addr1 <= 8'b0;
	addr2 <= 8'b1;
end
if (ena)
	if (ready_accept) begin
	//inputs TODO
	//if action=1 - if accept - acceptAll
	//if action=0 - if accept - dont acceptAll
		isAccept1 <= !activity1 | ((action1==1'b1) & (Frame1_accept & Dstmac1_accept & Srcmac1_accept & Ethproto1_accept & 
		Ipproto1_accept & srcip41_accept & dstip41_accept & isFragment1_accept & Srcport1_accept & Dstport1_accept & icmp1_accept)) | 
	   ((action1==1'b0) & !(Frame1_accept & Dstmac1_accept & Srcmac1_accept & Ethproto1_accept & 
		Ipproto1_accept & srcip41_accept & dstip41_accept & isFragment1_accept & Srcport1_accept & Dstport1_accept & icmp1_accept));
		
		isAccept2 <= !activity2 | ((action2==1'b1) & (Frame2_accept & Dstmac2_accept & Srcmac2_accept & Ethproto2_accept & 
		Ipproto2_accept & srcip42_accept & dstip42_accept & isFragment2_accept & Srcport2_accept & Dstport2_accept & icmp2_accept))| 
	   ((action2==1'b0) & !(Frame2_accept & Dstmac2_accept & Srcmac2_accept & Ethproto2_accept & 
		Ipproto2_accept & srcip42_accept & dstip42_accept & isFragment2_accept & Srcport2_accept & Dstport2_accept & icmp2_accept));
		
		ready <= 1'b1;
		if (addr1 < 253) begin 
			addr1 <= addr1 + 2'b10;
			addr2 <= addr2 + 2'b10;
			end
		else begin
		addr1 <= addr1;
		addr2 <= addr2;
		end
	end
	else ready <= 1'b0;
else ready <= 1'b0;
end
endmodule