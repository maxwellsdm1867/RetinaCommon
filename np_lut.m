function lut = np_lut(x,y,nfbins )
%non parametric look up table 

%average firing rate as the function stimulus levels
[cts,binedges,binID] = histcounts(x,nfbins); 
fx = binedges(1:end-1)+diff(binedges(1:2))/2; % use bin centers for x positions

% now compute mean spike count in each bin
fy = zeros(nfbins,1); % y values for nonlinearity
for jj = 1:nfbins
    fy(jj) = mean(y(binID==jj));
end
lut = [fx;fy'];
end