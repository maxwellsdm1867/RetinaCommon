function [sta, sc_check, porcessed,seq,fxs,fys,fnlins]= arthur_sta200525(sta_path,endtime,STA_ana)
load('D:\sf\td\seqs\sta.mat')%this is the sta sequence
load(STA_ana)
load(sta_path)
seq = seq-mean(seq);
thrs = 150;
analog_data = a_data(2,:);
SamplingRate = Infos.SamplingRate;
time = length(a_data(2,:))/Infos.SamplingRate;
norm_analog =analog_data-mean(analog_data);
pre_stamp = find(norm_analog>thrs,1);
TimeStamp = (pre_stamp/SamplingRate) + 1;
plot(a_data(2,:))
vline(TimeStamp*SamplingRate )
display(num2str(TimeStamp))%display time stamps
%cut spikes
sorted_Spikes = Spikes(1,:);%change
process_spike = sorted_Spikes;
porcessed = cell(1,length(sorted_Spikes));
for i = 1: length(process_spike)
    for n = 1:length(process_spike{i})
        if process_spike{i}(n)- TimeStamp < 0
            process_spike{i}(n) = 0;
        else
            process_spike{i}(n) =  process_spike{i}(n)-TimeStamp;
        end
    end
    
    for k= 1:length(process_spike{i})
        porcessed{i} = process_spike{i}(process_spike{i}~=0);
    end
end
win_size = 0.5;%seconds
back_step = round(0.5*25);
spkt = Spikes;


sc_check =zeros(1,length(porcessed));
for i = 1:length(porcessed)
    temps = porcessed{1,i};
    temps = temps(temps>0.5& temps<endtime);
    sc_check (1,i)=length(temps);
    h = zeros(length(temps),back_step);
    
    for j =1:length(temps)
        x = temps(j)*25;
        h(j,:) = seq(x-12:x);
    end
    spkt{1,i} = mean(h);
    
end
sps = zeros(13,size(Spikes,2));
for i = 1:size(Spikes,2)
    sps(:,i) = spkt{1,i};
end
%get the nonlinear filter out here
dtStim = 1/25;
fxs = cell( 1,length(spkt)) ;
fys =cell( 1,length(spkt)) ;
fnlins =cell( 1,length(spkt));
close all
for k = 1:length(spkt)
    
    try
        binspiz=BinSpk1(0.040,porcessed{1,k},300);
        rawfilteroutput0 = conv(seq(1,1:7500),flip(spkt{1,i})) ;
        rawfilteroutput1 = rawfilteroutput0(1:7500);
        nfbins = 100;
        [cts,binedges,binID] = histcounts(rawfilteroutput1,nfbins);
        fx = binedges(1:end-1)+diff(binedges(1:2))/2; % use bin centers for x positions
        fy = zeros(nfbins,1); % y values for nonlinearity
        for jj = 1:nfbins
            fy(jj) = mean(binspiz(binID==jj));
        end
        fy = fy/dtStim; % divide by bin size to get units of sp/s;
        
        % Now let's embed this in a function we can evaluate at any point
        fnlin = @(x)(interp1(fx,fy,x,'nearest','extrap'));
        fxs{1,k} = fx;
        fys{1,k} = fy;
        fnlins{1,k} = fnlin;
        
        
%         figure
%         isp = .0000001;
%         xx = binedges(1):isp:binedges(end);
%         plot(xx,fnlin(xx),'linewidth', 2);
%         xlabel('filter output');
%         ylabel('rate (sp/s)');
%         
%         legend( 'nonparametric f', 'location', 'northwest');
%         title('nonlinearity');
%         
    end
    
    
    sta=sps;
end
end