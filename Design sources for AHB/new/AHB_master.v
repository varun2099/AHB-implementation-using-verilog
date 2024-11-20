`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2024 07:29:31 PM
// Design Name: 
// Module Name: AHB_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AHB_master(
input Hclk,
input Hresetn,
input enable,
input [31:0] data_in_1,data_in_2,
input [31:0] addr,
input WR,
input Hready_out,
input Hresp,
input Hrdata,
input [1:0] slave_sel,

output reg [1:0] sel,
output reg [31:0] Haddr,
output reg Hwrite,Hready,
output reg [3:0] Hsize,
output reg [2:0] Hburst,
output reg [3:0] Hprot,
output reg [1:0] Htrans,
output reg [32:0] Hwdata,
output reg [31:0] d_out );

reg [1:0] present_state,next_state;
parameter idle = 2'b00;//Device boots up 
parameter s1 = 2'b01;//Read Operation
parameter s2 = 2'b10;//Write operation
parameter s3 = 2'b11;//Changes are made wether write or read operation 

//defining present_state
 always@(posedge (Hclk))
  begin 
   if(!Hresetn)
    begin
    present_state <= idle;
    end
   else 
    begin 
     present_state <= next_state;
    end
   end  
   
   //defining next_state
   
   always@(*)
    begin 
       case(present_state)
        idle : begin
              sel <= 2'b00;
              Haddr <= 32'h0000_0000;
              Hwrite <= 1'b0;
              Hready <= 1'b0;
              Hsize <= 3'b00;
              Hburst <= 3'b000;             
              Hprot <= 4'b0000;
              Htrans <= 2'b00;
              Hwdata <= 32'h0000_0000;
              d_out <= 32'h0000_0000;
              
              if (enable ==1'b1)
               begin 
                next_state = s1;
               end
             else 
               begin
                  next_state <= idle;
               end
               end
               
             s1: begin 
             sel <= slave_sel;
             Haddr <= addr;
             Hwrite <= WR;
             Hready <= 1'b1;
             Hsize <= 3'b00;
             Hburst <= 3'b000;                         
             Hwdata <= data_in_1 + data_in_2;
             d_out <= d_out;
             if (WR == 1'b1)
                begin 
                     next_state = s2;
                end
              else 
                begin 
                     next_state = s3;
                end
                 end
             
             s2 : begin 
             sel <= slave_sel;
             Haddr <= addr;
             Hwrite <= WR;
             Hready <= 1'b1; 
             Hburst <= 3'b000;                         
             Hwdata <= data_in_1 + data_in_2;
             d_out <= d_out;
                   if(enable ==1'b1)
                      begin 
                           next_state <= s1;
                      end 
                   else 
                      begin 
                           next_state <= idle;
                      end
                      
                  end
                  
                      
             s3: begin 
             sel <= slave_sel;
             Haddr <= addr;
             Hwrite <= WR;
             Hready <= 1'b1;
             Hburst <= 3'b000;                         
             Hwdata <= Hwdata;
             d_out <= d_out;
                          if (enable==1'b1)
                              begin
                                   next_state = s1;
                              end
                            else
                               begin
                                    next_state = idle;
                               end
                  end
                  
                 default: begin 
                  sel <= slave_sel;
                  Haddr <= Haddr;
                  Hwrite <= Hwrite;
                  Hready <= 1'b0;
                  Hburst <= Hburst;                         
                  Hwdata <= Hwdata;
                  d_out <= d_out;
                  
                  next_state = idle;
                  
                           end 
                           
       endcase
       
       end                    
                           
                           
                    
                     
             
             
              
                
             
    
   

endmodule
