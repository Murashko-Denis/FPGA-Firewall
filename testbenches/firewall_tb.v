`timescale 1 ns/ 100ps
module tb_firewall;
// test vector input registers
reg clk;
reg [3:0] d;
reg reset;
reg strobe;
// wires                                               
wire [47:0]  Dstmac;
wire [15:0]  Dstport;
wire [15:0]  Ethproto;
wire [1:0]  Frame;
wire [7:0]  Ipproto;
wire [47:0]  Srcmac;
wire [15:0]  Srcport;
wire [31:0]  dstip4;
wire [1:0]  fragment_flag;
wire [12:0]  fragment_shift;
wire [15:0]  icmp_type_code;
wire ready;
wire [31:0]  srcip4;
wire vlan;

// assign statements (if any)                          
firewall i1 (
// port map - connection between master ports and signals/registers   
	.Dstmac(Dstmac),
	.Dstport(Dstport),
	.Ethproto(Ethproto),
	.Frame(Frame),
	.Ipproto(Ipproto),
	.Srcmac(Srcmac),
	.Srcport(Srcport),
	.clk(clk),
	.d(d),
	.dstip4(dstip4),
	.fragment_flag(fragment_flag),
	.fragment_shift(fragment_shift),
	.icmp_type_code(icmp_type_code),
	.ready(ready),
	.reset(reset),
	.srcip4(srcip4),
	.strobe(strobe),
	.vlan(vlan)
);

reg [3:0] array_f [0:108];
integer data_f;
integer i,cnt;

initial begin
clk=1'b0;
cnt=1;
forever #5 clk=!clk;
end

initial begin  
data_f = $fopen("packet2.txt", "r");
if (!data_f) $stop;

$readmemh ("packet2.txt", array_f);

for (i=0; i<108; i=i+1) begin
	$display("array_f=%0h",array_f[i]);
end    
end

always @(posedge clk)
begin
cnt <= cnt + 1;
d <= array_f[cnt];
$display("d=%0h",d);
end


initial begin 
$display("Running testbench");               
reset = 1'b0;  
d <= array_f[0];
strobe = 1'b1;                                         
//#5; strobe = 1'b1; 
#10; strobe = 1'b0;

//#20; strobe = 1;
//#30; strobe = 0;        
                                                         
#1100;
$fclose(data_f);    
$display("Simulation ended succesfully");
$stop;           
end                                                                                                      
endmodule



