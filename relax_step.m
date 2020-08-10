function lut = relax_step(spike,stim,stim_rate, tar_rate)
dwn_stim = downsample(stim,stim_rate/tar_rate);
fr = BinSpk1(1/tar_rate,spike,length(stim)/stim_rate);
step_size = (1/tar_rate);
hmm_size = 0.2;
full_step = hmm_size/step_size;
s_stim = dwn_stim(10:10:end);%sampled stimulus
s_fr = fr(10:10:end); %sampledfiring rate
%average firing rate as the function stimulus levels
nfbins = 100; 
[cts,binedges,binID] = histcounts(s_stim,nfbins); 
fx = binedges(1:end-1)+diff(binedges(1:2))/2; % use bin centers for x positions

% now compute mean spike count in each bin
fy = zeros(nfbins,1); % y values for nonlinearity
for jj = 1:nfbins
    fy(jj) = mean(s_fr(binID==jj));
end
lut = [fx;fy'];
end