`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: pulse generator													//
//    																			//
//		Created by: Anh Nguyen on 10/17/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////
module clkdiv(clk, rst, clk_25MGHz);
	input wire 			clk, rst;
	reg     [1:0]		count,ncount;
	output wire 		clk_25MGHz;
	
	always @(posedge clk, posedge rst)
		if (rst)
			count <= 2'b0;
		else
			count <= count + 2'b1;
	
	assign clk_25MGHz =(count == 2'b11);

endmodule
