function plotRescaleVert( scaleFactor, axs )
%
% Vertically rescales the axis handle such that any xlabels that might have
% been been cut off are visible again.
%
% Needs to have an active axis handle in workspace to operate!
%
% Alternatively, you can now pass an axis handle.
% 
% References:
% - http://www.mathworks.nl/matlabcentral/newsreader/view_thread/1063
%
% See also:
% - Automatic Axis Resize
% - Position
% - OuterPosition
% - ActivePositionProperty
%
% Volker Hoffmann <volker@cheleb.net>
% 18-11-2010
%

if nargin < 1
  scaleFactor = 1;
  axs = gca;
elseif nargin < 2
  axs = gca;
end

for aa = 1 : length(axs)
  
  ax = axs(aa);
  
  p = get( ax, 'Position' );

  p(2) = p(2) + (1 - scaleFactor) .* p(4) ./ 2;
  p(4) = scaleFactor .* p(4);

  % For vertical AND horizontal resizing
  % p(1:2) = p(1:2) + (1 - scaleFactor) / 2 * p(3:4);
  % p(3:4) = scaleFactor * p(3:4);
  
  set( ax, 'Position', p );
  
end