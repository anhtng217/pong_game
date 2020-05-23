`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: toplevelMod.v													//
//    																			//
//		Created by: Anh Nguyen on 10/17/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////
module topLevelMod(clk,rst,sw,hscan,vscan,vgaR, vgaG, vgaB,upButton, downButton, rightUpButton,rightDownButton);
	input 			clk,rst,upButton, downButton, rightUpButton, rightDownButton;
	input [11:0] 	sw;
	wire 				allclk,allrst;
	output wire			hscan, vscan;
	output wire [3:0] 	vgaR, vgaG, vgaB;
	//wire [9:0] pixel_x,pixel_y;
	
	//AISO
	AISO resetall 		(.rst(rst), .clk(clk), .reset(allrst));
	
	//clock divider
	clkdiv divider 	(.clk(clk), .rst(allrst), .clk_25MGHz(allclk));

	//vga_top
	vga_top vga 		(.clk(clk), .rst(allrst), .select(allclk), .sw(sw[11:0]), .hsync(hscan),
							 .vsync(vscan), .rgb({vgaR[3:0],vgaG[3:0],vgaB[3:0]}), .upButton(upButton), .downButton(downButton),.rightUpButton(rightUpButton), .rightDownButton(rightDownButton));
	
endmodule
