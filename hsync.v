`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: Horizontal Scan and Vertical Scan								//
//                                                                              //
//		Created by: Anh Nguyen on 10/17/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////

module allsync(clk,rst,select,hcount,vcount,h_sync,v_sync,video_on);
	input 			clk,rst,select;
	output reg 		h_sync,v_sync;
	output reg [9:0] hcount,vcount;
	reg 				hSyncReg,vSyncReg;
	reg [9:0] 		hncount,vncount;
	output wire 	video_on;
	wire 				h_count,v_count,h_vid,v_vid;
	
	//Horizontal scan
	//count from 0 to 799
	assign h_count =(hcount == 10'd799);
	
	always@ (posedge clk, posedge rst)
		if (rst)
			hcount <= 10'b0;
		else 
			hcount <= hncount;
	
	//mux 4:1
	always@ (*)
		case({select,h_count})
			2'b00: hncount = hcount;
			2'b01: hncount = hcount;
			2'b10: hncount = hcount + 10'b1;
			2'b11: hncount = 10'b0;
		endcase
	
	//horizontal sync signal is low active from 656-751
	always@ (posedge clk)
		h_sync = ~((hcount >= 10'd656) && (hcount <= 10'd751));
	
	//horizontal video signal is high active from 0-639
	assign h_vid = (hcount < 10'd640);	

	//Vertical Scan
	//count from 0 to 524
	assign v_count =(vcount == 10'd524);
	
	always@ (posedge clk, posedge rst)
		if (rst)
			vcount <= 10'b0;
		else 
			vcount <= vncount;
	
	//mux 4:1
	always@ (*)
		case({{select && h_count},v_count})
			2'b00: vncount = vcount;
			2'b01: vncount = vcount;
			2'b10: vncount = vcount + 10'b1;
			2'b11: vncount = 10'b0;
		endcase

	//vertical sync signal is low active from 490 to 491
	always@ (posedge clk)
		v_sync = ~((vcount == 10'd490) || (vcount == 10'd491));
	
	//vertical video on signal is high active from 0-479
	assign v_vid = (vcount < 10'd480);
	
	//Video ON/OFF
	//video on signal is high active when both horizontal and vertical video signal are active
	assign video_on = (h_vid && v_vid);
			
endmodule
