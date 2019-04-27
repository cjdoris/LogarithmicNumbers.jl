# conversion
float(x::ULogarithmic) = exp(float(x.log))
big(x::ULogarithmic{T}) where {T} = uexp(big(x.log))
unsigned(x::ULogarithmic) = x
signed(x::ULogarithmic) = Logarithmic(x)

# type functions
widen(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{widen(T)}
big(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{big(T)}
typemin(::Type{ULogarithmic{T}}) where {T} = uexp(typemin(T))
typemax(::Type{ULogarithmic{T}}) where {T} = uexp(typemax(T))
unsigned(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{T}
signed(::Type{ULogarithmic{T}}) where {T} = Logarithmic{T}

# special values
zero(::Type{ULogarithmic{T}}) where {T} = uexp(T, -Inf)
one(::Type{ULogarithmic{T}}) where {T} = uexp(T, zero(T))

# predicates
iszero(x::ULogarithmic) = isinf(x.log) && signbit(x.log)
isone(x::ULogarithmic) = iszero(x.log)
isinf(x::ULogarithmic) = isinf(x.log) && !signbit(x.log)
isfinite(x::ULogarithmic) = !isinf(x)
isnan(x::ULogarithmic) = isnan(x.log)

# sign
sign(x::ULogarithmic) = iszero(x) ? zero(x) : one(x)
signbit(x::ULogarithmic) = false
abs(x::ULogarithmic) = x

# ordering
(==)(x::ULogarithmic, y::ULogarithmic) = x.log == y.log
<(x::ULogarithmic, y::ULogarithmic) = x.log < y.log
≤(x::ULogarithmic, y::ULogarithmic) = x.log ≤ y.log
cmp(x::ULogarithmic, y::ULogarithmic) = cmp(x.log, y.log)

# epsilon
nextfloat(x::ULogarithmic) = uexp(nextfloat(x.log))
prevfloat(x::ULogarithmic) = uexp(prevfloat(x.log))
