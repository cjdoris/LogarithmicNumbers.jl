# Guide

## Installation

Type `]` to enter package mode and run

```
pkg> install LogarithmicNumbers
```

## Interface

The types [`ULogarithmic`](@ref) and [`Logarithmic`](@ref) are exported. These are subtypes of `Real` and support arithmetic, ordering and most other related functionality.

There are also type aliases `ULogFloat64`, `LogFloat64`, `ULogFloat32`, `LogFloat32`, `ULogFloat16`, `LogFloat16`, `ULogBigFloat`, `LogBigFloat`.

```@docs
ULogarithmic
Logarithmic
Base.exp(::Type{ULogarithmic},::Real)
Base.exp(::Type{Logarithmic},::Real)
```
