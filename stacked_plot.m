function stacked_plot(input,tar)
name_seq = cell(1,length(tar));
hold on 
for i = 1: length(tar)
    x = tar(i);
    plot(input(x,:),'linewidth',1.2)
    name_seq{1,i}= num2str(x);
end
hold off
legend(name_seq)
end