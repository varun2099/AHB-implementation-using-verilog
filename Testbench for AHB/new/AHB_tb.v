`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2024 04:29:29 PM
// Design Name: 
// Module Name: AHB_tb
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


module AHB_tb();
reg Hclk;
reg Hresetn;
reg enable;
reg addr;
reg [31:0] data_in_1,data_in_2;
reg Wr;
reg [1:0] slave_sel;
reg [32:0] Hwdata;
wire [32:0] d_out;

initial 
       begin
            Hclk = 0;
            Hresetn = 1;
            enable = 1'b0;
            data_in_1 = 32'd0;
            data_in_2 = 32'd0;
            Wr = 1'b0;
            slave_sel = 1'b0;
       end
       
       always #10 Hclk = ~(Hclk);
       
  task reset_dut();
        begin 
             @(negedge Hclk)
                  Hresetn = 0;
             @(negedge Hclk)
                  Hresetn = 1;
        end
 endtask
 
 task write_dut(input [1:0] sel,input [31:0] address_input,input [31:0] a_1,input [31:0] b_1);
      begin
           @(negedge Hclk)
                slave_sel = sel;
                enable = 1'b1;
                addr = address_input;
                
            @(negedge Hclk)
                 data_in_1 = a_1;
                 data_in_2 = b_1;
                 
                 Wr = 1'b1;
                 
                 
            @(negedge Hclk)
                 enable = 1'b0;
      end
 endtask
 
  task read_dut(input [1:0] sel, input [31:0] address_input);
      begin 
          @(negedge Hclk)
               enable = 1'b1;
               slave_sel = sel;
               addr = address_input;
                 
          @(negedge Hclk)
               Wr = 1'b0;
               
          @(negedge Hclk)
               Wr = 1'b0;
               
          @(negedge Hclk)
               Wr = 1'b0;
               
          @(negedge Hclk)
               enable = 1'b0;
       end
     endtask   
     
     
     initial 
            begin 
                 //selecting slave 1
                 write_dut(2'b00,32'd1,32'd5,32'd10);    
                 read_dut(2'b00,32'd1);
          
                 //selecting slave 2
                 write_dut(2'b01,32'd2,32'd11,32'd13);
                 read_dut (2'b01,32'd2);
                 
                 //selecting slave 3
                 //write_dut(2'b10,32'd3,32'd17,32'd13);
                 //read_dut(2'b10,32'd3);
                 
                 //selecting slave 4
                 //write_dut(2'b11,32'd4,32'd23,32'd13);
                 //read_dut(2'b11,32'd4);
                 
              end  
              
       //instantiating with the AHB_module
      AHB_module dut(.Hclk(Hclk),.Hresetn(Hresetn),.data_in_1(data_in_1),
                     .data_in_2(data_in_2),.addr(addr),.Wr(Wr),.slave_sel(slave_sel),
                     .d_out(d_out));



endmodule
