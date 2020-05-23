`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// 	File name: vertical and horizontal sync test fixture						//
//    																			//
//		Created by: Anh Nguyen on 10/24/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////

module allsync_tf;

	// Inputs
	reg clk;
	reg rst;
	reg select;

	// Outputs
	wire h_sync;
	wire v_sync;
	wire h_count,v_count;
	wire video_on;
	wire [9:0] hcount,vcount;
	wire h_vid,v_vid;

	// Instantiate the Unit Under Test (UUT)
	allsync uut (
		.clk(clk), 
		.rst(rst), 
		.select(select), 
		.h_sync(h_sync), 
		.v_sync(v_sync), 
		.video_on(video_on)
	);
	
	reg [9:0] var1,var2;
	reg testhc1, testhc2, testhc3, testhc4,
		 testvc0, testvc1, testvc2, testvc3, testvc4;
	
	always #5 clk = ~clk;				//100MHz clock
	
	always #40 select = 1;				//25MHz clock

	always @(posedge clk)				//select lasts one cycle
		if(select)
			select = 0;
			
	always@(*)															//h_sync is low active from 656-751
		if(hcount == 656 && h_sync == 0)
			testhc1 = 1'b1;	
		else if(hcount	== 751 && h_sync == 0)
			testhc2 = 1'b1;
	
	always@(*)															////h_vid is low active from 0-639
		if(hcount == 0 && h_vid == 1)
			testhc3 = 1'b1;
		else if(hcount == 640 && h_vid == 0)
			testhc4 = 1'b1;
	
	always@(*)
		if(select && h_count)
			testvc0 = 1'b1;											//v_sync starts counting only when select and h_count
			
	always@(*)															//v_sync is low active at 490 and 491
		if(vcount == 490 && v_sync == 0)
			testvc1 = 1'b1;	
		else if(vcount	== 491 && v_sync == 0)
			testvc2 = 1'b1;
	
	always@(*)															//v_vid is low active from 0-479
		if(vcount == 0 && v_vid == 1)
			testvc3 = 1'b1;
		else if(vcount == 480 && v_vid == 0)
			testvc4 = 1'b1;
		
			

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		select = 0;

		// Wait 100 ns for global reset to finish
		#40;
        
		rst = 0;
		
		//#1
		var1 = hcount;
		var2 = vcount;
		
		#40;
		if((select == 1'b1) && (var1 != hcount)) 
			$display ("Pixels sucessfully updated at 25MHz");
		#31960;
		if((testvc0 == 1'b1) && (var2 != vcount))
			$display ("Pixels sucessfully updated at completion of horizontal scan at 25MHz");
			
		//#2
		if((hcount < 800))
			$display ("hcount does not exceed 799");
		#16736040;
		if((vcount < 525))
			$display ("vcount does not exceed 524");
		
		//#3
		if(testhc1 && testhc2)
			$display ("h_sync is low active and active from 656-751");
		if(testvc1 && testvc2)
			$display ("v_sync is low active and active at 490 and 491");
			
		//#4
		if(testhc3 && testhc4) 
			$display("h_vid is high cctive and is active from 0-639");
		if(testvc3 && testvc4) 
			$display("v_vid is high active and is only active from 0-479");

	end
      
endmodule

