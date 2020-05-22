`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: VGA controller															     //
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
module vga_top(clk,rst,select,hsync,vsync,sw,rgb,upButton,downButton,rightUpButton,rightDownButton);
	input 					clk,rst,select,upButton,downButton,rightUpButton,rightDownButton;
	input 	   [11:0] 	sw;
	output reg  [11:0] 	rgb;
	output wire 			hsync,vsync;
	wire [9:0]	x_pixel, y_pixel;
	wire on;
	
	reg 			[11:0] 	rgbr;
	
	allsync hv (.clk(clk), .rst(rst), .select(select), .hcount(x_pixel), .vcount(y_pixel), .h_sync(hsync), .v_sync(vsync), .video_on(on));
	
	always@ (posedge clk, posedge rst)
		if (rst) 
			rgbr <= 12'b0;
		else 
			rgbr <= sw;
			
	// Paddle position register
	reg [9:0] topOfPaddle, nTopOfPaddle, topOfRightPaddle, ntopOfRightPaddle;
	
	// Debounced buttons 
	wire upDetected, downDetected, rightUpDetected, rightDownDetected;
	
	// Update pixels based on this signal
	wire rescan;
	
	// Predefined paddle max and min position
	localparam paddleBottomEdge = 475;
	localparam paddleTopEdge = 9;
	
	// Paddles'length
	localparam paddleHeight = 70;
	
	// Paddles'sides position
	// Left
	localparam paddleLeftSide = 10;
	localparam paddleRightSide = 16;
	// Right
	localparam rightPaddleLeftSide = 624;
	localparam rightPaddleRightSide = 630;
	
	// Top border
	localparam topWallUpperBorder = 3;
	localparam topWallLowerBorder = 9;
	
	// Bottom border
	localparam bottomWallUpperBorder = 472;
	localparam bottomWallLowerBorder = 478;
	
	// Right border
	localparam rightWallLeftBorder = 624;
	localparam rightWallRightBorder = 630;
	
	// Detect ball's border
	wire [9:0] ballLeftBorder;
	wire [9:0] ballRightBorder;
	wire [9:0] ballUpperBorder;
	wire [9:0] ballLowerBorder;
	
	// Ball's dimension
	localparam ballHeight = 6;
	localparam ballWidth  = 6;
	
	// Register to calculate ball's location
	reg  [9:0] ballUpperReg;
	wire [9:0] ballUpperNext;
	reg  [9:0] ballRightReg;
	wire [9:0] ballRightNext;
	
	// Ball goes sideway
	reg [9:0] ballHVeloReg;
	reg [9:0] ballHVeloNext;
	
	// Ball goes up or down
	reg [9:0] ballVVeloReg;
	reg [9:0] ballVVeloNext;
	
	// Predefined speed
	localparam ballSpeedLeft  = -0.5;
	localparam ballSpeedRight =  0.5;
	localparam ballSpeedUp    = -0.5;
	localparam ballSpeedDown  =  0.5;
	
	// Signal That Indicates When The Pixel is On The Ball Pixel Values
	wire ballon; 
	
	// Detecting the upper/lower border of the ball
	assign ballUpperBorder = ballUpperReg;
	assign ballLowerBorder = ballUpperBorder + ballHeight;
	
	// Detecting the side border of the ball
	assign ballRightBorder = ballRightReg;
	assign ballLeftBorder = ballRightReg - ballWidth;
	
	// The pixels match the ball pixels
	assign ballon = (x_pixel >= ballLeftBorder && x_pixel <= ballRightBorder) && (y_pixel <= ballLowerBorder && y_pixel >= ballUpperBorder);
		
	// Rescan scanning start position
	assign rescan = (y_pixel == 481) && (x_pixel == 0);
	
	// Debounce the buttons on the board
	// Left paddle
	upDebounce up (.clk(clk),.rst(rst),.pulse(select),.button(upButton), .yes(upDetected));
	downDebounce down (.clk(clk),.rst(rst),.pulse(select),.button(downButton), .yes(downDetected));
	
	// Right paddle
	upDebounce rightUp (.clk(clk),.rst(rst),.pulse(select),.button(rightUpButton), .yes(rightUpDetected));
	downDebounce rightDown (.clk(clk),.rst(rst),.pulse(select),.button(rightDownButton), .yes(rightDownDetected));

	
	// If reset is off, the left paddle get its next value
	always @(posedge clk , posedge rst)
		if (rst) 
			topOfPaddle <= 10'd249; 
		else 
			topOfPaddle <= nTopOfPaddle; 
			
	// If reset is off, the right paddle get its next value
	always @(posedge clk , posedge rst)
		if (rst) 
			topOfRightPaddle <= 10'd249; 
		else 
			topOfRightPaddle <= ntopOfRightPaddle; 		
		
	// Left paddle movement
	always@(*)
		case({upDetected,downDetected,rescan})
		
			3'b000: nTopOfPaddle = topOfPaddle;			// If rescan is inactive, paddle stays still
			3'b001: nTopOfPaddle = topOfPaddle;			// If rescan is active and no button is pressed, paddle stays still
			3'b010: nTopOfPaddle = topOfPaddle;			// If rescan is inactive and down is pressed, paddle stays still
			3'b100: nTopOfPaddle = topOfPaddle;			// If rescan is inactive and up is pressed, paddle stays still
			3'b110: nTopOfPaddle = topOfPaddle;			// If rescan is inactive and both buttons are pressed, paddle stays still
			3'b111: nTopOfPaddle = topOfPaddle;			// If rescan is active and both buttons are pressed paddle stays still
			
			// If rescan is active and down is pressed, paddle moves down
			3'b011: 
				begin
					nTopOfPaddle = topOfPaddle + 10'd2;
				
					// Paddle cannot go beyond bottom wall
					if(topOfPaddle + paddleHeight >= paddleBottomEdge) 
						nTopOfPaddle = paddleBottomEdge - paddleHeight;
				end
				
			// If rescan is active and up is pressed, paddle moves up
			3'b101: 
				begin
					nTopOfPaddle = topOfPaddle - 10'd2;
				 
					// Paddle cannot go beyond top wall
					if (topOfPaddle <= paddleTopEdge) 
						nTopOfPaddle = paddleTopEdge;
				end
			default: nTopOfPaddle = topOfPaddle;
		endcase 
		
	// Right paddle movement
	always@(*)
		case({rightUpDetected,rightDownDetected,rescan})
			3'b000: ntopOfRightPaddle = topOfRightPaddle;			// If rescan is inactive, paddle stays still
			3'b001: ntopOfRightPaddle = topOfRightPaddle;			// If rescan is active and no buttons are pressed, paddle stays still
			3'b010: ntopOfRightPaddle = topOfRightPaddle; 			// If rescan is inactive and down is pressed, paddle stays still
			3'b100: ntopOfRightPaddle = topOfRightPaddle;			// If rescan is inactive and up is pressed, paddle stays still
			3'b110: ntopOfRightPaddle = topOfRightPaddle;			// If rescan is inactive and both buttons are pressed, paddle stays still
			3'b111: ntopOfRightPaddle = topOfRightPaddle;			// If rescan is active and both buttons are pressed paddle stays still
			
			// If rescan is active and down is pressed, paddle moves down
			3'b011: 
				begin
					ntopOfRightPaddle = topOfRightPaddle + 10'd2;
				
					//Paddle Cannot Go Lower Than Bottom Wall
					if(topOfRightPaddle + paddleHeight >= paddleBottomEdge) 
						ntopOfRightPaddle = paddleBottomEdge - paddleHeight;
				end
			
			// If rescan Active and Up Pressed, Paddle Goes Up
			3'b101: 
				begin
					ntopOfRightPaddle = topOfRightPaddle - 10'd2;
				 
					// Paddle Cannot Go Higher Than Top Wall
					if (topOfRightPaddle <= paddleTopEdge) 
						ntopOfRightPaddle = paddleTopEdge;
				end
			default: ntopOfRightPaddle = topOfRightPaddle;
		endcase 	
		
	// Flop to update registers at every posedge
	always @(posedge clk, posedge rst)
		// If reset is on or the paddles does not hit the ball, reset the position and speed
		if((rst) || (ballLeftBorder < paddleLeftSide))
			begin
				ballRightReg <= 317;
				ballUpperReg <= 237;
				ballHVeloReg <= 1;
				ballVVeloReg <= -1;
			end
			
		// Continue the game otherwise
		else
			begin 
				ballRightReg <= ballRightNext;
				ballUpperReg <= ballUpperNext;
				ballHVeloReg <= ballHVeloNext;
				ballVVeloReg <= ballVVeloNext;
			end
		
	// Next horizontal position = previous position + velocity
	assign ballRightNext = (rescan) ? ballRightReg + ballHVeloReg : ballRightReg;
	
	// Next vertical position = previous position + velocity
	assign ballUpperNext = (rescan) ? ballUpperReg + ballVVeloReg : ballUpperReg; 
		
	// Direction detection
	always@(*)
		begin
			ballHVeloNext = ballHVeloReg;
			ballVVeloNext = ballVVeloReg;
			
			// Ball goes down when hitting top wall
			if(ballUpperBorder <= topWallLowerBorder)
				ballVVeloNext = ballSpeedDown;
				
			// Ball goes up when hitting bottom wall
			else if(ballLowerBorder >= bottomWallUpperBorder)
				ballVVeloNext = ballSpeedUp;
				
			// Ball goes left when hitting right paddle
			else if(((ballLeftBorder) >= rightPaddleLeftSide) && (ballLeftBorder <= rightPaddleRightSide)	&& ((ballUpperBorder)>= topOfRightPaddle) && ((ballUpperBorder <= topOfRightPaddle + paddleHeight)))
				begin
					ballHVeloNext = ballSpeedLeft;
				end
				
			// Ball goes right when hitting left paddle
			else if(((ballLeftBorder) <= paddleRightSide) && (ballLeftBorder >= paddleLeftSide)	&& ((ballUpperBorder)>= topOfPaddle) && ((ballUpperBorder <= topOfPaddle + paddleHeight)))
				begin
					ballHVeloNext = ballSpeedRight;
				end
		end

	always@ (*)
		//top
		if ((x_pixel >= 2 && x_pixel <= rightWallRightBorder) && (y_pixel >= topWallUpperBorder && y_pixel <= topWallLowerBorder))  
			rgb = rgbr;
		//bottom
		else if ((x_pixel >= 2 && x_pixel <= rightWallRightBorder) && (y_pixel >= bottomWallUpperBorder && y_pixel <= bottomWallLowerBorder)) 
			rgb = rgbr;
		//left
		else if ((x_pixel >= paddleLeftSide && x_pixel <= paddleRightSide) && (y_pixel >= topOfPaddle) && (y_pixel <= topOfPaddle + paddleHeight))
			rgb = rgbr;
		//right
		else if ((x_pixel >= rightPaddleLeftSide && x_pixel <= rightPaddleRightSide) && (y_pixel >= topOfRightPaddle) && (y_pixel <= topOfRightPaddle + paddleHeight))
			rgb = rgbr;
		//ball
		else if ((ballon) && (on))
			rgb = rgbr;
		else if(on) 
			rgb = 12'h0FF;
		else
			rgb = 12'h000;
endmodule
