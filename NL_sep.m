function [filter,link_function,nlx,nly] = NL_sep(firing_rate,stimulus,dtStim)
ntfilt = 25;
Stim =nor1(stimulus');
sps = firing_rate';
nsp = sum(sps);
paddedStim = [zeros(ntfilt-1,1); Stim]; % pad early bins of stimulus with zero
Xdsgn = hankel(paddedStim(1:end-ntfilt+1), Stim(end-ntfilt+1:end));
sta = (Xdsgn'*sps)/nsp;
sta_out =( Xdsgn)*sta;% this is the linear filter output? should be right?
%nonlinearity
rawfilteroutput = sta_out ;
nfbins = 100; 
[cts,binedges,binID] = histcounts(rawfilteroutput,nfbins); 
fx = binedges(1:end-1)+diff(binedges(1:2))/2; % use bin centers for x positions
fy = zeros(nfbins,1); % y values for nonlinearity
for jj = 1:nfbins
    fy(jj) = mean(sps(binID==jj));
end
fy = fy/dtStim; % divide by bin size to get units of sp/s;

% Now let's embed this in a function we can evaluate at any point
fnlin = @(x)(interp1(fx,fy,x,'nearest','extrap'));
nlx = fx;
nly = fy;
link_function =fnlin;
filter = sta;
end