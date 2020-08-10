function [BinningSpike] = BinSpk1(BinningInterval,spike_time,DataTime)
                % transfer spike time into firing rate
                %   input binning interval in seconds, spike in seconds
                BinningTime = [0 :  BinningInterval : DataTime];
                %[n,xout] = hist(spike_time,BinningTime);  %putting spikes in the right timings according to an assigned bin interval
                [N,edges] = histcounts(spike_time,BinningTime);%updated verision of binning spikes
                BinningSpike = N;
                %BinningSpike(:,1) = 0;BinningSpike(:,end) = 0;
               
            end