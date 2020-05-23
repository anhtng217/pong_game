`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: vertical scan (vsync.v)											//
//    																			//
//		Created by: Anh Nguyen on 10/15/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////

module vsync(clk,rst,vselect,v_sync,h_count,v_vid);
	input 			clk,rst,vselect;
	input wire 		h_count;
	output reg 		v_sync;
	reg 				vsync_reg;
	reg [9:0] 		vcount,vncount;
	wire 				v_count;
	output wire 	v_vid;
	
	assign v_count =(vcount == 10'd524);
	
	always@ (posedge clk, posedge rst)
		begin
			if (rst)
				vcount <= 10'b0;
			else 
				vcount <= vncount;
		end		
	always@ (*)
		begin
			case({(vselect && h_count),v_count})
				2'b00: vncount = vcount;
				2'b01: vncount = vcount;
				2'b10: vncount = vcount + 10'b1;
				2'b11: vncount = 10'b0;
			endcase
		end
	always@ (*)
		begin
				v_sync = ~((vcount >= 10'd490) || (vcount <= 10'd491));
		end
	assign v_vid = (vcount < 10'd480);
		
		
endmodule
