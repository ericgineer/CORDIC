/////////////////////////////////////////////////////////
// 
// CORDIC ALGORITHM: VERILOG IMPLEMEMTATION
// 	
// File:   cordic_tb.v
// Author: Eric Wilson
// Date:   3-26-15
// 
// 					Description
//  ---------------------------------------------------
//
//  This verilog code consists of the following files:
// 	
//	cordic.v
//  cordic_tb.v
//  cordic_update.v
//  init_rot.v
//
//  This is the testbench file. It loads two waveforms from txt
//  files and sends them to the CORDIC algorithm. This verilog
//  code implements both the rotation and vector modes of the
//  cordic algorithm. The mode is set by changing the mode
//  parameter in the testbench code. See the other files for
//  a description of the verilog modules.
//
// NOTICE: THIS IS EXPERIMENTAL CODE. USE AT YOUR OWN RISK.
// 		   THERE MAY BE ERRORS! VERIFY ALL ALGORITHMS FOR
// 		   CORRECT RESULTS!


`timescale 1ps/1ps

module cordic_tb;
	
	// cordic inputs
	reg 			  clk;
	reg signed [15:0] x;
	reg signed [15:0] y;
	reg signed [15:0] z;
	reg 		      mode;
	
	// cordic outputs
	wire signed [15:0] x_out;
	wire signed [15:0] y_out;
	wire signed [15:0] z_out;
	
	// file operators
	integer I_in, Q_in, I_read, Q_read;
	integer I_out, Q_out, Z_out;
	
	cordic cordic(.clk(clk),
				  .x_in(x),
				  .y_in(y),
				  .z_in(z),
				  .mode(mode),
				  .x_out(x_out),
				  .y_out(y_out),
				  .z_out(z_out));
					  
	initial
	begin
		clk = 0;
		x = 16'd0;
		y = 16'd0;
		z = -16'd0;
		mode = 1;		// Sets the cordic operation mode. 0) selects rotation mode. 1) selects vector mode
		I_in = $fopen("cos.txt", "r");			// Input file for the cordic algorithm X input
		Q_in = $fopen("sin.txt", "r");			// Input file for the cordic algorithm Y input
		I_out = $fopen("cos_out.txt", "w");		// Output file for debugging
		Q_out = $fopen("sin_out.txt", "w");		// Output file for debugging
		Z_out = $fopen("angle_out.txt", "w");   // Output file for debugging
	end
	
	always #10 clk = ~clk;
	
	always @(x_out, y_out, z_out)
	begin
		$fwrite(I_out, "%d\n", x_out);
		$fwrite(Q_out, "%d\n", y_out);
		$fwrite(Z_out, "%d\n", z_out);
	end
	
	initial
	begin
		while (!$feof(I_in))
		begin
			@(posedge clk)
			I_read <= $fscanf(I_in, "%d\n", x);
			Q_read <= $fscanf(Q_in, "%d\n", y);
			z <= z + 16'd100;
		end
		$fclose(I_in);
		$fclose(Q_in);
		$fclose(I_out);
		$fclose(Q_out);
		$fclose(Z_out);
		repeat(1) @(posedge clk)
		z <= 16'd0;
		
		repeat(20) @(posedge clk);
		$finish;
	end
endmodule
		