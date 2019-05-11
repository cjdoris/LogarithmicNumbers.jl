"""
    AbstractLogarithmic{T}

Abstract logarithmic type, with subtypes [`ULogarithmic`](@ref) and [`Logarithmic`](@ref). Its logarithm is stored as a `T`.
"""
abstract type AbstractLogarithmic{T<:Real} <: Real end

ALog = AbstractLogarithmic{T} where {T}

"""
    ULogarithmic(x)

Represents the positive real number `x` by storing its logarithm.

!!! tip
    If you know `logx=log(x)` then use [`exp(ULogarithmic, logx)`](@ref exp(::Type{ULogarithmic},::Real)) instead.
"""
struct ULogarithmic{T} <: AbstractLogarithmic{T}
  log::T
  Base.exp(::Type{ULogarithmic{T}}, x::T) where {T<:Real} = new{T}(x)
end


"""
    Logarithmic(x)

Represents the real number `x` by storing its absolute value as a [`ULogarithmic`](@ref) and its sign bit.

!!! tip
    If you know `logx=log(abs(x))` then use [`exp(Logarithmic, logx)`](@ref exp(::Type{Logarithmic},::Real)) instead.
"""
struct Logarithmic{T} <: AbstractLogarithmic{T}
  abs::ULogarithmic{T}
  signbit::Bool
  Logarithmic{T}(abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} = new{T}(abs, signbit)
end
