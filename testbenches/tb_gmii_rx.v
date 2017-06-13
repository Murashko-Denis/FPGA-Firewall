`timescale 1 ps/ 1 ps
module tb_gmii_rx();
parameter N=200;//size packet
reg clk;
reg gmii_rx_dv;
reg gmii_rx_err;
reg [7:0] gmii_rxd;
reg reset;
// wires                                               
wire BeginPacket;
wire dataPacketReady;
wire oEndPacket;
wire [7:0]  oPacketData;

// assign statements (if any)                          
gmii_rx i1 (
// port map - connection between master ports and signals/registers   
	.BeginPacket(BeginPacket),
	.clk(clk),
	.dataPacketReady(dataPacketReady),
	.gmii_rx_dv(gmii_rx_dv),
	.gmii_rx_err(gmii_rx_err),
	.gmii_rxd(gmii_rxd),
	.oEndPacket(oEndPacket),
	.oPacketData(oPacketData),
	.reset(reset)
);
reg [7:0] array[0:N];
reg [7:0] array_4 [0:N];
integer data_f, data_f4;
integer i,cnt,cnt4;

initial begin
clk=1'b0;
cnt=1;
cnt4=0;
forever #5 clk=!clk;
end

initial begin  
data_f = $fopen("packet.txt", "r");
$readmemh ("packet.txt", array);

for (i=0; i<N; i=i+1) begin
	$display("array_f=%0h",array[i]);
end    
end

always @(posedge clk)
begin
cnt <= cnt + 1;
if (cnt<122) begin
	gmii_rxd <= array[cnt];
end
else begin
	cnt <= cnt + 1;
	gmii_rxd <= array[cnt];
	$display("d=%0h",gmii_rxd);
end
end

initial begin 
$display("Running testbench");               
gmii_rx_dv <= 1'b0;
gmii_rx_err <= 1'b0;  
gmii_rxd <= array[0];
                                         
#5; gmii_rx_dv = 1'b1;
#1290; gmii_rx_dv = 1'b0;
#20; gmii_rx_err = 1'b1;      
                                                         
#50;
$fclose(data_f);    
$display("Simulation ended succesfully");
$stop;           
end                                                                                                      
endmodule
