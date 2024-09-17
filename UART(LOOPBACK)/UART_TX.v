module UARTTX #(parameter CLK_PER_BITS=1086,
                parameter IDLE=3'b000,
                parameter START=3'b001,
                parameter DATA=3'b010,
                parameter STOP=3'b011,
                parameter CLEANUP=3'b100)
                (input clk,input[7:0] data_in,output reg data_out,output reg[7:0] count,input dv,output reg active,output reg done,output reg[7:0] bitindex,output reg[2:0] STATE,output reg[7:0] register);
  
 /* parameter IDLE=3'b000;
  parameter START=3'b001;
  parameter DATA=3'b010;
  parameter STOP=3'b011;
  parameter CLEANUP=3'b100; */
  
  always@(posedge clk) begin
    case(STATE)
      
 IDLE: begin
   done<=1'b0;
   data_out<=1'b1;
   bitindex<=0;
   if(dv==1'b1)begin
     count<=0;
     active<=1'b1;
     register<=data_in;
     STATE<=START;
   end else begin
     STATE<=IDLE;
   end
 end
      
 START: begin
   data_out<=1'b0;
   if(count<(CLK_PER_BITS-1))begin
     count<=count+1;
     STATE<=START;
   end else begin
     count<=0;
     STATE<=DATA;
   end
 end
 
 DATA: begin
    data_out<=register[bitindex];
   if(count<(CLK_PER_BITS-1)) begin
     count<=count+1;
     STATE<=DATA;
   end else begin
     count<=0;
     if(bitindex<7) begin
     bitindex<=bitindex+1;
     STATE<=DATA;
     end else begin
     count<=0;
     STATE<=STOP;
   end
 end
 end
      
STOP: begin
  data_out<=1'b1;
  if(count<(CLK_PER_BITS-1)) begin
    count<=count+1;
    STATE<=STOP;
  end else begin
    count<=0;
    active<=1'b0;
    done<=1'b1;
    STATE<=CLEANUP;
  end
end
      
CLEANUP: begin
  bitindex<=0;
  STATE<=IDLE;
end
      
default: STATE<=IDLE;
    endcase
  end
endmodule
    
     
     
     
   
   
                                            