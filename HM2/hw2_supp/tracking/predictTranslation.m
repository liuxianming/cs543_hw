function P = predictTranslation( startX, startY, Ix, Iy, im0, im1, sigma)
%PREDICTTRANSLATIONSINGLEPT Calculating translation for a single corner pt
% startX, startY - the starting point
% im0, im1 - image frames at t and t+1
% Return value:
%   P - the new position in im1

% Calculating gradients
if nargin < 7
    sigma = 7;
end

P = [startX, startY]'; % new position, [x,y] + [u,v]
threshold = 0.05; % threshold for convergence

H = [sum(sum(Ix.*Ix)), sum(sum(Ix.*Iy)); sum(sum(Ix.*Iy)), sum(sum(Iy.*Iy))];
if abs(det(H)) < eps
    % singular matrix
    return
end
% Intialization
[x,y] = meshgrid(startX-sigma:startX+sigma, startY-sigma:startY+sigma);
W0 = interp2(im0, x,y, '*linear');
W1 = interp2(im1, x,y, '*linear');
It = W1 - W0;

iteration = 0;

while true
    if P(1)-sigma<=0 || P(1)+sigma>size(im0,2) || P(2)-sigma<=0 || P(2)+sigma>size(im0,1)
        % New point is out of range
        disp('Out of Image Range');
        break;
    end
    % solve equation
    b = - [sum(sum(Ix.*It)); sum(sum(Iy.*It))];
    delta = H\b;
    %delta = solveLS(Ix, Iy, It);
    P = P + delta;
    if norm(delta) < threshold || iteration > 10
        break;
    else
        %Update It
        [x,y] = meshgrid(P(1)-sigma:P(1)+sigma, P(2)-sigma:P(2)+sigma);
        W1 = interp2(im1, x, y, '*linear');
        It = W1 - W0;
        iteration = iteration + 1;
    end
end

end

