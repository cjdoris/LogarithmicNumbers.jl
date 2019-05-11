# construct by exponentiation
"""
    exp(T<:AbstractLogarithmic, x)

The number `exp(x)` represented as a `T`.
"""
exp(::Type{E} where {E<:(AbstractLogarithmic{T} where {T})}, x::Real)

exp(::Type{ULogarithmic{T}}, x::Real) where {T<:Real} = exp(ULogarithmic{T}, convert(T, x))
exp(::Type{ULogarithmic}, x::T) where {T<:Real} = exp(ULogarithmic{T}, x)

exp(::Type{Logarithmic{T}}, x::Real) where {T<:Real} = Logarithmic{T}(exp(ULogarithmic{T}, x))
exp(::Type{Logarithmic}, x::T) where {T<:Real} = Logarithmic{T}(exp(ULogarithmic{T}, x))

exp(::Type{AbstractLogarithmic{T}}, x::Real) where {T<:Real} = exp(ULogarithmic{T}, x)
exp(::Type{AbstractLogarithmic}, x::Real) = exp(ULogarithmic, x)

# convenience
uexp(x) = exp(ULogarithmic, x)
uexp(T,x) = exp(ULogarithmic{T}, x)

# convert to ULogarithmic
ULogarithmic{T}(x::Real) where {T<:Real} = exp(ULogarithmic{T}, log(x))
ULogarithmic{T}(x::ULogarithmic{T}) where {T<:Real} = x

ULogarithmic(x::Real) = exp(ULogarithmic, log(x))

AbstractLogarithmic{T}(x::Real) where {T<:Real} = ULogarithmic{T}(x)
AbstractLogarithmic(x::T) where {T<:Real} = ULogarithmic(x)

# convert to Logarithmic
Logarithmic{T}(x::Real) where {T<:Real} = Logarithmic{T}(ULogarithmic{T}(abs(x)), signbit(x))
Logarithmic{T}(x::Logarithmic{T}) where {T<:Real} = x
Logarithmic{T}(abs::ULogarithmic, signbit::Bool=false) where {T<:Real} = Logarithmic{T}(ULogarithmic{T},(abs), signbit)

Logarithmic(x::Real) where {T<:Real} = Logarithmic(ULogarithmic(abs(x)), signbit(x))
Logarithmic(abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} = Logarithmic{T}(abs, signbit)