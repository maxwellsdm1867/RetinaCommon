function isi2 = sort_state(states,stim)
states = 12;
X =stim;
nX = sort(X);
abin = length(nX)/states;
intervals = [ nX(1:abin:end) inf];  %make the states equally distributed
for k = 1:length(X)
    [a,b] = find(X(k)<intervals,1);
    isi2(k) = b-1;  %a new inter-pulse-interval denoted by the assigned states (ex:1-5) and with the same sampling rate as the BinningSpike
end
end
