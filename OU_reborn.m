function orgin = OU_reborn(corrtimes,seed,led_rate,duration )
%Using the seed and correlation time to regenrate the HMM sequence in the
%experiment
%   correlation time, seed and cut obtain form epoch

update_rate = 5;%hz
mean_intensity = 4;
light_std = 1.7;
dt=1/update_rate;
T=0:dt:(duration+40)-dt;
stream = RandStream('mt19937ar', 'Seed',seed);

G_OU =  corrtimes; % damping only G will influence correlation time
D_OU = 2700000; %dynamical range
x = zeros(1,length(T));   %position
x(1,1)=0; % since the mean value of damped eq is zero
V_noise = stream.rand(1, length(T));
for uu = 1:length(T)-1
    x(uu+1) = (1-dt*G_OU/(2.12)^2)*x(uu)+sqrt(dt*D_OU)* V_noise(uu);
end

Xarray = x(end-(update_rate*duration-1):end);
pre1 = (Xarray-mean(Xarray))*(light_std/std(Xarray))+mean_intensity;
%upsample
ck = zeros(length(Xarray),(led_rate/update_rate));
for p = 1:(led_rate/update_rate)
    ck(:,p) = pre1';
end
orgin = reshape(ck',1,[]);

end