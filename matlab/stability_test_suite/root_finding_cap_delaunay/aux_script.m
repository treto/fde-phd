close all

fz_roots = [(0.8+0.2i) (0.8-0.2i) (0.85 + 0.55i) (0.85 - 0.55i) (0.7 + 0.65i) (0.7 -0.65i) (-0.25+0.5i) (-0.25 -0.5i) (-0.23+0.8i) (-0.23-0.8i) (-0.6+0.7i) (-0.6-0.7i)];

fz = zpk([], fz_roots, 1, 1);
fz = tf(fz);
[num, dem, Ts] = tfdata(fz);
dem = dem{:};
w_params = flip(dem) %parametry A(w^-1) dla 'rozwinietej' postaci
roots(dem); %pierwiastki rownania char A(z)
roots(w_params) %pierwsiastki rownania char A(w^-1)
scatter(real(fz_roots), imag(fz_roots))';
abs(fz_roots)';
