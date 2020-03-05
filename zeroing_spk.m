 function opt =  zeroing_spk(start_time,spikes)
                TimeStamp = start_time;
                spike_time = spikes;
                for n = 1:length(spike_time)
                    if (spike_time(n)- TimeStamp) < 0
                        spike_time(n) = -1;
                    else
                        spike_time(n) =  spike_time(n)-TimeStamp;
                    end
                end
                opt = spike_time(spike_time>=0);
            end