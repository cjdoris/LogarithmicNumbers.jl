using ForwardDiff: derivative, gradient
using LogarithmicNumbers
using Test

f(x) = log(exp(x) * x)
g1(x) = log(exp(ULogarithmic, x) * x)
g2(x) = log(exp(ULogFloat64, x) * x)
h1(x) = log(exp(Logarithmic, x) * x)
h2(x) = log(exp(LogFloat64, x) * x)

x = 1000
logder = log(1 + inv(x)) 

@test isnan(log(derivative(f, x)))
@test log(derivative(f, LogFloat64(x))) ≈ logder
@test log(derivative(f, ULogFloat64(x))) ≈ logder
@test log(derivative(g1, x)) ≈ logder
@test log(derivative(g2, x)) ≈ logder
@test log(derivative(h1, x)) ≈ logder
@test log(derivative(h2, x)) ≈ logder
