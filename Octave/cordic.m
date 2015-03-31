%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% CORDIC ALGORITHM: MATLAB/OCTAVE IMPLEMEMTATION
% 	
% File:   cordic.m
% Author: Eric Wilson
% Date:   3-30-15
% 
% A verilog module that implements the CORDIC algorithm
% in both vector and rotation mode
%
% Inputs -- x: real component input (not used in vector mode)
% 			y: imaginary component input (not used vector mode)
% 		theta: angle input (-pi to pi scaled to signed 16 bits
%			   not used in rotation mode)
%			n: number of iterations
%		 mode: 0) selects rotation mode. 1) selects vector mode
%
% Outputs -- x_out: real component output
% 		     y_out: imaginary component output
%			 angle: angle output
%
% NOTICE: THIS IS EXPERIMENTAL CODE. USE AT YOUR OWN RISK.
% 		  THERE MAY BE ERRORS! VALIDATE ALL ALGORITHMS
%		  FOR THE CORRECT RESULTS!

function [x_out, y_out, angle] = cordic(x, y, theta, n, mode)
	K = 1;
	z = theta;
	rot = 0;   % Indicates if a rotation occured. 0: no rotation 1: rotation by -pi 2: rotation by +pi
	if mode == 0 % Vector mode
		% Initial rotation
		if (z > pi/2) && (z <= pi)
			x = -x;
			y = -y;
			z = z - pi;
			rot = 1;
		end
		if (z < -pi/2) && (z >= -pi)
			x = -x;
			y = -y;
			z = z + pi;
			rot = 1;
		end
		% Set x to 1 and y to 0
		x = 1;
		y = 0;
		for w = 0:n-1
			% Rotation update algorithm
			if z < 0
				d = -1;
			else
				d = 1;
			end
			x_next = x - y * d * 2^-w;
			y_next = y + x * d * 2^-w;
			z = z - d * atan(2^-w);
			
			x = x_next;
			y = y_next;
			K = K * 1/sqrt(1 + 2 ^ (-2 * w));
		end
		if rot == 0
			x_out = K * x;
			y_out = K * y;
			angle = z;
		else
			x_out = -K * x;
			y_out = -K * y;
			angle = z;
		end
	else  % Vector mode
		% Initialize angle to 0
		z = 0;
		if y < 0
			d = 1;
		else
			d = -1;
		end
		x_rot = -d * y;
		y_rot = d * x;
		z = z + d * pi/2;
		x = x_rot;
		y = y_rot;
		for w = 0:n-1
			% Vector update algorithm
			if y < 0
				d = 1;
			else
				d = -1;
			end
			x_next = x - y * d * 2^-w;
			y_next = y + x * d * 2^-w;
			z = z - d * atan(2^-w);
			
			x = x_next;
			y = y_next;
			K = K * 1/sqrt(1 + 2 ^ (-2 * w));
			
		end
		x_out = K * x;
		y_out = K * y;
		angle = z;
	end
end
