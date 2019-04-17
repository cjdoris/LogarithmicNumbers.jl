# LogarithmicNumbers.jl

A [logarithmic number system](https://en.wikipedia.org/wiki/Logarithmic_number_system) for Julia.

Provides the [`ULogarithmic`](@ref) and [`Logarithmic`](@ref) subtypes of `Real` for representing real numbers in log-space.

## Features

* `ULogarithmic(x)` and `Logarithmic(x)` represent the number `x`.
* `exp(ULogarithmic, x)` and `exp(Logarithmic, x)` represent `exp(x)` (and `x` can be huge).
* Arithmetic: plus, minus, times, divide, power, `inv`, `log`, `prod`, `sum`.
* Comparisons: equality and ordering.
* Random: `rand(ULogarithmic)` and `rand(Logarithmic)` produces a random number in the unit interval.
* Other functions: `float`, `big`, `unsigned` (converts `ULogarithmic` to `Logarithmic`), `signed` (vice versa), `widen`, `typemin`, `typemax`, `zero`, `one`, `iszero`, `isone`, `isinf`, `isfinite`, `isnan`, `sign`, `signbit`, `abs`, `nextfloat`, `prevfloat`, `write`, `read`.

## Example
```
julia> using LogarithmicNumbers

julia> ULogarithmic(2.7)
exp(0.9932517730102834)

julia> float(ans)
2.7

julia> x = exp(ULogarithmic, 1000) - exp(ULogarithmic, 998)
exp(999.8545865421312)

julia> float(x) # overflows Float64
Inf

julia> log(x)
999.8545865421312
```

