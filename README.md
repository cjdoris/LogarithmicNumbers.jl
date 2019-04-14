# LogarithmicNumbers.jl

Implements the `Logarithmic` type, a subtype of `Real` which represents positive numbers by their logarithm.

This is useful when numbers are too big or small to fit accurately into a `Float64` and you only really care about magnitude.

For example, it can be useful to represent probabilities in this form, and you don't need to worry about getting zero when multiplying many of them together.

## Example
```
julia> using LogarithmicNumbers

julia> Logarithmic(2.7) # represent 2.7 as a Logarithmic number
exp(0.9932517730102834)

julia> float(ans)
2.7

julia> x = exp(Logarithmic, 1000) - exp(Logarithmic, 998) # arithmetic with e.g. exp(1000) as a Logarithmic number
exp(999.8545865421312)

julia> float(x) # overflows
Inf

julia> log(x)
999.8545865421312
```

## Interface

Two things are exported:
* Type `Logarithmic{T}`, which represents a positive real number by its logarithm of type `T`.
* Type `SLogarithmic{T}` (signed), which represents a real number by its absolute value as a `Logarithmic{T}` and a sign bit.

Features:
* `Logarithmic(x)` represents the number `x`.
* `exp(Logarithmic, x)` represents `exp(x)` (and `x` can be huge).
* Arithmetic: plus, minus, times, divide, power, `inv`, `log`, `prod`, `sum`.
* Comparisons: equality and ordering.
* Random: `rand(Logarithmic)` produces a random number in the unit interval.
* Other functions: `float`, `big`, `unsigned` (converts `Logarithmic` to `SLogarithmic`), `signed` (vice versa), `widen`, `typemin`, `typemax`, `zero`, `one`, `iszero`, `isone`, `isinf`, `isfinite`, `isnan`, `sign`, `signbit`, `abs`, `nextfloat`, `prevfloat`, `write`, `read`.

## Distributions.jl

If `D` is a distribution, then `cdf(Logarithmic, D, x)` computes the `cdf` of `D` at `x` as a `Logarithmic` number. Internally it calls `logcdf(D, x)`.

Similarly there is `ccdf(Logarithmic, D, x)` and `pdf(Logarithmic, D, x)`.
