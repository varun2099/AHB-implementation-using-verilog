`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2024 11:52:40 PM
// Design Name: 
// Module Name: AHB_module
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


module AHB_module(
input Hclk,
input Hresetn,
input enable,
input [31:0] data_in_1,data_in_2,
input [31:0] addr,
input Wr,
input [1:0] slave_sel,

output [31:0] d_out

    );
wire [1:0] sel;
wire [31:0] Haddr;
wire Hwrite;
wire [3:0] Hprot;
wire [2:0] Hsize;
wire [2:0] Hburst;
wire [1:0] Htrans;



//first slave
wire [31:0] Hrdata_1;
wire Hready_out_1;
wire Hresp_1;

//second slave
wire [31:0] Hrdata_2;
wire Hready_out_2;
wire Hresp_2;

//third slave
wire [31:0] Hrdata_3;
wire Hready_out_3;
wire Hresp_3;

//fourth slave
wire [31:0] Hrdata_4;
wire Hready_out_4;
wire Hresp_4;

//decoder 
wire Hsel_1,Hsel_2,Hsel_3,Hsel_4;

//Mux
wire [31:0] Hrdata;
wire Hready_out;
wire Hresp;


wire Hready;
wire [31:0] Hwdata;

//instantiation of Master module
AHB_master Master(.Hclk(Hclk),.Hresetn(Hresetn),.enable(enable),
.data_in_1(data_in_1),.data_in_2(data_in_2),.addr(addr),.Hready_out(Hready_out)
,.Hresp(Hresp),.Hrdata(Hrdata),.slave_sel(slave_sel),.sel(sel),.Haddr(Haddr),
.Hsize(Hsize),.Hwrite(Hwrite),.Hburst(Hburst),.Hprot(Hprot),.Htrans(Htrans),
.Hready(Hready),.Hwdata(Hwdata),.d_out(d_out));

//Decoder
Decoder decoder(.sel(sel),.Hsel_1(Hsel_1),.Hsel_2(Hsel_2),.Hsel_3(Hsel_3),.Hsel_4(Hsel_4));

//instantion of slaves
//slave 1
AHB_slave slave_1(.Hclk(Hclk),.Hresetn(Hresetn),.Hsel(Hsel_1),.Haddr(Haddr),.Hwrite(Hwrite),
                   .Hsize(Hsize),.Hburst(Hburst),.Hprot(Hprot),.Htrans(Htrans),
                   .Hready(Hready),.Hwdata(Hwdata),.Hready_out(Hready_out_1),.Hresp(Hresp_1),
                   .Hrdata(Hrdata_1));

//slave 2
AHB_slave slave_2(.Hclk(Hclk),.Hresetn(Hresetn),.Hsel(Hsel_2),.Haddr(Haddr),.Hwrite(Hwrite),
                   .Hsize(Hsize),.Hburst(Hburst),.Hprot(Hprot),.Htrans(Htrans),
                   .Hready(Hready),.Hwdata(Hwdata),.Hready_out(Hready_out_2),.Hresp(Hresp_2),
                   .Hrdata(Hrdata_2));
                   
//slave 3
 AHB_slave slave_3(.Hclk(Hclk),.Hresetn(Hresetn),.Hsel(Hsel_3),.Haddr(Haddr),.Hwrite(Hwrite),
                   .Hsize(Hsize),.Hburst(Hburst),.Hprot(Hprot),.Htrans(Htrans),
                    .Hready(Hready),.Hwdata(Hwdata),.Hready_out(Hready_out_3),.Hresp(Hresp_3),
                    .Hrdata(Hrdata_3));

//slave 4
AHB_slave slave_4(.Hclk(Hclk),.Hresetn(Hresetn),.Hsel(Hsel_4),.Haddr(Haddr),.Hwrite(Hwrite),
                   .Hsize(Hsize),.Hburst(Hburst),.Hprot(Hprot),.Htrans(Htrans),
                   .Hready(Hready),.Hwdata(Hwdata),.Hready_out(Hready_out_4),.Hresp(Hresp_4),
                   .Hrdata(Hrdata_4));
                   
//Multiplexer
Multiplexer mux(.Hrdata_1(Hrdata_1),.Hrdata_2(Hrdata_2),.Hrdata_3(Hrdata_3),.Hrdata_4(Hrdata_4),
                .Hready_out_1(Hready_out_1),.Hready_out_2(Hready_out_2),.Hready_out_3(Hready_out_3),
                .Hready_out_4(Hready_out_4),.Hresp_1(Hresp_1),.Hresp_2(Hresp_2),.Hresp_3(Hresp_3),
                .Hresp_4(Hresp_4),.sel(sel),.Hrdata(Hrdata),.Hready_out(Hready_out),.Hresp(Hresp));

endmodule
