 function rslt = cut_mis(seq,BinningSpike,cuts)
                
                isi = seq;
                rslt =[];
                states =16;
                %% Stimuli process
                for i = 1:cuts
                    Neurons = BinningSpike(1,1+((i-1)*length(BinningSpike)/cuts):i*length(BinningSpike)/cuts);
                    X =isi;%(1,1+((i-1)*length(BinningSpike)/cuts):i*length(BinningSpike)/cuts);
                    nX = sort(X);
                    abin = length(nX)/states;
                    intervals = [ nX(1:abin:end) inf];  %make the states equally distributed
                    for k = 1:length(X)
                        [a,b] = find(X(k)<intervals,1);
                        isi2(k) = b-1;  %a new inter-pulse-interval denoted by the assigned states (ex:1-5) and with the same sampling rate as the BinningSpike
                    end
                    x = Neurons;
                   % y = isi2;
                    y = isi2(1,1+((i-1)*length(BinningSpike)/cuts):i*length(BinningSpike)/cuts);%post spilcing
                    dat=[x;y];
                    [N,C]=hist3(dat'); %20:dividing firing rate  6:# of stim
                    px=sum(N,1)/sum(sum(N)); % x:stim
                    py=sum(N,2)/sum(sum(N)); % y:word
                    pxy=N/sum(sum(N));
                    lpx = -log2(px);
                    lpy = -log2(py);
                    lpxy = -log2(pxy);
                    temp = nansum(px.*lpx)+nansum(py.*lpy)-sum(nansum(pxy.*lpxy));
                    rslt = [rslt temp];
                end
            end