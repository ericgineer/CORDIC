`timescale 1ps/1ps

/////////////////////////////////////////////////////////
// 
// CORDIC ALGORITHM: VERILOG IMPLEMEMTATION
// 	
// File:   cordic_update.v
// Author: Eric Wilson
// Date:   3-26-15
// 
// This verilog module implements the cordic update algorithm
// 
// Inputs -- clk: clock signal
//		       i: Current iteration
//			   x: real component input (not used in vector mode)
// 			   y: imaginary component input (not used vector mode)
// 			   z: angle input (-pi to pi scaled to signed 16 bits
//			      not used in rotation mode)
//			   mode: 0) selects rotation mode. 1) selects vector mode
//
// Outputs -- x_next: real component output
// 		      y_next: imaginary component output
//			  z_next: angle output
//
// NOTICE: THIS IS EXPERIMENTAL CODE. USE AT YOUR OWN RISK.
// 		   THERE MAY BE ERRORS! VERIFY ALL ALGORITHMS FOR
// 		   CORRECT RESULTS!


module cordic_update (input wire 			clk,
					 input wire signed [4:0]  i,
					 input wire signed [17:0] x,
					 input wire signed [17:0] y,
					 input wire signed [15:0] z,
					 input wire 	          mode,
					 input wire signed [15:0] atan,
					 output reg signed [17:0] x_next,
					 output reg signed [17:0] y_next,
					 output reg signed [15:0] z_next);
					 
		always @(posedge clk)
		begin
			case(mode)
				0: begin	// rotation mode
						x_next <= x - {z < 0 ? -(y >>> i) : (y >>> i)};
						y_next <= y + {z < 0 ? -(x >>> i) : (x >>> i)};
						z_next <= z - {z < 0 ? -atan : atan};
				   end
				1: begin    // vector mode
						x_next <= x - {y < 0 ? (y >>> i) : -(y >>> i)};
						y_next <= y + {y < 0 ? (x >>> i) : -(x >>> i)};
						z_next <= z - {y < 0 ? atan : -atan};
				   end 
			endcase
		end
endmodule