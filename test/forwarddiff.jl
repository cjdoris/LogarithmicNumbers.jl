using ForwardDiff: derivative, gradient
using LogarithmicNumbers
using Test

f(x) = exp(x + 1)
g1(x) = exp(Logarithmic, x + 1)
g2(x) = exp(LogFloat64, x + 1)
h1(x) = exp(ULogarithmic, x + 1)
h2(x) = exp(ULogFloat64, x + 1)

@test log(derivative(f, LogFloat64(1000.0))) ≈ log(exp(Logarithmic, 1001.0))
@test log(derivative(f, ULogFloat64(1000.0))) ≈ log(exp(Logarithmic, 1001.0))
@test derivative(g1, 1000.0) ≈ exp(Logarithmic, 1001.0)
@test derivative(g2, 1000.0) ≈ exp(Logarithmic, 1001.0)
@test derivative(h1, 1000.0) ≈ exp(ULogarithmic, 1001.0)
@test derivative(h2, 1000.0) ≈ exp(ULogarithmic, 1001.0)
