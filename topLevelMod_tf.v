`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// 	File name: topLevelModule test fixture										//
//    																			//
//		Created by: Anh Nguyen on 10/17/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////

module topLevelMod_tf;

	// Inputs
	reg clk;
	reg rst;
	reg [11:0] sw;

	// Outputs
	wire hscan;
	wire vscan;
	wire [3:0] vgaR;
	wire [3:0] vgaG;
	wire [3:0] vgaB;

	// Instantiate the Unit Under Test (UUT)
	topLevelMod uut (
		.clk(clk), 
		.rst(rst), 
		.sw(sw), 
		.hscan(hscan), 
		.vscan(vscan), 
		.vgaR(vgaR), 
		.vgaG(vgaG), 
		.vgaB(vgaB)
	);
	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		sw = 0;

		// Wait 100 ns for global reset to finish
		#10;
      rst = 1;
		#10;
		rst = 0;
		#5
		sw = 12'hFFF;
		// Add stimulus here

	end
      
endmodule

