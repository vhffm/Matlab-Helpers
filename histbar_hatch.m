function [ hF hL ] = histbar_hatch( x_min, x_max, y_min, y_max, ...
  dy, draw_bottom_line, hF )
%
% Draws a single bar with hatched interior.
%
% x_min, x_max - X Bounds of Bar
% y_min, y_max - Y Bounds of Bar
%
% dy - y-Distance between hatch lines
%
% hF - Figure handle
% hL - Vector of line handles (first three are bounding lines)
%
% @todo Variable hatch angle
% @todo Different hatch patterns
% @todo Optimization (vectors, yay!)
%
% Volker Hoffmann <volker@cheleb.net>
% 18-10-2010
% 

% Default Hatching Angle (Deg)
alpha = 45;

% Check Arguments
if nargin == 6
  hF = figure();
end

if nargin == 7
  hF = figure( hF );
end

% Bar Contours
xV = [ x_min x_min; ...
  x_min x_max; ...
  x_max x_max ];

yV = [ y_min y_max; ...
  y_max y_max; ...
  y_max y_min ];

if draw_bottom_line
  xV = [ xV; [ x_max x_min ] ];
  yV = [ yV; [ y_min y_min ] ];
end

% Axis Limits (Demo)
xlim( [ x_min - 1 x_max + 1 ] );
ylim( [ y_min y_max + 1 ] );

% Vector of y starting points
y_lo = y_min : dy : y_max;
y_hi = ( x_max - x_min ) .* tand( alpha ) + y_lo;

%
% Hatch y_lo > y_min
%
for ii = 1 : length( y_lo )
  
  % If the max point isn't above the top end of the bar, we keep drawing
  % full lines
  if y_hi(ii) <= y_max
    
    xV = [ xV; [ x_min x_max ] ];
    yV = [ yV; [ y_lo(ii) y_hi(ii) ] ];
    
  % If the max point is above the top end of the bar, we only draw a
  % fraction of the line
  else
    
    x_hi = 1 ./ tand( alpha ) .* ( y_max - y_lo(ii) ) + x_min;
    
    xV = [ xV; [ x_min x_hi ] ];
    yV = [ yV; [ y_lo(ii) y_max ] ];
    
  end
  
end

%
% Hatch y_lo < y_min
%

% Compute steps in X
dx = 1 ./ tand( alpha ) .* dy;
x_lo = x_min : dx : x_max;

for ii = 1 : length( x_lo )
  
  y_hi_1 = ( tand( alpha ) .* ( x_max - x_lo( ii ) ) ) + y_min;
  
  % If the angle is to steep, the y_hi_1 might exceed y_max.
  % Need some more logic to fix this here
  if y_hi_1 > y_max
    
    y_hi_1 = y_max;
    x_hi = 1 ./ tand( alpha ) .* ( y_max - y_min ) + x_lo(ii);
    
  else
    
    x_hi = x_max;
    
  end
  
  xV = [ xV; [ x_lo(ii) x_hi ] ];
  yV = [ yV; [ y_min y_hi_1 ] ];
  
end

hL = line( fliplr( xV' ) , fliplr( yV' ) );
hL = flipud( hL );