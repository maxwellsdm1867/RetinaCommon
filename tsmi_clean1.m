         function [MI, MI_shuffled,t] = tsmi_clean1(sys_opt,seq)
                %For computating the TSMI curve between any 2 equal length sequence
                %   It requires two sequence to have the samle size(sampling rate)
                states = 12;
                shift = [6000 6000];
                BinningSamplingRate = 40;
                BinningInterval = 1/BinningSamplingRate;
                bin = BinningInterval*1000;
                X =seq;
                nX = sort(X);
                abin = length(nX)/states;
                intervals = [ nX(1:abin:end) inf];  %make the states equally distributed
                for k = 1:length(X)
                    [a,b] = find(X(k)<intervals,1);
                    isi2(k) = b-1;  %a new inter-pulse-interval denoted by the assigned states (ex:1-5) and with the same sampling rate as the BinningSpike
                end
                
                Neurons = sys_opt;%response
                %Neurons=isi2;
                backward=ceil(shift(1)/bin); forward=ceil(shift(2)/bin);
                dat=[];informationp=[];temp=backward+2;
                for i=1:backward+1 %past(t<0)
                    x = Neurons((i-1)+forward+1:length(Neurons)-backward+(i-1))';
                    y = isi2(forward+1:length(isi2)-backward)';
                    dat{i}=[x,y];
                    [N,C]=hist3(dat{i}); %20:dividing firing rate  6:# of stim
                    px=sum(N,1)/sum(sum(N)); % x:stim
                    py=sum(N,2)/sum(sum(N)); % y:word
                    pxy=N/sum(sum(N));
                    temp2=[];
                    for j=1:length(px)
                        for k=1:length(py)
                            temp2(k,j)=pxy(k,j)*log( pxy(k,j)/ (py(k)*px(j)) )/log(2);
                        end
                    end
                    temp=temp-1;
                    informationp(temp)=nansum(temp2(:));
                end
                
                dat=[];informationf=[];temp=0;sdat=[];
                
                for i=1:forward
                    x = Neurons(forward+1-i:length(Neurons)-backward-i)';
                    y = isi2(forward+1:length(isi2)-backward)';
                    dat{i}=[x,y];
                    
                    [N,C]=hist3(dat{i}); %20:dividing firing rate  6:# of stim
                    px=sum(N,1)/sum(sum(N)); % x:stim
                    py=sum(N,2)/sum(sum(N)); % y:word
                    pxy=N/sum(sum(N));
                    temp2=[];
                    for j=1:length(px)
                        for k=1:length(py)
                            temp2(k,j)=pxy(k,j)*log( pxy(k,j)/ (py(k)*px(j)) )/log(2);
                        end
                    end
                    temp=temp+1;
                    informationf(temp)=nansum(temp2(:));
                end
                information=[informationp informationf];
                t=[-backward*bin:bin:forward*bin];
                
                
                MI = information;
                
                % shuffle
                r=randperm(length(Neurons));
                for j=1:length(r)
                    sNeurons(j)=Neurons(r(j));
                end
                Neurons=sNeurons;
                backward=ceil(shift(1)/bin); forward=ceil(shift(2)/bin);
                dat=[];informationp=[];temp=backward+2;
                for i=1:backward+1 %past(t<0)
                    x = Neurons((i-1)+forward+1:length(Neurons)-backward+(i-1))';
                    y = isi2(forward+1:length(isi2)-backward)';
                    dat{i}=[x,y];
                    [N,C]=hist3(dat{i}); %20:dividing firing rate  6:# of stim
                    px=sum(N,1)/sum(sum(N)); % x:stim
                    py=sum(N,2)/sum(sum(N)); % y:word
                    pxy=N/sum(sum(N));
                    temp2=[];
                    for j=1:length(px)
                        for k=1:length(py)
                            temp2(k,j)=pxy(k,j)*log( pxy(k,j)/ (py(k)*px(j)) )/log(2)/(bin/1000);
                        end
                    end
                    temp=temp-1;
                    informationp(temp)=nansum(temp2(:));
                end
                
                dat=[];informationf=[];temp=0;sdat=[];
                
                for i=1:forward
                    x = Neurons(forward+1-i:length(Neurons)-backward-i)';
                    y = isi2(forward+1:length(isi2)-backward)';
                    dat{i}=[x,y];
                    
                    [N,C]=hist3(dat{i}); %20:dividing firing rate  6:# of stim
                    px=sum(N,1)/sum(sum(N)); % x:stim
                    py=sum(N,2)/sum(sum(N)); % y:word
                    pxy=N/sum(sum(N));
                    temp2=[];
                    for j=1:length(px)
                        for k=1:length(py)
                            temp2(k,j)=pxy(k,j)*log( pxy(k,j)/ (py(k)*px(j)) )/log(2)/(bin/1000);
                        end
                    end
                    temp=temp+1;
                    informationf(temp)=nansum(temp2(:));
                end
                information=[informationp informationf];
                MI_shuffled = information;%unshuffle minous shuffled
                
            end