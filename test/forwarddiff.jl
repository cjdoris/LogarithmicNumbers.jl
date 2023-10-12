using ForwardDiff: derivative, gradient
using LogarithmicNumbers
using Test

f(x) = log(exp(x) * x)
g1(x) = log(exp(ULogarithmic, x) * x)
g2(x) = log(exp(ULogFloat64, x) * x)
h1(x) = log(exp(Logarithmic, x) * x)
h2(x) = log(exp(LogFloat64, x) * x)

x = 1000
d = 1 + inv(x)

@test isnan(derivative(f, x))
@test derivative(f, LogFloat64(x)) ≈ d
@test derivative(f, ULogFloat64(x)) ≈ d
@test derivative(g1, x) ≈ d
@test derivative(g2, x) ≈ d
@test derivative(h1, x) ≈ d
@test derivative(h2, x) ≈ d
