function [ max_x max_y ] = findAllMaxima( x_in, y_in )
%
% Finds all maxima.
%
% max_val and max_idx are vectors!
% 
% Volker Hoffmann <volker@cheleb.net>
% 01-06-2010
% 

% clear all
% 
% x_in = [ 1 2 3 4 5 6 7 8 9 ];
% y_in = [ 1 2 3 2 1 2 3 2 1 ];

% Compute Delta Vector
delta_y = diff( y_in );

% Make Binary
pos = ( delta_y > 0 );

% Shift Binary Copy
% Shift is slow, do it manually! (shifting a row vector, btw)
% pos_shift = circshift( pos, [ 0 1 ] );
pos_shift = [ pos(end) pos(1:end-1) ];

% Subtract
delta = pos - pos_shift;
delta = [ delta 0 ];

% Locate Maxima
maxima = ( delta == -1 );

% Return Maxima
max_x = x_in( maxima );
max_y = y_in( maxima );