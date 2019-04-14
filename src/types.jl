"""
    Logarithmic(x)

Represents the positive real number `x` by storing its logarithm.

!!! tip
    If you know `lx=log(x)` then use [`exp(Logarithmic, lx)`](@ref Base.exp(::Type{Logarithmic},::Real)) instead.
"""
struct Logarithmic{T<:Real} <: Real
  log::T
  Logarithmic{T}(::Val{:INNER}, x::T) where {T} = new(x)
end


"""
    SLogarithmic(x)

Represents the real number `x` by storing its absolute value as a `Logarithmic` and its sign bit.

!!! tip
    If you know `lx=log(abs(x))` then use [`exp(SLogarithmic, lx, signbit)`](@ref Base.exp(::Type{SLogarithmic},::Real)) instead.
"""
struct SLogarithmic{T<:Real} <: Real
  abs::Logarithmic{T}
  signbit::Bool
  SLogarithmic{T}(::Val{:INNER}, abs::Logarithmic{T}, signbit::Bool=false) where {T<:Real} = new(abs, signbit)
end

