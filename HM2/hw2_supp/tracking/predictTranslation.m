function [newX newY] = predictTranslation(startX, startY, Ix, Iy, im0, im1)
%PREDICTTRANSLATION 
% For a single X,Y location, use the gradients Ix, Iy, 
% and images im0, im1 to compute the new location. 
% Here it may be necessary to interpolate Ix,Iy,im0,im1 
% if the corresponding locations are not integer.
% WindowSize = 15

% Initialize points
P = [0,0];
newP = [startX, startY];
threshold = 0.01;

% The difference between I([x,y] + [u,v], t+1) and I(x, y, t)
delta_p = 100;

while norm(delta_p) > threshold
    % Start tracking
    
end

% Assign final values
newX = newP(1);
newY = newP(2);

end

