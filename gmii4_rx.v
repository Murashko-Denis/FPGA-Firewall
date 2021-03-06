module gmii4_rx(
      input        reset,
		input        clk,
    	input  [3:0]  gmii_rxd,
      input         gmii_rx_dv,
      input         gmii_rx_err,
      //input         clk_en,
		
	
		// output module
		output reg BeginPacket,
		output reg oEndPacket,
		output reg [3:0] oPacketData,
		output reg dataPacketReady,
		output reg preamble
);

	 
	 
//******************************************************************************
//internal signals
//******************************************************************************
parameter State_idle=4'h00;//Состояние простоя. Ожидание принимаемых данных.
parameter State_preamble=4'h01;//Синхронизация по преамбуле.
parameter State_SFD=4'h02;//Принят октет — разделитель данных.
parameter State_data=4'h03;//Состояние приема данных пакета.
parameter State_checkCRC=4'h04;// Проверка контрольной суммы.
parameter State_OkEnd=4'h05;//Прием завершен.
parameter State_drop=4'h06;//Прекрашение анализа текущего кадра.
parameter State_ErrEnd=4'h07;//Ошибка при приеме данных.
parameter State_CRCErrEnd=4'd8;//Ошибка контрольной суммы.
parameter State_IFG=4'd9;//Межкадровый интервал


reg [3:0] state;
reg [3:0] rxd;                          
reg oBeginPacket;
reg rDataValid;


//delay 1 clk
always @(posedge clk)
begin
BeginPacket<=oBeginPacket;
rxd<=gmii_rxd;
end

always @(posedge clk or negedge reset)  
begin		
if (!reset) begin
		state<=State_idle;
		oEndPacket<=1'b0;
		oEndPacket<=1'b0;	
		preamble<=1'b0;
		end
else begin		
        case (state) 
		  State_idle:
			begin
				if ((gmii_rx_dv)&&(rxd == 4'h5)) begin
					 oPacketData<=4'h0;
					 preamble<=1'b1;
				    state <= State_preamble;  
					 end
			   else begin
					 preamble<=1'b0;
					 oPacketData<=4'h0;
				    state <= State_idle; 
					 end
					 end
        State_preamble: 
		  begin
						  preamble<=1'b1;
						  oPacketData<=4'h0;
                    if (!gmii_rx_dv)                        
                        state <= State_ErrEnd;      
                    else if (gmii_rx_err)                     
                        state <= State_drop;        
                    else if (rxd == 4'hd) begin
								oBeginPacket <= 1'b1;						  
                        state <= State_data; //State_SFD;     
									end
                    else if (rxd == 4'h5)    
                        state <= State_preamble;     
                    else                                
                        state <= State_drop; 
							end	
        /*State_SFD:                                  
                    if (!gmii_rx_dv)                        
                        state  <= State_ErrEnd;      
                    else if (gmii_rx_err)                     
                        state  <= State_drop;        
                    else //if (rxd== 4'h5) state = State_SFD  else                         
                        begin
								oBeginPacket <= 1'b1;
								state  <= State_data; 	
								end*/
        State_data:  
                   if (!gmii_rx_dv) begin
								preamble<=1'b0;
								oEndPacket<=1'b1;
								oPacketData<=4'h0;
                        state  <= State_ErrEnd;
								dataPacketReady<=1'b0;
								end
                    else if (gmii_rx_err) begin  
								preamble<=1'b0;
								oEndPacket<=1'b1;
								oPacketData<=4'h0;								
                        state <= State_drop;
								dataPacketReady<=1'b0;	
								end
                    else begin
								preamble<=1'b0;
								oBeginPacket <= 1'b0;
								dataPacketReady <= 1'b1;
								oPacketData <= rxd;								
                        state <= State_data; 
								dataPacketReady<=1'b0;
								end				
		  
		  State_drop:     begin                                                 
                        state  = State_IFG;  
								oPacketData<=4'h0;
								dataPacketReady<=1'b0;
								end
		      
        State_ErrEnd:   begin                           
                        state  = State_IFG; 
								oPacketData<=4'h0;
								dataPacketReady<=1'b0;
								end
        
        State_IFG:      begin 
								preamble<=1'b0;		  
                        state  <= State_idle;
								oBeginPacket <= 1'b0;
								oEndPacket<=1'b0;
								dataPacketReady<=1'b0;
								end
		  default: begin
					 preamble<=1'b0;
		          state  <= State_idle; 
				    oBeginPacket<= 1'b0;
					 oEndPacket<=1'b0;
					 oPacketData<=4'h0;
					 dataPacketReady<=1'b0;
			end		 
		  endcase
		  end
end
endmodule
