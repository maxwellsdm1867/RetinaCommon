function cv_fr = gauss_firing(spk, duration,width,binrate)
%spk is spiking time in seconds
%duration is the duration of the stimulus
%width is the width of the gaussian that you want to replace each spike
%with
[fr] = BinSpk1(1/binrate,spk,duration);% bin the spike in 1 ms window
g_x = round(-width/2):round(width/2);
g_y = gaussmf(g_x,[15 0]);

pst_fr = zeros(1,(length(g_x)+length(fr)+(length(g_x))));%51 ms padding for the Gaussian
for i = 1 : length(fr)  
    temp_fr = zeros(1,(length(g_x)+length(fr)+(length(g_x))));
    temp_fr((width+1+i-round(width/2)):(width+1+i+round(width/2))) = fr(i)*g_y;
    pst_fr =  pst_fr+temp_fr;
end
cv_fr = pst_fr(width+2:(width+2+duration*binrate-1));
end