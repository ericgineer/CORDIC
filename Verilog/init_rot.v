`timescale 1ps/1ps

/////////////////////////////////////////////////////////
// 
// CORDIC ALGORITHM: VERILOG IMPLEMEMTATION
// 	
// File:   init_rot.v
// Author: Eric Wilson
// Date:   3-26-15
// 
//
//  This module performs an initial rotation on z if z > pi/2 or z > -pi/2
//
// Inputs -- x: real component input (not used in vector mode)
// 			 y: imaginary component input (not used vector mode)
// 			 z: angle input (-pi to pi scaled to signed 16 bits
//			    not used in rotation mode)
//			 mode: 0) selects rotation mode. 1) selects vector mode
//			 clk: clock input
//
// Outputs -- x_rot: rotated real component output
// 		      y_rot: rotated imaginary component output
//			  z_rot: rotated angle output
//				  d: Signed value used to rotate the last x and y output values
//
// NOTICE: THIS IS EXPERIMENTAL CODE. USE AT YOUR OWN RISK.
// 		   THERE MAY BE ERRORS! VERIFY ALL ALGORITHMS FOR
// 		   CORRECT RESULTS!

module init_rot(input 			  clk,
				input wire signed [15:0] x,
				input wire signed [15:0] y,
				input wire signed [15:0] z,
				input wire 				 mode,
				output reg signed [17:0] x_rot,
				output reg signed [17:0] y_rot,
				output reg signed [15:0] z_rot,
				output reg signed [1:0]  d);
				
		always @(posedge clk)
		begin
			case(mode)
				0:  begin
 						if (z > 16384 && z < 32767)
						begin
							x_rot <= x;
							y_rot <= y;
							z_rot <= z - 16'd32767;
							d 	  <= 2'b11;
						end else if (z < -16384 && z >= -32768)
						begin
							x_rot <= x;
							y_rot <= y;
							z_rot <= z + 16'd32767;
							d 	  <= 2'b11;
						end else
						begin
							x_rot <= x;
							y_rot <= y;
							z_rot <= z;
							d 	  <= 2'b01;
						end
					end
				1:  begin
						if (x < 0)
						begin
							x_rot <= -x;
							y_rot <= -y;
							z_rot <= z - 16'd32767;
						end else
						begin
							x_rot <= x;
							y_rot <= y;
							z_rot <= z;
						end
					end
				endcase
		end
endmodule
			
				