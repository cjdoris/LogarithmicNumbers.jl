# LogarithmicNumbers.jl

A [**logarithmic number system**](https://en.wikipedia.org/wiki/Logarithmic_number_system)
for Julia.

Provides the signed `Logarithmic` and unsigned `ULogarithmic` types for representing real
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

### Exported types
* `ULogarithmic{T}` represents a non-negative real number by its logarithm of type `T`.
* `Logarithmic{T}` represents a real number by its absolute value as a `ULogarithmic{T}` and
  a sign bit.
* `LogFloat64` is an alias for `Logarithmic{Float64}`. There are also `ULogFloat16`,
  `ULogFloat32`, `ULogFloat64`, `LogFloat16`, and `LogFloat32`.

### Constructors
* `ULogarithmic(x)` and `Logarithmic(x)` represent the number `x`.
* `exp(ULogarithmic, logx)` represents `exp(logx)`, and `logx` can be huge. Use this when
  you already know the logarithm `logx` of your number `x`.

### Functions in Base
* **Arithmetic:** `+`, `-`, `*`, `/`, `^`, `inv`, `prod`, `sum`, `sqrt`, `cbrt`, `fourthroot`.
* **Ordering:** `==`, `<`, `≤`, `cmp`, `isless`, `isequal`, `sign`, `signbit`, `abs`.
* **Logarithm:** `log`, `log2`, `log10`, `log1p`. These are returned as the base (non-logarithmic) type.
* **Conversion:** `float`, `unsigned`, `signed`, `widen`, `big`. These also operate on types.
* **Special values:** `zero`, `one`, `typemin`, `typemax`.
* **Predicates:** `iszero`, `isone`, `isinf`, `isfinite`, `isnan`.
* **IO:** `show`, `write`, `read`.
* **Random:** `rand(ULogarithmic)` is a random number in the unit interval.
* **Misc:** `nextfloat`, `prevfloat`, `hash`.
* **Note:** Any functions not mentioned here might be inaccurate.

### Interoperability with other packages

It is natural to use this package in conjunction with other packages which return
logarithms. The general pattern is that you can use `exp(ULogarithmic, logfunc(args...))`
instead of `func(args...)` to get the answer as a logarithmic number. Here are some
possibilities for `func`:

- [StatsFuns.jl](https://github.com/JuliaStats/StatsFuns.jl):
  `normpdf`, `normcdf`, `normccdf`, plus equivalents for other distributions.
- [Distributions.jl](https://github.com/JuliaStats/Distributions.jl):
  `pdf`, `cdf`, `ccdf`.
- [SpecialFunctions.jl](https://github.com/JuliaMath/SpecialFunctions.jl):
  `gamma`, `factorial`, `beta`, `erfc`, `erfcx`.

### Autodiff

On Julia >= 1.9, if you load [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl), you should be allowed to compute

- derivatives of functions involving `exp(Logarithmic, x)`
- derivatives of functions evaluated at `Logarithmic(x)`

This functionality is experimental, please report any bug or unexpected behavior.
