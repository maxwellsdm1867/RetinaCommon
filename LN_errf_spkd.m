function out = LN_errf_spkd(X)
%Error energy function that we feed in to GA algo
%   10 param to discribe the nonlinear and linear filter and specify the
%   error as the energy of difference

load('C:\Users\Arthur\Documents\GitHub\StochasticResonance\stim2.mat')
load('C:\Users\Arthur\Documents\GitHub\StochasticResonance\fr3.mat')%stim =the stimulus presented to the cell
nor_stim = (Stim-mean(Stim));%/mean(Stim);
%fr =fr*25;
%for linear filter
amp = X(1); %scaling factor
numFilt = X(2);
tauR = X(3);
tauD = X(4);
tauP =X(5);
phi = X(6);
t_filter = ((1:25) * 1/25)';
linear_filter = ((amp*((((t_filter./abs(tauR)) .^ numFilt) ./ (1 + ((t_filter./abs(tauR)) .^ numFilt))) ...
    .* exp(-((t_filter./tauD))) .* cos(((2.*pi.*t_filter) ./ tauP) + (2*pi*phi/360)))));
generator_signal = conv(nor_stim,linear_filter);
xarray = generator_signal(1:length(Stim));
%for nonlinearlity which is a sigmoid
alpha = X(7);      % determines maximum
beta  = X(8);      % determines steepness
gamma = X(9);     % determines threshold/shoulder location
epsilon  =X(10);   % shifts all up or down
params = [alpha; beta; gamma; epsilon];
LN_out = params(1) * normcdf(params(2) .* xarray + params(3), 0, 1) + params(4);
%r = poissrnd(LN_out);
%this is the error function

if abs(length(re_distrubuter(LN_out,25))-length(re_distrubuter(fr,25)))>100
    display(num2str(1))
    out = 20000+randi([1,100000]);
else
     display(num2str(2))
    out =spkd(re_distrubuter(LN_out,25),re_distrubuter(fr,25),0.1);
end

end

