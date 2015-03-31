%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% CORDIC ALGORITHM: MATLAB/OCTAVE IMPLEMENTATION
% 	
% File:   cordic_test.m
% Author: Eric Wilson
% Date:   3-30-15
% 
% 					Description
% ---------------------------------------------------
%
% This script executes the CORDIC function in two modes
% and plots the results. The first mode is rotation where
% the x and y inputs are not used and the angle is rotated
% from -pi to pi. The output is the x coordinate (cosine)
% and y coordinate (sine). The second mode of operation is
% vector mode where the x and y inputs are a vector rotated
% around the unit circle. The x output is the magnitude, y
% output is the y component needed to rotate the vector to the
% x-axis, and the angle output is the angle of the input vector.
%
% NOTICE: THIS IS EXPERIMENTAL CODE. USE AT YOUR OWN RISK.
% 		  THERE MAY BE ERRORS! VALIDATE ALL ALGORITHMS
%		  FOR THE CORRECT RESULTS!

clear all
close all
clc

mode = 0; 				    % mode (0 = rotation, 1 = vector)
n    = 15;				    % number of iterations

theta = 1;					% initial angle


% Run CORDIC algorith in rotation mode

q = 1;
for theta = -pi+0.1:0.1:pi
	[x_out(q), y_out(q), angle(q)] = cordic(0, 0, theta, n, mode);
	q = q + 1;
end

figure
subplot(3,1,1)
plot(x_out)
title('X out')
subplot(3,1,2)
plot(y_out)
title('Y out')
subplot(3,1,3)
plot(angle)
title('angle')

% Run CORDIC algorithm in vector mode

mode = 1;

q = 1;
for w = 0:0.1:2*pi
	x(q) = cos(w);
	y(q) = sin(w);
	[x_out(q), y_out(q), angle(q)] = cordic(x(q), y(q), 0, n, mode);
	q = q + 1;
end

figure
subplot(3,1,1)
plot(x_out)
title('X out')
subplot(3,1,2)
plot(y_out)
title('Y out')
subplot(3,1,3)
plot(angle)
title('angle')


