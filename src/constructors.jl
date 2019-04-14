# main interface to inner constructor
exp(::Type{T}, x::T) where {T<:Real} = Logarithmic{T}(Val{:INNER}(), x)
exp(::Type{T}, x::Real) where {T} = exp(T, convert(T, x))
exp(::Type{T}, x::Union{Logarithmic,SLogarithmic}) where {T} = error("I don't think you meant to do that")
exptoexp(::Type{T}, x::Logarithmic{T}) where {T<:Real} = x
exptoexp(::Type{T}, x::Logarithmic) where {T} = exp(T, x.log)
exptosexp(::Type{T}, x::Logarithmic{T}, signbit::Bool=false) where {T<:Real} = SLogarithmic{T}(Val{:INNER}(), x, signbit)
exptosexp(::Type{T}, x::Logarithmic, signbit::Bool=false) where {T} = exptosexp(T, exptoexp(T, x), signbit)
sexp(::Type{T}, x::T) where {T<:Real} = exptosexp(T, exp(T, x))
sexp(::Type{T}, x::Real) where {T} = sexp(T, convert(T, x))
sexp(::Type{T}, x::Union{Logarithmic,SLogarithmic}) where {T} = error("I don't think you meant to do that")

# construct from log
exp(x::T) where {T} = exp(T, x)
sexp(x::T) where {T} = sexp(T, x)

# overload Base.exp
"""
    exp(Logarithmic, x)

The number `exp(x)` represented as an `Logarithmic`.
"""
Base.exp(::Type{Logarithmic}, x::Real) = exp(x)
Base.exp(::Type{Logarithmic{T}}, x::Real) where {T} = exp(T, x)

"""
    exp(SLogarithmic, x)

The number `exp(x)` represented as a `SLogarithmic`.
"""
Base.exp(::Type{SLogarithmic}, x::Real) = sexp(x)
Base.exp(::Type{SLogarithmic{T}}, x::Real) where {T} = sexp(T, x)

# construct from value
Logarithmic{T}(x::Real) where {T} = exp(T, log(x))
Logarithmic{T}(x::Logarithmic{T}) where {T} = x
Logarithmic(x::Real) = exp(log(x))
Logarithmic(x::Logarithmic) = x
SLogarithmic{T}(x::Logarithmic{R}, signbit::Bool=false) where {T,R} = exptosexp(T, Logarithmic{T}(x), signbit)
SLogarithmic{T}(x::Real) where {T} = exptosexp(T, Logarithmic{T}(abs(x)), signbit(x))
SLogarithmic{T}(x::SLogarithmic{T}) where {T} = x
SLogarithmic(x::Logarithmic{T}, signbit::Bool=false) where {T} = exptosexp(T, x, signbit)
SLogarithmic(x::Real) = SLogarithmic(Logarithmic(abs(x)), signbit(x))
SLogarithmic(x::SLogarithmic) = x
