# Guide

## Installation

Type `]` to enter package mode and run

```
pkg> install LogarithmicNumbers
```

## Interface

The types [`ULogarithmic`](@ref) and [`Logarithmic`](@ref) are exported. These are subtypes of the abstract type `AbstractLogarithmic <: Real` and support arithmetic, ordering and most other related functionality.

There are also type aliases `ULogFloat64`, `LogFloat64`, `ULogFloat32`, `LogFloat32`, `ULogFloat16`, `LogFloat16`, `ULogBigFloat`, `LogBigFloat`.

```@docs
AbstractLogarithmic
ULogarithmic
Logarithmic
exp(::Type{AbstractLogarithmic},::Real)
```
