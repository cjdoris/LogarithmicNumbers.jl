
"""
    ULogarithmic(x)

Represents the positive real number `x` by storing its logarithm.

!!! tip
    If you know `logx=log(x)` then use [`exp(ULogarithmic, logx)`](@ref exp(::Type{ULogarithmic},::Real)) instead.
"""
struct ULogarithmic{T} <: Real
  log::T
end
Base.exp(::Type{ULogarithmic{T}}, x::T) where {T<:Real} = ULogarithmic{T}(x)
Base.convert(::Type{ULogarithmic}, x::T2) where {T2<:ULogarithmic} = x
Base.convert(::Type{ULogarithmic}, x::T2) where {T2<:Real} = convert(ULogarithmic{T2}, x)
Base.convert(::Type{ULogarithmic{T1}}, x::T2) where {T1<:Real, T2<:ULogarithmic} = ULogarithmic{T1}(T1(x.log))
Base.convert(::Type{ULogarithmic{T1}}, x::T2) where {T1<:Real, T2<:Real} = exp(ULogarithmic{T1}, log(x))

"""
    Logarithmic(x)

Represents the real number `x` by storing its absolute value as a [`ULogarithmic`](@ref) and its sign bit.

!!! tip
    If you know `logx=log(abs(x))` then use [`exp(Logarithmic, logx, signbit)`](@ref exp(::Type{Logarithmic},::Real)) instead.
"""
struct Logarithmic{T} <: Real
  abs::ULogarithmic{T}
  signbit::Bool
end

Base.convert(::Type{Logarithmic}, x::T2) where T2<:Number = convert(Logarithmic{T2}, x)
Base.convert(::Type{Logarithmic{T1}}, x::T2) where {T1<:Real, T2<:Logarithmic} = Logarithmic{T1}(convert(ULogarithmic{T1}, x.abs), x.signbit)
Base.convert(::Type{Logarithmic{T1}}, x::T2) where {T1<:Real, T2<:ULogarithmic} = Logarithmic{T1}(convert(ULogarithmic{T1}, x), false)
Base.convert(::Type{Logarithmic{T1}}, x::T2) where {T1<:Real, T2<:Real} = Logarithmic(convert(ULogarithmic{T1}, abs(x)), signbit(x))

"""
    CLogarithmic(x)

Represents the complex number `x` by storing its absolute value as a [`ULogarithmic`](@ref) and its angle.

!!! tip
    If you know `logx=log(abs(x))` then use [`exp(ComplexLogarithmic, logx, angle)`](@ref exp(::Type{ComplexLogarithmic},::Real)) instead.
"""
struct CLogarithmic{T} <: Number
  abs :: ULogarithmic{T}
  angle :: T
end

# for convenience
const AnyLog{T} = Union{ULogarithmic{T}, Logarithmic{T}, CLogarithmic{T}}
const RealLog{T} = Union{ULogarithmic{T}, Logarithmic{T}}

Base.convert(::Type{CLogarithmic}, x::T2) where T2<:Real = convert(CLogarithmic{T2}, x)
Base.convert(::Type{CLogarithmic}, x::Complex{T2}) where T2<:Number = convert(CLogarithmic{T2}, x)
Base.convert(::Type{CLogarithmic{T1}}, x::T2) where {T1<:Real, T2<:CLogarithmic} = CLogarithmic{T1}(convert(ULogarithmic{T1}, x.abs), x.angle)
Base.convert(::Type{CLogarithmic{T1}}, x::T2) where {T1<:Real, T2<:Logarithmic} = CLogarithmic{T1}(convert(ULogarithmic{T1}, x.abs), x.signbit ? zero(T1) : convert(T1, π))
Base.convert(::Type{CLogarithmic{T1}}, x::T2) where {T1<:Real, T2<:ULogarithmic} = CLogarithmic{T1}(convert(ULogarithmic{T1}, x), zero(T1))
Base.convert(::Type{CLogarithmic{T1}}, x::T2) where {T1<:Real, T2<:Number} = CLogarithmic(convert(ULogarithmic{T1}, abs(x)), angle(x))
