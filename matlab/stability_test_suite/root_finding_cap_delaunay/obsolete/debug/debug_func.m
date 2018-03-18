Gz = [0.5 0.3 0.4]
Gp = [0.3 0.2 0.1i -0.1i]

input = 3

output = 1;
for i=1:numel(Gz)
    output = output*(input - Gz(i));
end

for i=1:numel(Gp)
    output = output/(input - Gp(i));
end
output