function [type_idx,res] = typing(sta)
fact = 100;
up_sta= interp(sta,fact);
f_up= up_sta(1:1200);
temp = f_up(800:end);
m = mean(f_up(1:600));
mid = temp-m;
po = abs(sum(mid.*(mid>0)));
ne = abs(sum(mid.*(mid<0)));
tot_area = sum(abs(mid));
d= po-ne;
res = d./tot_area;
com = mid(100:end)<0;
k = diff(com);
aa =find(k~=0);
if~isempty(aa)
    r = k(aa(1));
else
    r=87;
end

if res>0.8
    type_idx = 1;%on cell
elseif res<-0.8
    type_idx = 2;%off cell
elseif res<0.8 & res>-0.8 & r==1
    type_idx = 3; %Trainsient
elseif res<0.8 & res>-0.8 & r==-1
    type_idx = 4;%Trainsient
else
    type_idx=5;%unindentify
end
    
end