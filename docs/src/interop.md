# Interoperability

If any of the following packages are loaded, then some extra functionality is made available.

## Distributions.jl

There are functions `cdf(T, D, x)`,  `ccdf(T, D, x)` and `pdf(T, D, x)` where `T<:AbstractLogarithmic`. These are the same as without the `T` argument except the return type is `T`.

Internally, they call `logcdf(D, x)` etc.

```julia
julia> cdf(ULogarithmic, Normal(1, 1), 0)
exp(-1.841021645009264)
```

## StatsFuns.jl

There are functions `Dcdf(T, args...)`, `Dccdf(T, args...)` and `Dpdf(T, args...)` where `D` is a distribution name (e.g. `norm`) and `T<:AbstractLogarithmic`. These are the same as without the `T` argument except the return type is `T`.

Internally they call `Dlogcdf(args...)` etc.

```julia
julia> normcdf(ULogarithmic, 1, 1, 0)
exp(-1.841021645009264)
```