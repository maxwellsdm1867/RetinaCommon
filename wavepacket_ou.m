function  [orgin seq zz]=  wavepacket_ou(seed,update_rate,led_rate,range_limit,duration,corr_time,mean_intensity,light_std)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

stream = RandStream('mt19937ar', 'Seed', seed);
dt=1/led_rate;
T=0:dt:(duration+40)-dt;



bistate = stream.rand(1, duration*update_rate);
%upsample the slow changing bistate
ck = zeros(length(bistate),round(led_rate/update_rate));
for p = 1:round(led_rate/update_rate)
    tb =  bistate>0.5;
    ck(:,p) = tb';
end
k1 = reshape(ck',1,[]);

G_OU =  corr_time; % damping only G will influence correlation time
D_OU = 2700000; %dynamical range
V_noise = stream.rand(1, length(T));

x = zeros(1,length(T));   %position
x(1,1)=0; % since the mean value of damped eq is zero

for uu = 1:length(T)-1
    x(uu+1) = (1-dt*G_OU/(2.12)^2)*x(uu)+sqrt(dt*D_OU)* V_noise(uu);
end

Xarray = x(end-(led_rate*duration-1):end);
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