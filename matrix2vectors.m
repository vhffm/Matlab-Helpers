function [ X Y ] = matrix2vectors( M, x, y )
%
% Takes matrix M indexed by vectors x and y.
%
% Looks for elements with M = 1, extracts x, y and builds the vector X and
% Y from it.
%
% Volker Hoffmann <volker@cheleb.net>
% 09-06-2010
%

% Throw it into an array
X = [];
Y = [];
for i = 1:size(M,1)
    for j = 1:size(M,2)
        if M(i,j) > 0
            X = [ X x(j) ];
            Y = [ Y y(i) ];
        end 
    end
end