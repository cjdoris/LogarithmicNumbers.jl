# main interface to inner constructor
exp(::Type{T}, x::T) where {T<:Real} = ULogarithmic{T}(Val{:INNER}(), x)
exp(::Type{T}, x::Real) where {T} = exp(T, convert(T, x))
exp(::Type{T}, x::Union{ULogarithmic,Logarithmic}) where {T} = error("I don't think you meant to do that")
exptoexp(::Type{T}, x::ULogarithmic{T}) where {T<:Real} = x
exptoexp(::Type{T}, x::ULogarithmic) where {T} = exp(T, x.log)
exptosexp(::Type{T}, x::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} = Logarithmic{T}(Val{:INNER}(), x, signbit)
exptosexp(::Type{T}, x::ULogarithmic, signbit::Bool=false) where {T} = exptosexp(T, exptoexp(T, x), signbit)
sexp(::Type{T}, x::T) where {T<:Real} = exptosexp(T, exp(T, x))
sexp(::Type{T}, x::Real) where {T} = sexp(T, convert(T, x))
sexp(::Type{T}, x::Union{ULogarithmic,Logarithmic}) where {T} = error("I don't think you meant to do that")

# construct from log
exp(x::T) where {T} = exp(T, x)
sexp(x::T) where {T} = sexp(T, x)

# overload Base.exp
"""
    exp(ULogarithmic, x)

The number `exp(x)` represented as a [`ULogarithmic`](@ref).
"""
Base.exp(::Type{ULogarithmic}, x::Real) = exp(x)
Base.exp(::Type{ULogarithmic{T}}, x::Real) where {T} = exp(T, x)

"""
    exp(Logarithmic, x)

The number `exp(x)` represented as a [`Logarithmic`](@ref).
"""
Base.exp(::Type{Logarithmic}, x::Real) = sexp(x)
Base.exp(::Type{Logarithmic{T}}, x::Real) where {T} = sexp(T, x)

# construct from value
ULogarithmic{T}(x::Real) where {T} = exp(T, log(x))
ULogarithmic{T}(x::ULogarithmic{T}) where {T} = x
ULogarithmic(x::Real) = exp(log(x))
ULogarithmic(x::ULogarithmic) = x
Logarithmic{T}(x::ULogarithmic{R}, signbit::Bool=false) where {T,R} = exptosexp(T, ULogarithmic{T}(x), signbit)
Logarithmic{T}(x::Real) where {T} = exptosexp(T, ULogarithmic{T}(abs(x)), signbit(x))
Logarithmic{T}(x::Logarithmic{T}) where {T} = x
Logarithmic(x::ULogarithmic{T}, signbit::Bool=false) where {T} = exptosexp(T, x, signbit)
Logarithmic(x::Real) = Logarithmic(ULogarithmic(abs(x)), signbit(x))
Logarithmic(x::Logarithmic) = x
