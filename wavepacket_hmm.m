function [orgin, seq, zz]= wavepacket_hmm(seed,update_rate,led_rate,range_limit,duration,corr_time,mean_intensity,light_std)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

stream = RandStream('mt19937ar', 'Seed', seed);
dt=1/led_rate;
T=0:dt:(duration+40)-dt;



bistate = stream.rand(1, duration*update_rate);
%upsample the slow changing bistate
ck = zeros(length(bistate),(led_rate/update_rate));
for p = 1:(led_rate/update_rate)
    tb =  bistate>0.5;
    ck(:,p) = tb';
end
k1 = reshape(ck',1,[]);

G_HMM = corr_time; % damping / only G will influence correlation time
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
Xarray = Xarray(end-(led_rate*duration-1):end);
pre1 = (Xarray-min(Xarray))*(light_std/std(Xarray)); %mean = 0
seq = pre1*2;
mid2 = pre1+mean_intensity;
mid3= -pre1+mean_intensity;
wp = zeros(1,length(pre1));
zz= [mid2;mid3];
for i = 1:length(pre1)
    vh = zz(:,i);
    if k1(i)==1
        wp(i) = max(vh);
    else
        wp(i) = min(vh);
    end
end

stimPre =wp;
disp(sum(stimPre < min(range_limit)))
disp(sum(stimPre > max(range_limit)))

data = stimPre;
data(isnan(data)) = mean_intensity;
data(data < min(range_limit)) = min(range_limit);
data(data > max(range_limit)) = max(range_limit);
orgin=data;
end