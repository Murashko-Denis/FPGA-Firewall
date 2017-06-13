`timescale 1 ps/ 1 ps
module tb_DL();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [47:0] Dstmac;
reg [15:0] Dstport;
reg [15:0] Ethproto;
reg [1:0] Frame;
reg [7:0] Ipproto;
reg [47:0] Srcmac;
reg [15:0] Srcport;
reg clk;
reg [31:0] dstip4;
reg ena;
reg [15:0] icmp;
reg isFragment;
reg [970:0] rule1;
reg [970:0] rule2;
reg [31:0] srcip4;
// wires                                               
wire [7:0]  addr1;
wire [7:0]  addr2;
wire isAccept1;
wire isAccept2;
wire ready;
wire start;

// assign statements (if any)                          
DL i1 (
// port map - connection between master ports and signals/registers   
	.Dstmac(Dstmac),
	.Dstport(Dstport),
	.Ethproto(Ethproto),
	.Frame(Frame),
	.Ipproto(Ipproto),
	.Srcmac(Srcmac),
	.Srcport(Srcport),
	.addr1(addr1),
	.addr2(addr2),
	.clk(clk),
	.dstip4(dstip4),
	.ena(ena),
	.icmp(icmp),
	.isAccept1(isAccept1),
	.isAccept2(isAccept2),
	.isFragment(isFragment),
	.ready(ready),
	.rule1(rule1),
	.rule2(rule2),
	.srcip4(srcip4),
	.start(start)
);

integer data_f, data_f4,file;
integer i,cnt,cnt4;

//fields packet from PPar

initial begin
clk=1'b0;
ena=1'b0;
forever #5 clk=!clk;
end

initial begin  
rule1[970:3]=968'h00c0008000000000000000000000000000000000003010e0221aff2000000000000000000000000000000000000f1253927ed3c80000000000004004000c2202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
rule1[2:0]=3'b000;
rule2[970:3]=968'h01c0008000000000000000000000000000000000003010e0221aff2000000000000000000000000000000000000f1253927ed3c8000000000000400400002202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
rule2[2:0]=3'b000;

Frame=2'h00;
Dstmac=48'h6021c04435fe;
Srcmac=48'h78929c93f69e;
Ethproto=16'h0800;
Ipproto=8'h06;
srcip4=32'hc0a82b22;
dstip4=32'h4d430a8c;
isFragment=1'b0;
Srcport=16'd49171;
Dstport=16'd443;
icmp=16'h0;
$display("Running testbench");               
#10; ena=1'b1;
#20; ena=1'b0;
                                                         
#30;

  
$display("Simulation ended succesfully");
$stop;   
                                                  
end                                                    
endmodule

