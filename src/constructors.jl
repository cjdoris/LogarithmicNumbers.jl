# main interface to inner constructor
uexp(::Type{T}, x::T) where {T<:Real} = ULogarithmic{T}(Val{:INNER}(), x)
uexp(::Type{T}, x::Real) where {T} = uexp(T, convert(T, x))
# uexp(::Type{T}, x::Union{ULogarithmic,Logarithmic}) where {T} = error("I don't think you meant to do that")
uexptouexp(::Type{T}, x::ULogarithmic{T}) where {T<:Real} = x
uexptouexp(::Type{T}, x::ULogarithmic) where {T} = uexp(T, x.log)
uexptosexp(::Type{T}, x::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} = Logarithmic{T}(Val{:INNER}(), x, signbit)
uexptosexp(::Type{T}, x::ULogarithmic, signbit::Bool=false) where {T} = uexptosexp(T, uexptouexp(T, x), signbit)
sexp(::Type{T}, x::T) where {T<:Real} = uexptosexp(T, uexp(T, x))
sexp(::Type{T}, x::Real) where {T} = sexp(T, convert(T, x))
# sexp(::Type{T}, x::Union{ULogarithmic,Logarithmic}) where {T} = error("I don't think you meant to do that")

# construct from log
uexp(x::T) where {T} = uexp(T, x)
sexp(x::T) where {T} = sexp(T, x)

# overload exp
"""
    exp(T<:AbstractLogarithmic, x)

The number `exp(x)` represented as a `T`.
"""
exp(::Type{E} where {E<:(AbstractLogarithmic{T} where {T})}, x::Real)

exp(::Type{AbstractLogarithmic}, x::Real) = uexp(x)
exp(::Type{AbstractLogarithmic{T}}, x::Real) where {T} = uexp(T, x)
exp(::Type{ULogarithmic}, x::Real) = uexp(x)
exp(::Type{ULogarithmic{T}}, x::Real) where {T} = uexp(T, x)
exp(::Type{Logarithmic}, x::Real) = sexp(x)
exp(::Type{Logarithmic{T}}, x::Real) where {T} = sexp(T, x)

# construct from value
AbstractLogarithmic{T}(x::Real) where {T} = Logarithmic{T}(x)
AbstractLogarithmic(x::Real) = Logarithmic(x)
ULogarithmic{T}(x::Real) where {T} = uexp(T, log(x))
ULogarithmic{T}(x::ULogarithmic{T}) where {T} = x
ULogarithmic(x::Real) = uexp(log(x))
ULogarithmic(x::ULogarithmic) = x
Logarithmic{T}(x::ULogarithmic{R}, signbit::Bool=false) where {T,R} = uexptosexp(T, ULogarithmic{T}(x), signbit)
Logarithmic{T}(x::Real) where {T} = uexptosexp(T, ULogarithmic{T}(abs(x)), signbit(x))
Logarithmic{T}(x::Logarithmic{T}) where {T} = x
Logarithmic(x::ULogarithmic{T}, signbit::Bool=false) where {T} = uexptosexp(T, x, signbit)
Logarithmic(x::Real) = Logarithmic(ULogarithmic(abs(x)), signbit(x))
Logarithmic(x::Logarithmic) = x
