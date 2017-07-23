rm(list=ls())
z = seq(-2,2, 0.01)

a = 22.86
b = 10.16
d = 10
eps_r = 5-2i

#f_z = k2*tan(k1 * d) +k1*tan(k2(a-d))
# k1 = k0 * square(z^2 + eps)
# k2 = k0 * square(z^2 + 1)
# k0 = 2*pi*f/c
f = 4e6
c = 3e8
k0 = 2*pi*f/c
k1 = k0 * sqrt(z^2+eps_r)
k2 = k0 * sqrt(z^2 + 1)

delta_r = 0.1

f_z = k2*tan(k1*d) + k1*tan(k2*(a-d))

plot(f_z, xlim=c(-10, 10), ylim=c(-10,10))
#plot(Im(f_z))
#plot(Re(f_z))
