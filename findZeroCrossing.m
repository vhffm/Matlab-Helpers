function [ x_zero ] = findZeroCrossing( x_in, y_in, max_residual, i )
%
% Finds the zero crossing in an input vector y_in.
%
% Requires:
% - x_in - x values
% - y_in - y values
% - max_residual - maximum desired residual (defaults to 1/100)
% - i - current recursion cycle counter
%
% PROBLEMS:
% - Assumes only one zero-crossing (i.e., monotonically increasing or
% decreasing function).
%
% Volker Hoffmann <volker@cheleb.net>
% 31-05-2010
%

if( nargin < 3 )
    max_residual = 1/100;
end

if( nargin < 4 )
    i = 1;
end

if( i > 20 )
    error('Not Converging. Terminating');
end

% 0 - Get minimum values in y_in in case there's a 0
[ y_min_logical y_min_idx ] = max( y_in == 0 );

if( y_min_logical == 1 )
    x_zero = x_in( y_min_idx );
else
    % 1 - find last/first pos/neg entry
    pos = ( y_in > 0 );
    
    % circshift is slow; replace with some simple vector stuff
    % note that we're wrapping around ROW vector
%     pos_shift = circshift( pos, [ 0 1 ] );
    pos_shift = [ pos(end) pos(1:end-1) ];
    
    % Depending on whether the function is increasing or decreasing, the
    % detection value of delta is different. Make graph to see!
    delta = pos - pos_shift;
    if( pos(1) == 1 )
        cross_hi = ( delta == -1 );
    elseif( pos(1) == 0 )
        cross_hi = ( delta == 1 );
    end
    % replace circshiftt as bove; note we're shifting the other way now
    % i.e., the first element goes to the end!
%     cross_lo = circshift( cross_hi, [ 0 -1 ] );
    cross_lo = [ cross_hi(2:end) cross_hi(1) ];

    % 2 - get x/y values for this
    y_lo = y_in( cross_lo );
    y_hi = y_in( cross_hi );
    x_lo = x_in( cross_lo );
    x_hi = x_in( cross_hi );

    % 3 - interpolate
    x_interp = linspace( x_lo, x_hi, 100 );
    y_interp = interp1( [ x_lo x_hi ], [ y_lo y_hi ], x_interp, 'linear' );

    % 4 - compare residual to requested; iterate if not matched
    if( min( abs( y_interp ) ) < max_residual )
        [ min_val min_idx ] = min( abs( y_interp ) );
        x_zero = x_interp( min_idx );
    else
        x_zero = findZeroCrossing( x_interp, y_interp, max_residual, i+1 );
    end
end