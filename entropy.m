function H = entropy(dist)
H = -1*nansum(dist.*log2(dist));
end