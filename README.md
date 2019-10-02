# LogarithmicNumbers.jl

A [logarithmic number system](https://en.wikipedia.org/wiki/Logarithmic_number_system) for Julia.

Provides the types `ULogarithmic`, `Logarithmic` and `CLogarithmic` for representing non-negative real numbers, real numbers and complex numbers in log-space.

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

Three main types are exported:
* Type `ULogarithmic{T}`, which represents a non-negative real number by its logarithm of type `T`.
* Type `Logarithmic{T}`, which represents a real number by its absolute value as a `ULogarithmic{T}` and a sign bit.
* Type `CLogarithmic{T}`, which represents a complex number by its absolute value as a `ULogarithmic{T}` and an angle of type `T`.

Also exports type aliases `ULogFloat64`, `LogFloat64`, `CLogFloat64`, `ULogFloat32`, `LogFloat32`, `CLogFloat32`, `ULogFloat16`, `LogFloat16`, `CLogFloat16`, `ULogBigFloat`, `LogBigFloat`, `CLogBigFloat`.

Features:
* `ULogarithmic(x)` (and `Logarithmic(x)`, etc.) represents the number `x`.
* `exp(ULogarithmic, x)` represents `exp(x)` (and `x` can be huge).
* Arithmetic: `+`, `-`, `*`, `/`, `^`, `inv`, `log`, `prod`, `sum`.
* Comparisons: equality, ordering, `cmp`, `isless`.
* Random: `rand(ULogarithmic)` is a random number in the unit interval.
* Other functions: `float`, `big`, `unsigned` (converts `ULogarithmic` to `Logarithmic`), `signed` (vice versa), `widen`, `typemin`, `typemax`, `zero`, `one`, `iszero`, `isone`, `isinf`, `isfinite`, `isnan`, `sign`, `signbit`, `abs`, `nextfloat`, `prevfloat`, `write`, `read`.

## Interoperability with other packages

### StatsFuns.jl

Calling `normcdf(ULogarithmic, ...)` is like calling `normcdf(...)` but returns the answer as a `ULogarithmic` (and calls `normlogcdf(...)` internally).

Similarly there is `normpdf(ULogarithmic, ...)` and `normccdf(ULogarithmic, ...)` and equivalents for other distributions.

### Distributions.jl

Calling `cdf(ULogarithmic, ...)` is like calling `cdf(...)` but returns the answer as a `ULogarithmic` (and calls `logcdf(...)` internally).

Similarly there is `ccdf(ULogarithmic, ...)` and `pdf(ULogarithmic, ...)`.
