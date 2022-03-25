# LogarithmicNumbers.jl

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://docs.juliahub.com/LogarithmicNumbers)
[![Test Status](https://github.com/cjdoris/LogarithmicNumbers.jl/workflows/Tests/badge.svg)](https://github.com/cjdoris/LogarithmicNumbers.jl/actions?query=workflow%3ATests)
[![codecov](https://codecov.io/gh/cjdoris/LogarithmicNumbers.jl/branch/main/graph/badge.svg?token=AECCWGKRVJ)](https://codecov.io/gh/cjdoris/LogarithmicNumbers.jl)

A [logarithmic number system](https://en.wikipedia.org/wiki/Logarithmic_number_system) for
Julia.

Provides the signed `ULogarithmic` and unsigned `Logarithmic` types for representing real
numbers on a logarithmic scale.

This is useful when numbers are too big or small to fit accurately into a `Float64` and you
only really care about magnitude.

For example, it can be useful to represent probabilities in this form, and you don't need to
worry about getting zero when multiplying many of them together.

## Installation

```
pkg> add LogarithmicNumbers
```

## Example

```julia
julia> using LogarithmicNumbers

julia> ULogarithmic(2.7)
exp(0.9932517730102834)

julia> float(ans)
2.7

julia> x = exp(ULogarithmic, 1000) - exp(ULogarithmic, 998)
exp(999.8545865421312)

julia> float(x) # overflows
Inf

julia> log(x)
999.8545865421312
```

## Documentation

These types are exported:
* `ULogarithmic{T}` represents a non-negative real number by its logarithm of type `T`.
* `Logarithmic{T}` represents a real number by its absolute value as a `ULogarithmic{T}` and
  a sign bit.
* `LogFloat64` is an alias for `Logarithmic{Float64}`. There are also `ULogFloat16`,
  `ULogFloat32`, `ULogFloat64`, `LogFloat16`, and `LogFloat32`.

Constructors:
* `ULogarithmic(x)` and `Logarithmic(x)` represent the number `x`.
* `exp(ULogarithmic, x)` represents `exp(x)`, and `x` can be huge.

Functions in Base:
* Arithmetic: `+`, `-`, `*`, `/`, `^`, `inv`, `prod`, `sum`.
* Ordering: `==`, `<`, `≤`, `cmp`, `isless`, `isequal`, `sign`, `signbit`, `abs`.
* Logarithm: `log`, `log2`, `log10`, `log1p`.
* Conversion: `float`, `unsigned`, `signed`, `widen`, `big`. These also operate on types.
* Special values: `zero`, `one`, `typemin`, `typemax`.
* Predicates: `iszero`, `isone`, `isinf`, `isfinite`, `isnan`.
* IO: `show`, `write`, `read`.
* Random: `rand(ULogarithmic)` is a random number in the unit interval.
* Misc: `nextfloat`, `prevfloat`, `hash`.
* Note: Any functions not mentioned here might be inaccurate.

## Interoperability with other packages

We overload some functions `f` so that `f(ULogarithmic, ...)` is the same as `f(...)` but
the answer is returned as a `ULogarithmic`. Internally it calls an accurate log version of
the function.

### [StatsFuns.jl](https://github.com/JuliaStats/StatsFuns.jl)

- `normpdf(ULogarithmic, ...)`
- `normcdf(ULogarithmic, ...)`
- `normccdf(ULogarithmic, ...)`
- Plus equivalents for other distributions.

### [Distributions.jl](https://github.com/JuliaStats/Distributions.jl)

- `pdf(ULogarithmic, ...)`
- `cdf(ULogarithmic, ...)`
- `ccdf(ULogarithmic, ...)`

### [SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl)

- `gamma(ULogarithmic, ...)`
- `factorial(ULogarithmic, ...)`
- `beta(ULogarithmic, ...)`
- `erfc(ULogarithmic, ...)`
- `erfcx(ULogarithmic, ...)`
