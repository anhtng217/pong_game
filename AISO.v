`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: Asynchronous In/ Synchronous Out Reset 							     //
//    																			                 //
//		Created by: Anh Nguyen on 10/17/19										           //
//		Copyright @2019 Anh Nguyen. All rights reserved.						        //
//																										  //
//  	In submitting this file for class work at CSULB  	 							  //
//  	I am confirming that this is my work and the work  							  //
//		of no one else. In submitting this code I acknowledge 					     //
//		that plagiarism in student project work is subject to 						  //
//		dismissal from the class.																  //
//																										  //
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

