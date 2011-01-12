function [ X Y ] = matrix2vectors( M, x, y )
%
% Assuming we have a matrix M which traces out some some sort of contour by
% virtue of some elements being M = 1 and all others being M = 0.
%
% Takes M with physical coordinates x and y. Looks for elements with M = 1,
% extracts x, y and builds the vector X and Y from it. Further builds the
% vectors I and J (which are the indices where x and y are located in X and
% Y). Then sort X and Y by looing for the closest following point (in
% coordinates I and J, i.e. in pixel (image) space.
%
% Ideally, this sorting should result in a somewhat smooth contour even if
% the contour is looping backwards at times.
%
% !!! WARNING !!! - This doesn't always work, especially at sharp corner
% points when two lines converge. ALWAYS perform manual visual inspection.
%
% @todo Fix this (lookahead? some condition on the angle? mmhhh ...)
%
% Volker Hoffmann <volker@cheleb.net>
% 11-01-2011
%

% Init
X = [];
Y = [];
I = [];
J = [];

% Loop through M to extract all points where M = 1
for i = 1:size(M,1)
  for j = 1:size(M,2)
    if M(i,j) > 0
      X = [ X x(j) ];
      J = [ J j ];
      Y = [ Y y(i) ];
      I = [ I i ];
    end
  end
end

% We now select any (x0,y0), and check with all FOLLOWING (x1,y1) pairs to
% pick the one which minimizes the distance between the two.
%
% Once done, we move (x1,y1) behind (x0,y0) in the vectors.
%
% Then, rinse and repeat starting at the former (x1,y1) as (x0,y0). Only
% look at the following points so we don't treat previously visited points!
%
% @todo If this doesn't yield the desired result, add a constraint on the
% angle!

% Run through all elements in X,Y,I,J (they all have the same length)
for ii = 1 : length(X) - 1
  
  % Compute the distance of all following elements at >ii to the current
  % element at ii. The commented line used physical distance X,Y instead of
  % image / pixel distance I,J.
  dist = sqrt( ( J(ii) - J(ii+1:end) ).^2 + ( I(ii) - I(ii+1:end) ).^2 );
%   dist = sqrt( ( X(ii) - X(ii+1:end) ).^2 + ( Y(ii) - Y(ii+1:end) ).^2 );

  % Use NaN for previously visited elements
  dist = [ NaN .* ones( 1, ii ) dist ];

  % Select minimum distance
  [ val idx ] = min( dist );

  % Now insert the next closest element after the current element. Also
  % remove that element from its original position. Do this for both image
  % and physical coordinates I,J and X,Y
  J = [ J(1:ii) J(idx) J(ii+1:idx-1) J(idx+1:end) ];
  I = [ I(1:ii) I(idx) I(ii+1:idx-1) I(idx+1:end) ];
  
  X = [ X(1:ii) X(idx) X(ii+1:idx-1) X(idx+1:end) ];
  Y = [ Y(1:ii) Y(idx) Y(ii+1:idx-1) Y(idx+1:end) ];
  
end