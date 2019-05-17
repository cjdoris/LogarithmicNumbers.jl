# LogarithmicNumbers.jl

A [logarithmic number system](https://en.wikipedia.org/wiki/Logarithmic_number_system) for Julia.

Provides two subtypes of `Real`: the unsigned `ULogarithmic`, representing a positive number in log-space; and signed `Logarithmic` which additionally has a sign bit.

This is useful when numbers are too big or small to fit accurately into a `Float64` and you only really care about magnitude.

For example, it can be useful to represent probabilities in this form, and you don't need to worry about getting zero when multiplying many of them together.

## Installation

Type `]` to open the package manager then execute

```
pkg> install LogarithmicNumbers
```

## Example
```
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

Two main types are exported:
* Type `ULogarithmic{T}`, which represents a positive real number by its logarithm of type `T`.
* Type `Logarithmic{T}` (signed), which represents a real number by its absolute value as a `ULogarithmic{T}` and a sign bit.

Also exports type aliases `ULogFloat64`, `LogFloat64`, `ULogFloat32`, `LogFloat32`, `ULogFloat16`, `LogFloat16`, `ULogBigFloat`, `LogBigFloat`.

Features:
* `ULogarithmic(x)` and `Logarithmic(x)` represent the number `x`.
* `exp(ULogarithmic, x)` and `exp(Logarithmic, x)` represent `exp(x)` (and `x` can be huge).
* Arithmetic: `+`, `-`, `*`, `/`, `^`, `inv`, `log`, `prod`, `sum`.
* Comparisons: equality, ordering, `cmp`, `isless`.
* Random: `rand(ULogarithmic)` and `rand(Logarithmic)` produces a random number in the unit interval.
* Other functions: `float`, `big`, `unsigned` (converts `ULogarithmic` to `Logarithmic`), `signed` (vice versa), `widen`, `typemin`, `typemax`, `zero`, `one`, `iszero`, `isone`, `isinf`, `isfinite`, `isnan`, `sign`, `signbit`, `abs`, `nextfloat`, `prevfloat`, `write`, `read`.

## Interoperability with other packages

## StatsFuns.jl

Calling `normcdf(ULogarithmic, ...)` is like calling `normcdf(...)` but returns the answer as a `ULogarithmic` (and calls `normlogcdf(...)` internally).

Similarly there is `normpdf(ULogarithmic, ...)` and `normccdf(ULogarithmic, ...)` and equivalents for other distributions.

### Distributions.jl

Calling `cdf(ULogarithmic, ...)` is like calling `cdf(...)` but returns the answer as a `ULogarithmic` (and calls `logcdf(...)` internally).

Similarly there is `ccdf(ULogarithmic, ...)` and `pdf(ULogarithmic, ...)`.
