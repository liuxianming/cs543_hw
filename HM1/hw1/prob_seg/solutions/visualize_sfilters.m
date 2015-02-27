NORIENT=6;
NSCALES=1;
% NSCALES=3;

thetas = linspace(0, pi, NORIENT+1);
thetas = thetas(1:end-1);

scales = sqrt(5) .^ [1:NSCALES];

sfilters = steerablefilter(scales, thetas);

figure()
for s = 1:NSCALES
    for t=1:NORIENT
        subplot(NSCALES, NORIENT, (s-1)*NORIENT + t);
        imagesc(sfilters{(s-1)*NORIENT + t}); colormap gray;
    end
end