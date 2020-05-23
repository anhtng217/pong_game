`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: AISO.v															//
//    																			//
//		Created by: Anh Nguyen on 10/17/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////

module AISO(clk, rst, reset);
	input wire 			clk, rst;
	output wire 		reset;
	reg 					q1,q2;
	
	always @(posedge clk, posedge rst)
		if (rst)
			q1 <= 1'b0;
		else
			{q1,q2} <= {1'b1,q1};
				
	assign reset = ~q2;

endmodule

