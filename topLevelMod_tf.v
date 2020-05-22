`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:02:53 10/25/2019
// Design Name:   topLevelMod
// Module Name:   C:/Users/tranf/Desktop/School work/CSULB Fall 2019/CECS 361/Projects/Project 2 - VGA/Project2/topLevelMod_tf.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: topLevelMod
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

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

