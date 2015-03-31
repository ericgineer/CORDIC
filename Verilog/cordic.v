`timescale 1ps/1ps

/////////////////////////////////////////////////////////
// 
// CORDIC ALGORITHM: VERILOG IMPLEMEMTATION
// 	
// File:   cordic.v
// Author: Eric Wilson
// Date:   3-26-15
// 
// A verilog module that implements the CORDIC algorithm
// in both vector and rotation mode
//
// Inputs -- x: real component input (not used in vector mode)
// 			 y: imaginary component input (not used vector mode)
// 			 z: angle input (-pi to pi scaled to signed 16 bits
//			    not used in rotation mode)
//			 mode: 0) selects rotation mode. 1) selects vector mode
//			 clk: clock input
//
// Outputs -- x_out: real component output
// 		      y_out: imaginary component output
//			  z_out: angle output
//
// NOTICE: THIS IS EXPERIMENTAL CODE. USE AT YOUR OWN RISK.
// 		   THERE MAY BE ERRORS! VERIFY ALL ALGORITHMS FOR
// 		   CORRECT RESULTS!


// angle conversions: pi   = 32767
//					  pi/2 = 16384
//					  0    = 0
//					 -pi/2 = -16384
//					 -pi   = -32768

module cordic(input wire 			   clk,
			  input wire signed [15:0] x_in,
			  input wire signed [15:0] y_in,
			  input wire signed [15:0] z_in,
			  input wire 			   mode,
			  output reg signed [15:0] x_out,
			  output reg signed [15:0] y_out,
			  output reg signed [15:0] z_out);
		
		// Pipeline stage connections
		wire signed [17:0] x_rot, x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;
		wire signed [17:0] y_rot, y0, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15;
		wire signed [15:0] z_rot, z0, z1, z2, z3, z4, z5, z6, z7, z8, z9, z10, z11, z12, z13, z14, z15;
		reg signed  [1:0] d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15;
		
		reg signed [15:0] x, y, z;
		
		wire signed [1:0] d;
		
		wire signed [15:0] atan0, atan1, atan2, atan3, atan4, atan5, atan6, atan7, atan8, atan9, atan10, atan11, atan12, atan13, atan14, atan15;
		
		wire signed [18:0] scale;
		
		wire signed [31:0] x_tmp, y_tmp;
		
		assign scale = 19'd159185;
		
		assign atan0 = 16'd8192;
		assign atan1 = 16'd4836;
		assign atan2 = 16'd2555;
		assign atan3 = 16'd1297;
		assign atan4 = 16'd651;
		assign atan5 = 16'd326;
		assign atan6 = 16'd163;
		assign atan7 = 16'd81;
		assign atan8 = 16'd41;
		assign atan9 = 16'd20;
		assign atan10 = 16'd10;
		assign atan11 = 16'd5;
		assign atan12 = 16'd3;
		assign atan13 = 16'd1;
		assign atan14 = 16'd1;
		assign atan15 = 16'd0;
		
		assign x_tmp = (x15 * d15) >>> 2;
		assign y_tmp = (y15 * d15) >>> 2;
		
		always @(posedge clk)
		begin
			case(mode)
				0: begin
						x <= 16'd32767;
						y <= 16'd0;
						z <= z_in;
						x_out <= (x_tmp * scale) >>> 16;
						y_out <= (y_tmp * scale) >>> 16;
						z_out <= z15;
				   end
				1: begin
						x <= x_in;
						y <= y_in;
						z <= 16'd0;
						x_out <= x15 >>> 2;
						y_out <= y15 >>> 2;
						z_out <= z15;
				   end
			endcase
			
 			d0 <= d;
			d1 <= d0;
			d2 <= d1;
			d3 <= d2;
			d4 <= d3;
			d5 <= d4;
			d6 <= d5;
			d7 <= d6;
			d8 <= d7;
			d9 <= d8;
			d10 <= d9;
			d11 <= d10;
			d12 <= d11;
			d13 <= d12;
			d14 <= d13;
			d15 <= d14;
		end
		
		// Initial rotation
	    init_rot rotation(.clk(clk), .x(x), .y(y), .z(z), .mode(mode), .x_rot(x_rot), .y_rot(y_rot), .z_rot(z_rot), .d(d));
		
		// Stage 0
		cordic_update  cordic0(.clk(clk), .i(5'd0), .x(x_rot), .y(y_rot), .z(z_rot), .mode(mode), .atan(atan0), .x_next(x0), .y_next(y0), .z_next(z0));

		// Stage 1
		cordic_update  cordic1(.clk(clk), .i(5'd1), .x(x0), .y(y0), .z(z0), .mode(mode), .atan(atan1), .x_next(x1), .y_next(y1), .z_next(z1));		
		
		// Stage 2
		cordic_update  cordic2(.clk(clk), .i(5'd2), .x(x1), .y(y1), .z(z1), .mode(mode), .atan(atan2), .x_next(x2), .y_next(y2), .z_next(z2));		
		
		// Stage 3
		cordic_update  cordic3(.clk(clk), .i(5'd3), .x(x2), .y(y2), .z(z2), .mode(mode), .atan(atan3), .x_next(x3), .y_next(y3), .z_next(z3));
		
		// Stage 4
		cordic_update  cordic4(.clk(clk), .i(5'd4), .x(x3), .y(y3), .z(z3), .mode(mode), .atan(atan4), .x_next(x4), .y_next(y4), .z_next(z4));
		
		// Stage 5
		cordic_update  cordic5(.clk(clk), .i(5'd5), .x(x4), .y(y4), .z(z4), .mode(mode), .atan(atan5), .x_next(x5), .y_next(y5), .z_next(z5));
		
		// Stage 6
		cordic_update  cordic6(.clk(clk), .i(5'd6), .x(x5), .y(y5), .z(z5), .mode(mode), .atan(atan6), .x_next(x6), .y_next(y6), .z_next(z6));
		
		// Stage 7
		cordic_update  cordic7(.clk(clk), .i(5'd7), .x(x6), .y(y6), .z(z6), .mode(mode), .atan(atan7), .x_next(x7), .y_next(y7), .z_next(z7));
		
		// Stage 8
		cordic_update  cordic8(.clk(clk), .i(5'd8), .x(x7), .y(y7), .z(z7), .mode(mode), .atan(atan8), .x_next(x8), .y_next(y8), .z_next(z8));
		
		// Stage 9
		cordic_update  cordic9(.clk(clk), .i(5'd9), .x(x8), .y(y8), .z(z8), .mode(mode), .atan(atan9), .x_next(x9), .y_next(y9), .z_next(z9));
		
		// Stage 10
		cordic_update  cordic10(.clk(clk), .i(5'd10), .x(x9), .y(y9), .z(z9), .mode(mode), .atan(atan10), .x_next(x10), .y_next(y10), .z_next(z10));
			
		// Stage 11
		cordic_update  cordic11(.clk(clk), .i(5'd11), .x(x10), .y(y10), .z(z10), .mode(mode), .atan(atan11), .x_next(x11), .y_next(y11), .z_next(z11));
		
		// Stage 12
		cordic_update  cordic12(.clk(clk), .i(5'd12), .x(x11), .y(y11), .z(z11), .mode(mode), .atan(atan12), .x_next(x12), .y_next(y12), .z_next(z12));
		
		// Stage 13
		cordic_update  cordic13(.clk(clk), .i(5'd13), .x(x12), .y(y12), .z(z12), .mode(mode), .atan(atan13), .x_next(x13), .y_next(y13), .z_next(z13));
		
		// Stage 14
		cordic_update  cordic14(.clk(clk), .i(5'd14), .x(x13), .y(y13), .z(z13), .mode(mode), .atan(atan14), .x_next(x14), .y_next(y14), .z_next(z14));
		
		// Stage 15
		cordic_update  cordic15(.clk(clk), .i(5'd15), .x(x14), .y(y14), .z(z14), .mode(mode), .atan(atan15), .x_next(x15), .y_next(y15), .z_next(z15));
endmodule