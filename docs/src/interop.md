# Interoperability

If any of the following packages are loaded, then some extra functionality is made available.

## Distributions.jl

If `D` is a distribution, then `cdf(ULogarithmic, D, x)` computes the `cdf` of `D` at `x` as a `ULogarithmic` number. Internally it calls `logcdf(D, x)`.

Similarly there is `ccdf(ULogarithmic, D, x)` and `pdf(ULogarithmic, D, x)`.