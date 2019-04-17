"""
    ULogarithmic(x)

Represents the positive real number `x` by storing its logarithm.

!!! tip
    If you know `logx=log(x)` then use [`exp(ULogarithmic, lx)`](@ref Base.exp(::Type{ULogarithmic},::Real)) instead.
"""
struct ULogarithmic{T<:Real} <: Real
  log::T
  ULogarithmic{T}(::Val{:INNER}, x::T) where {T} = new(x)
end


"""
    Logarithmic(x)

Represents the real number `x` by storing its absolute value as a [`ULogarithmic`](@ref) and its sign bit.

!!! tip
    If you know `logx=log(abs(x))` then use [`exp(Logarithmic, logx)`](@ref Base.exp(::Type{Logarithmic},::Real)) instead.
"""
struct Logarithmic{T<:Real} <: Real
  abs::ULogarithmic{T}
  signbit::Bool
  Logarithmic{T}(::Val{:INNER}, abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} = new(abs, signbit)
end

