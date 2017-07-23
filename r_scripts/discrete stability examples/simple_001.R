rm(list=ls())

x = seq(-2,2, 0.01)
y = 0.5*(1-cos(2*pi*x))

plot(x, y,
     type="l", 
     lty=c(1),
     col=c("red"),
     xlab="Czas [s]")

### Savings account state model
y = rep(0, 100)
x = seq(0.1,1, 0.01)
alpha = 0.1

for (k in 2:100)
{
  y[k] = (1+alpha)*y[k-1] + x[k]
}

plot(y,
     type="l", 
     lty=c(1),
     col=c("red"),
     xlab="Czas [s]")

### Exponential smoother
y = rep(0, 100)
x = sin(seq(0.1,10, 0.1)) + runif(100, -0.5, 0.5)
alpha = 0.94
for (k in 2:100)
{
  y[k] = alpha*y[k-1] + (1-alpha)*x[k]
}

par(mfrow=c(2,2))
plot(x,
     type="l", 
     lty=c(1),
     col=c("red"),
     xlab="Czas [s]")

plot(y,
     type="l", 
     lty=c(1),
     col=c("red"),
     xlab="Czas [s]")