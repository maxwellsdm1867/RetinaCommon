function orgin = HMM_sr(corrtimes,seed,led_rate,duration,update_rate,mean_int,light_std, noise_level)
%Using the seed and correlation time to regenrate the HMM sequence in the
%experiment
%   correlation time, seed and cut obtain form epoch

dt=1/update_rate;
T=0:dt:(duration+40)-dt;
stream = RandStream('mt19937ar', 'Seed',seed);

G_HMM = corrtimes; % damping / only G will influence correlation time
D_HMM = 2700000; %dynamical range
omega =G_HMM/2.12;   % omega = G/(2w)=1.06; follow Bielak's overdamped dynamics/ 2015PNAS

Xarray = zeros(1,length(T));   %bar  position
Xarray(1,1)=0; % since the mean value of damped eq is zero
Vx = zeros(1,length(T));  %velocity
V_noise = stream.rand(1, length(T));

for t = 1:length(T)-1
    Xarray(t+1) = Xarray(t) + Vx(t)*dt;
    Vx(t+1) = (1-G_HMM*dt)*Vx(t) - omega^2*Xarray(t)*dt + sqrt(dt*D_HMM)*V_noise(t);
end
Xarray = Xarray(end-(duration*update_rate-1):end);
pre1 = (Xarray-mean(Xarray))*(light_std/std(Xarray))+mean_int;
noise_pre= stream.rand(1, length(pre1));
noise_mid = ((noise_pre-mean(noise_pre))/std(noise_pre))*light_std*noise_level;%normilzed to the 
post1 = pre1+noise_mid;
%upsample using 
ck = zeros(length(Xarray),(led_rate/update_rate));
for p = 1:(led_rate/update_rate)
    ck(:,p) = post1';
end
orgin = reshape(ck',1,[]);

end