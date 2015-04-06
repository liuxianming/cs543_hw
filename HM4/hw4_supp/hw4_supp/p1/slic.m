function [cIndMap, time, imgVis] = slic(img, K, compactness, visible)

%% Implementation of Simple Linear Iterative Clustering (SLIC)
%
% Input:
%   - img: input color image
%   - K:   number of clusters
%   - compactness: the weighting for compactness
%   - visible: show error map at initialization and converge if 0,
%              otherwise it is the figure handle to show error maps
% Output: 
%   - cIndMap: a map of type uint16 storing the cluster memberships
%   - time:    the time required for the computation
%   - imgVis:  the input image overlaid with the segmentation

if nargin == 3
    visible = 0;
end

if visible > 0
    % create the figure handle to plot error map
    figure(visible);
end

tic;
% Put your SLIC implementation here
NUM_ITER = 10;
% Initialization: cluster centers and original labels
imgVis = img;
img = im2double(img);
colorTransform = makecform('srgb2lab');
img = double(applycform(img, colorTransform));
sz = size(img);

S = round(sqrt(sz(1) * sz(2) / K));
% Initialization of clustering centers
xVec = floor(linspace(1, sz(2), sqrt(K) + 2));
yVec = floor(linspace(1, sz(1), sqrt(K) + 2));
xVec = xVec(2: end-1);
yVec = yVec(2: end-1);
[centerX, centerY] = meshgrid(xVec, yVec);

% cluster index matrix
cIndMap=zeros([size(img,1),size(img,2),2]); 
%1st layer = x_idx ,2nd layer = y_idx, index corresponding to the elements in centerX & centerY

distanceMap = 1e19*ones(sz(1),sz(2));

% avoid edge pixels for clustering center initialization
% Choose the center to be pixels with smallest gradient
if ndims(img) == 3
    [gx,gy] = gradient(rgb2gray(img));
else
    [gx,gy] = gradient(img);
end
g = gx.^2+gy.^2;

for iy=1:size(centerX,2)    %'centerX' and 'centerY' are same sized meshgrid, not vector !!
    for ix=1:size(centerX,1)
        region=g(centerY(iy,ix)-1:centerY(iy,ix)+1,centerX(iy,ix)-1:centerX(iy,ix)+1);
        % find minimal gradient pixel in a 3*3 grid
        [~,ind]=min(region(:));
        [dy,dx]=ind2sub([3 3],ind);
        centerX(iy,ix)=centerX(iy,ix)+dx-2;
        centerY(iy,ix)=centerY(iy,ix)+dy-2;
    end
end

% initialize cluster center LAB
centerLAB=zeros([size(centerX),3]);
centerLAB(:,:,1)=img(sub2ind(size(img),centerY,centerX,ones(size(centerX))));
centerLAB(:,:,2)=img(sub2ind(size(img),centerY,centerX,2*ones(size(centerX))));
centerLAB(:,:,3)=img(sub2ind(size(img),centerY,centerX,3*ones(size(centerX))));

% The big outer loop: iteratively perform k-means until convergence
for loop=1:NUM_ITER
    % 1. starting assign pixels and distances
    for ix = 1:size(centerX,2)
        for iy = 1:size(centerX,1)
            if isnan(centerX(iy,ix)) || isnan(centerY(iy,ix))
                % the cluster is empty
                continue;
            end
            
            % get the region centered at current cluster center, 
            % with size 2S*2S
            region_ys = max(1,centerY(iy,ix)-S):min(centerY(iy,ix)+S, size(img,1));
            region_xs = max(1,centerX(iy,ix)-S):min(centerX(iy,ix)+S, size(img,2));
            region=img(region_ys,region_xs,:);
            
            [region_coorX,region_coorY]=...
                meshgrid(region_xs,region_ys);
            centerLabMat=ones(size(region));
            for idx = 1:size(region,3)
                centerLabMat(:,:,idx) = centerLAB(iy,ix,idx) * centerLabMat(:,:,idx);
            end
            % Lab color distance
            lab_diff=sum((region-centerLabMat).^2,3);
            % Coordinates distance
            coor_diff=(region_coorX-centerX(iy,ix)).^2+(region_coorY-centerY(iy,ix)).^2;
            % calculate final distance 
            diff=lab_diff+compactness^2*coor_diff/S^2;
            
            % compare with distanceMap, to see if need to change cluster id
            modify = (diff < distanceMap(region_ys,region_xs));
            distanceMap(region_ys,region_xs)=modify.*diff+...
                not(modify).*distanceMap(region_ys,region_xs);
            cIndMap(region_ys,region_xs,1)=modify*ix+not(modify).*cIndMap(region_ys,region_xs,1);
            cIndMap(region_ys,region_xs,2)=modify*iy+not(modify).*cIndMap(region_ys,region_xs,2);
        end
    end
    % 2. Update cluster center and LAB features
    pre_x=centerX;
    pre_y=centerY;
    for ix=1:size(centerX,2)
        for iy=1:size(centerX,1)
            mask=bsxfun(@eq,cIndMap,...
                cat(3,ix*ones(size(img,1), size(img,2)),iy*ones(size(img,1), size(img,2))));
            mask=mask(:,:,1) & mask(:,:,2);

            [r,c]=find(mask);                %update location
            centerX(iy,ix)=round(mean(c));   %rounding necessary due to the local 2S*2S window indexing
            centerY(iy,ix)=round(mean(r));
            color=bsxfun(@times,img,mask);   %update LAB
            [~,~,vr]=find(color(:,:,1));
            [~,~,vg]=find(color(:,:,2));
            [~,~,vb]=find(color(:,:,3));
            centerLAB(iy,ix,1)=mean(vr);
            centerLAB(iy,ix,2)=mean(vg);
            centerLAB(iy,ix,3)=mean(vb);
        end
    end
    
    % visualization
    if visible > 0
        figure(visible);
        if(loop==1)
            subplot(1,3,1); imagesc(log(distanceMap)); title('Error Map at initialization');
            drawnow;
        else
            subplot(1,3,2); imagesc(log(distanceMap)); title('Error Map Now');
            drawnow;
        end
    end
    
    diff_x=abs(pre_x-centerX);
    diff_y=abs(pre_y-centerY);
    if norm(diff_x(:))<=10 && norm(diff_y(:))<=10  %stop when cluster centers don't move too much
        break
    end
end

if visible > 0
    figure(visible);
    subplot(1,3,2); title('Error Map when convergence');
end

% post-processing: merge the small regions
for ix=1:size(centerX,2)
    for iy=1:size(centerX,1)
        mask=bsxfun(@eq,cIndMap,...
            cat(3,ix*ones(size(img,1), size(img,2)),iy*ones(size(img,1), size(img,2))));
        mask=mask(:,:,1) & mask(:,:,2);
        
        mask=bwmorph(mask, 'clean');
        mask=bwmorph(mask, 'fill');
        mask=bwmorph(mask, 'close');
        tempind=find(mask);
        % discard the current cluster center if too minor
        % To complete this:
        % 1) set all pixels within this cluster as cInd = 0
        % 2) search for the nearest cluster center
        % 3) set all pixels within this cluster as the nearest cluster
        if sum(mask(:))<0.6*S^2
            cIndMap(tempind)=0;
            
            % search a nearest cluster within 3*3 clusters
            candidate_center_dy = max(1,iy-1):min(iy+1,size(centerX,1));
            candidate_center_dx = max(1,ix-1):min(ix+1,size(centerX,2));
            xregion=centerX(candidate_center_dy,candidate_center_dx);
            yregion=centerY(candidate_center_dy,candidate_center_dx);
            center_distance=(xregion-centerX(iy,ix)).^2+(yregion-centerY(iy,ix)).^2;
            [~,ind]=sort(center_distance(:),'ascend');
            [dy,dx] = ind2sub(size(center_distance), ind(2));
            ny = candidate_center_dy(dy);
            nx = candidate_center_dx(dx);
            
            % set all the pixels to the nearest cluster center
            cIndMap(tempind)=nx;
            cIndMap(tempind+size(cIndMap,1)*size(cIndMap,2))=ny;
        else
            cIndMap(tempind)=ix;
            cIndMap(tempind+size(cIndMap,1)*size(cIndMap,2))=iy;
        end                  
    end
end

% deal with no-label pixels
mask=(cIndMap(:,:,1)<=0).*1;
if sum(mask(:))
    [x,y]=meshgrid(1:size(img,2),1:size(img,1));
    x=x.*mask;
    y=y.*mask;
    centerX_idx=ceil(x/S);
    centerX_idx(centerX_idx>size(centerX,2))=size(centerX,2);
    centerY_idx=ceil(y/S);
    centerY_idx(centerY_idx>size(centerY,1))=size(centerY,1);
    % assign to the nearest non-zero cluster center
    cIndMap(:,:,1)=cIndMap(:,:,1)+centerX_idx;
    cIndMap(:,:,2)=cIndMap(:,:,2)+centerY_idx;
end

tempidx=sub2ind(size(centerX),cIndMap(:,:,2),cIndMap(:,:,1));
cIndMap=sub2ind([size(img,1),size(img,2)],centerY(tempidx),centerX(tempidx));

time = toc;

% Generating imgVis
h = [-1 1];  
gx = filter2(h ,cIndMap);
gy = filter2(h',cIndMap);
maskim = (gx.^2 + gy.^2) > 0;
maskim = bwmorph(maskim, 'thin', Inf);
maskim(1,:) = 0; maskim(end,:) = 0;
maskim(:,1) = 0; maskim(:,end) = 0;
imgVis(maskim)=255;

if visible>0
    figure(visible); subplot(1,3,3);
    imshow(imgVis,[]);
    title('Segmenation Results');
    drawnow;
end

cIndMap = uint16(cIndMap);

end

