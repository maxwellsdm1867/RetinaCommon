function spike_time = re_distrubuter(FR,bin_rate)
%equal distrubuting method for now
bin_width = 1/bin_rate;
spike_time = [];
for i = 1:length(FR)
    
    if FR(i)~=0
        temp_int = bin_width/(FR(i)+1);
        pre_time = (1:FR(i))*temp_int;
        base_time = (i-1)*bin_width;
        post_time = pre_time+base_time;
        spike_time= [spike_time post_time];
    end
    
end



end