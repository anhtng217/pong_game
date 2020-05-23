`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: VGA top module test fixture										//
//    																			//
//		Created by: Anh Nguyen on 11/07/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////

module vga_top_tf;

	// Inputs
	reg clk;
	reg rst;
	reg select;
	reg [11:0] sw;
	reg [9:0] x_pixel;
	reg [9:0] y_pixel;
	reg on;

	// Outputs
	wire hsync;
	wire vsync;
	wire [11:0] rgb;

	// Instantiate the Unit Under Test (UUT)
	vga_top uut (
		.clk(clk), 
		.rst(rst), 
		.select(select), 
		.hsync(hsync), 
		.vsync(vsync), 
		.sw(sw), 
		.rgb(rgb),
		.vOn(on)
	);
	
	reg pixel_test;
	integer a,b;
	
	//100MHz clock
	always #5 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		select = 0;
		sw = 12'habf;
		x_pixel = 0;
		y_pixel = 0;
		on = 0;
		// Wait 10 ns for global reset to finish
		#10;
        
		rst = 0;
		on = 1;
		
		// Keep videoOn On for 100ns
		#100;
		
		for(a = 0; a < 700; a = a + 1)
			begin 
			x_pixel = a;
			#2;
			for(b = 0; b< 500; b = b + 1)
				begin  
				y_pixel = b;
				#2;
				
				// Top 
				if((x_pixel >=2 && x_pixel <= 638) && (y_pixel >= 3 && y_pixel <= 5) && (on) && (rgb ==0)) 
					$display("Top border failed to display. Please check again");
		
				// Bottom 
				else if((x_pixel >=2 && x_pixel <= 638) && (y_pixel >= 475 && y_pixel <= 477) && (on) && (rgb ==0)) 
					$display("Bottom border failed to display. Please check again");
		
				// Left 
				else if((x_pixel >= 10 && x_pixel <= 16) && (y_pixel >= 231 && y_pixel <= 249) && (on) && (rgb ==0)) 	
					$display("Left paddle failed to display. Please check again");
		                                                                                                                                                                      
				// Right 
				else if((x_pixel >= 624 && x_pixel <= 630) && (y_pixel >= 231 && y_pixel <= 249) && (on) && (rgb ==0)) 
					$display("Right paddle failed to display. Please check again"); 
			
				// Ball
				else if((x_pixel >= 317 && x_pixel <= 323) && (y_pixel >= 237 && y_pixel <= 243) && (on) && (rgb ==0)) 
					$display("Ball failed to display. Please check again"); 
				
				// Background
            else if((on) && (rgb != 12'h0FF)) 
					$display ("Background color failed to display. Please check again");
				
				end
			end
			
		// Turn on reset and set video on to 0
		rst = 1;
		on = 0;
		
		// Wait 100ns
		#100;
		
		// Make sure rgb is 0
		if(rgb == 12'b0 && on == 0) 
			pixel_test = 1'b1;
		
		// Wait 100ns
		#100;
		
		// Display result
		if(pixel_test) 
			$display("Design successfully tested, RGB signals output when on is active, reset if off, and desired pixels are on");
		end
      
endmodule

