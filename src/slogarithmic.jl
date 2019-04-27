# conversion
float(x::Logarithmic) = (y=float(x.abs); ifelse(x.signbit, -y, y))
big(x::Logarithmic) = Logarithmic(big(x.abs), x.signbit)
unsigned(x::Logarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); x.abs)
signed(x::Logarithmic) = x

# type functions
widen(::Type{Logarithmic{T}}) where {T} = Logarithmic{widen(T)}
big(::Type{Logarithmic{T}}) where {T} = Logarithmic{big(T)}
typemin(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}(typemax(ULogarithmic{T}), true)
typemax(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}(typemax(ULogarithmic{T}))
unsigned(::Type{Logarithmic{T}}) where {T} = ULogarithmic{T}
signed(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}

# special values
zero(::Type{Logarithmic{T}}) where {T} = Logarithmic(zero(ULogarithmic{T}))
one(::Type{Logarithmic{T}}) where {T} = Logarithmic(one(ULogarithmic{T}))

# predicates
iszero(x::Logarithmic) = iszero(x.abs)
isone(x::Logarithmic) = isone(x.abs) && !x.signbit
isinf(x::Logarithmic) = isinf(x.abs)
isfinite(x::Logarithmic) = isfinite(x.abs)
isnan(x::Logarithmic) = isnan(x.abs)

# sign
sign(x::Logarithmic) = (s=sign(x.abs); ifelse(x.signbit, -s, s))
signbit(x::Logarithmic) = x.signbit
abs(x::Logarithmic) = Logarithmic(x.abs)

# ordering
(==)(x::Logarithmic, y::Logarithmic) = (iszero(x) && iszero(y)) || (x.abs==y.abs && x.signbit==y.signbit)
<(x::Logarithmic, y::Logarithmic) = x.signbit ? y.signbit ? (y.abs < x.abs) : !(iszero(x) && iszero(y)) : y.signbit ? (false) : (x.abs < y.abs)
≤(x::Logarithmic, y::Logarithmic) = x.signbit ? y.signbit ? (y.abs ≤ x.abs) : true : y.signbit ? (iszero(x) && iszero(y)) : (x.abs ≤ y.abs)

# epsilon
nextfloat(x::Logarithmic) = x.signbit && !iszero(x) ? Logarithmic(prevfloat(x.abs), true) : Logarithmic(nextfloat(x.abs))
prevfloat(x::Logarithmic) = x.signbit || iszero(x) ? Logarithmic(nextfloat(x.abs), true) : Logarithmic(prevfloat(x.abs))
