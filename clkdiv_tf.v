`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:14:38 10/24/2019
// Design Name:   clkdiv
// Module Name:   C:/Users/tranf/Desktop/School work/CSULB Fall 2019/CECS 361/Projects/Project 2 - VGA/Project2/clkdiv_tf.v
// Project Name:  Project2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clkdiv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clkdiv_tf;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire clk_25MGHz;

	// Instantiate the Unit Under Test (UUT)
	clkdiv uut (
		.clk(clk), 
		.rst(rst), 
		.clk_25MGHz(clk_25MGHz)
	);

	// 100Mhz Clock
	always #5 clk = ~clk; 
	
	int count = 0;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1; 

		// Wait 35 ns for global reset to finish
		#35;
		   
		rst = 0;
		
		// Allow 4 Clock Cycles To Pass, See if Pulse Is On
		repeat(4) @(posedge clk) 
			count = count + 1;
			$display(count);
		if((clk_25MGHz == 1'b1) && (count == 4)) 
			$display("clk_25MHz = 1 after 4 clock cycles");
		

	end
endmodule 

