function [ hPlot hAx hFig ] = plot_contour( CM, hFig )
%
% @param
% CM - Contour Matrix as returned by [ C_handle CM ] = contour(...)
% hFig - Figure handle (optional, will generate a new one if non-existent)
%
% @return
% hPlot - Lineseries properties handles
% hAx - Axes handle
% hfig - Figure handle
%
% @todo
% Use contour levels. Draw text on the lines.
%
% Volker Hoffmann <volker@cheleb.net>
% 07-02-2011
%

% Init
Header_Location = 1;
% Contour_Level = [];
hPlot = [];

% Figure
if nargin == 1  
  hFig = figure();
else
  hFig = figure( hFig );
end

% Main Loop
while true
 
  % Which contour are we on?
%   Contour_Level = [ Contour_Level Cont1( 1, Header_Location ) ];
  
  % Number of datapoints for the contour?
  First_Element = Header_Location + 1;
  Last_Element = Header_Location + CM( 2, Header_Location );
  
  % Get contour x,y pairs
  x = CM( 1, First_Element:Last_Element );
  y = CM( 2, First_Element:Last_Element );
  
  % Draw contour & assign lineseries properties handles
  hP = plot( x, y ); hold on;
  hPlot = [ hP hPlot ];
  
  % Check whether we're at the end of CM. If not, check next index element.
  % Break the loop otherwise.
  if Last_Element < size( CM, 2 )
    Header_Location = Last_Element + 1;
  else
    break;
  end
  
end

% Get axis and figure handles
hAx = gca;
hFig = gcf;

hold off;