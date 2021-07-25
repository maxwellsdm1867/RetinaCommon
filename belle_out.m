close all
clear all
clc
cd('D:\belle_stat\210807')
load('D:\sort_files\200915\mega_2.mat')

%%output data for belle
%%
for con = 1:2
    for noi = 1:6
        tt = mega{con,noi};
        for i = 1:length(tt)
            name_head = ['ID=' num2str(tt(i).id) 'con=' num2str(con) 'noi=' num2str(noi)];
            spkt = tt(i).spike_time;
            staSpkt = tt(i).staSpikes;
            staSeq =  tt(i).staSeq;
            seq= tt(i).seq;
            %noi_seq =  tt(i).Stim;
            save([name_head '_spikes'],'spkt')
            save([name_head '_seq'],'seq')
            save([name_head '_staSpikes'],'staSpkt')
            save([name_head '_staSeq'],'staSeq')
        end
    end
end
