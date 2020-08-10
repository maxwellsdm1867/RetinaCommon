function [MI,t]= only_timeshift(stim,resp,BinningSamplingRate)
isi2 = stim;
sys_opt = resp;
BinningInterval = 1/BinningSamplingRate;
bin = BinningInterval*1000;
Neurons = sys_opt;%response
shift = [6000 6000];
backward=ceil(shift(1)/bin); forward=ceil(shift(2)/bin);%there is a bug here we need to fix
dat=[];informationp=[];temp=backward+2;
for i=1:backward+1 %past(t<0)
    x = Neurons((i-1)+forward+1:length(Neurons)-backward+(i-1))';
    y = isi2(forward+1:length(isi2)-backward)';
    dat{i}=[x,y];
    [N,C]=hist3(dat{i},'Edges',{0:1:max(Neurons) sort(unique(isi2))}); %20:dividing firing rate  6:# of stim
    px=sum(N,1)/sum(sum(N)); % x:stim
    py=sum(N,2)/sum(sum(N)); % y:word
    pxy=N/sum(sum(N));
    temp2=[];
    hx = entropy(px);
    hy = entropy(py);
    hxy = entropy(reshape(pxy,1,[]));
    MIp = hx+hy-hxy;
    temp=temp-1;
    informationp(temp) = MIp;
end

dat=[];informationf=[];temp=0;sdat=[];

for i=1:forward
    x = Neurons(forward+1-i:length(Neurons)-backward-i)';
    y = isi2(forward+1:length(isi2)-backward)';
    dat{i}=[x,y];
    
      [N,C]=hist3(dat{i},'Edges',{0:1:max(Neurons) sort(unique(isi2))}); %20:dividing firing rate  6:# of stim
    px=sum(N,1)/sum(sum(N)); % x:stim
    py=sum(N,2)/sum(sum(N)); % y:word
    pxy=N/sum(sum(N));
    temp2=[];
    hx = entropy(px);
    hy = entropy(py);
    hxy = entropy(reshape(pxy,1,[]));
    MIf = hx+hy-hxy;
    temp=temp+1;
    informationf(temp)=MIf;
end
information=[informationp informationf];
t=[-backward*bin:bin:forward*bin];


MI = information;

end