function [ CCA ] = get_contour_cell_array( CM )
%
% @param
% CM - Contour Matrix as returned by [ C_handle CM ] = contour(...)
%
% @return
% CCA - cell array of CC --> { CC1; CC2; CC3; ... }
% 
% @notes
% CC = { CONTOUR_LEVEL, [ x1 ... xn ], [ y1 ... yn ] }
% 
% @todo
% Lots of copied code with plot_contour.m. Reuse instead.
%
% Volker Hoffmann <volker@cheleb.net>
% 30-08-2011
%

% Init
Header_Location = 1;
CCA = {};

% Main Loop
while true
  
  % Init contour cell
  CC = cell(1,3);
 
  % Which contour are we on?
  Contour_Level =  CM( 1, Header_Location );
  
  % Number of datapoints for the contour?
  First_Element = Header_Location + 1;
  Last_Element = Header_Location + CM( 2, Header_Location );
  
  % Get contour x,y pairs
  X = CM( 1, First_Element:Last_Element );
  Y = CM( 2, First_Element:Last_Element );
  
  % Add contour level and x,y to contour cell
  CC{1} = Contour_Level;
  CC{2} = X;
  CC{3} = Y;

  % Add contour cell to contour cell array
  CCA = { CCA{:} CC };

  % Check whether we're at the end of CM.
  % If not, check next index element.
  % Break the loop otherwise.
  if Last_Element < size( CM, 2 )
    Header_Location = Last_Element + 1;
  else
    break;
  end
  
end

% I want a column vector
CCA = CCA';