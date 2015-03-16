function vp = getVP(centers, vpCandidate)
theta = 1000;
idx = 0;
for i = 1:size(vpCandidate,2)
    temp = 0;
    for j = 1:size(centers,2)
        temp = temp + abs(atan2(vpCandidate(2,i)/vpCandidate(3,i)-centers(2,j),vpCandidate(1,i)/vpCandidate(3,i)-centers(1,j)));
    end
    % select the best candidate point: minimal angle to every line
    if(temp<theta)
        theta = temp;
        idx = i;
    end
end
vp = vpCandidate(:,idx);