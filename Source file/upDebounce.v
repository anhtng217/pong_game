`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 	File name: upbutton debouncer												//
//    																			//
//		Created by: Anh Nguyen on 10/17/19										//
//		Copyright @2019 Anh Nguyen. All rights reserved.						//
//																				//
//////////////////////////////////////////////////////////////////////////////////
module upDebounce(clk,rst,pulse,button,yes);
	input clk,rst,pulse,button;
	output reg yes;
	reg [2:0] state, nState;
	reg nYes;
	
	always@(posedge clk, posedge rst)
		if(rst) 
			{state,yes} <= 4'b0;
		else
			{state,yes} <= {nState, nYes};
			
	always@(*)
		case({state,pulse,button})
			5'b000_00: {nState, nYes} = 4'b000_0;
			5'b000_01: {nState, nYes} = 4'b001_0;
			5'b000_10: {nState, nYes} = 4'b000_0;
			5'b000_11: {nState, nYes} = 4'b001_0;
			5'b001_00: {nState, nYes} = 4'b000_0;
			5'b001_01: {nState, nYes} = 4'b001_0;
			5'b001_10: {nState, nYes} = 4'b000_0;
			5'b001_11: {nState, nYes} = 4'b010_0;
			5'b010_00: {nState, nYes} = 4'b000_0;
			5'b010_01: {nState, nYes} = 4'b010_0;
			5'b010_10: {nState, nYes} = 4'b000_0;
			5'b010_11: {nState, nYes} = 4'b011_0;
			5'b011_00: {nState, nYes} = 4'b000_0;
			5'b011_01: {nState, nYes} = 4'b011_0;
			5'b011_10: {nState, nYes} = 4'b000_0;
			5'b011_11: {nState, nYes} = 4'b100_1;
			5'b100_00: {nState, nYes} = 4'b101_1;
			5'b100_01: {nState, nYes} = 4'b100_1;
			5'b100_10: {nState, nYes} = 4'b101_1;
			5'b100_11: {nState, nYes} = 4'b100_1;
			5'b101_00: {nState, nYes} = 4'b101_1;
			5'b101_01: {nState, nYes} = 4'b100_1;
			5'b101_10: {nState, nYes} = 4'b110_1;
			5'b101_11: {nState, nYes} = 4'b100_1;
			5'b110_00: {nState, nYes} = 4'b110_1;
			5'b110_01: {nState, nYes} = 4'b100_1;
			5'b110_10: {nState, nYes} = 4'b111_1;
			5'b110_11: {nState, nYes} = 4'b100_1;
			5'b111_00: {nState, nYes} = 4'b111_1;
			5'b111_01: {nState, nYes} = 4'b100_1;
			5'b111_10: {nState, nYes} = 4'b000_0;
			5'b111_11: {nState, nYes} = 4'b100_1;
			default: {nState, nYes} = 4'b000_0;
		endcase
			
	
	



endmodule

