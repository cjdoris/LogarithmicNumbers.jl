
"""
    ULogarithmic(x)

Represents the positive real number `x` by storing its logarithm.

!!! tip
    If you know `logx=log(x)` then use [`exp(ULogarithmic, logx)`](@ref exp(::Type{ULogarithmic},::Real)) instead.
"""
struct ULogarithmic{T} <: Real
  log::T
  Base.exp(::Type{ULogarithmic{T}}, x::T) where {T<:Real} = new{T}(x)
end


"""
    Logarithmic(x)

Represents the real number `x` by storing its absolute value as a [`ULogarithmic`](@ref) and its sign bit.

!!! tip
    If you know `logx=log(abs(x))` then use [`exp(Logarithmic, logx, signbit)`](@ref exp(::Type{Logarithmic},::Real)) instead.
"""
struct Logarithmic{T} <: Real
  abs::ULogarithmic{T}
  signbit::Bool
  Logarithmic{T}(abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} = new{T}(abs, signbit)
end

"""
    CLogarithmic(x)

Represents the complex number `x` by storing its absolute value as a [`ULogarithmic`](@ref) and its angle.

!!! tip
    If you know `logx=log(abs(x))` then use [`exp(ComplexLogarithmic, logx, angle)`](@ref exp(::Type{ComplexLogarithmic},::Real)) instead.
"""
struct CLogarithmic{T} <: Number
  abs :: ULogarithmic{T}
  angle :: T
  CLogarithmic{T}(abs::ULogarithmic{T}, angle::T=zero(T)) where {T<:Real} = new{T}(abs, angle)
end

# for convenience
const AnyLog{T} = Union{ULogarithmic{T}, Logarithmic{T}, CLogarithmic{T}}
const RealLog{T} = Union{ULogarithmic{T}, Logarithmic{T}}
