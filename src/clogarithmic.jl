# conversion
float(x::CLogarithmic) = Complex(exp(Complex(float(x.abs.log), float(x.angle))))
(::Type{T})(x::CLogarithmic) where {T<:AbstractFloat} = (y=float(x.abs); T(iszero(x.angle) ? y : x.angle≈π ? -y : throw(DomainError(x))))
(::Type{T})(x::CLogarithmic) where {T<:Complex} = T(exp(Complex(x.abs.log, x.angle)))
big(x::CLogarithmic) = CLogarithmic(big(x.abs), big(x.angle))

# type functions
widen(::Type{CLogarithmic{T}}) where {T} = CLogarithmic{widen(T)}
big(::Type{CLogarithmic{T}}) where {T} = CLogarithmic{big(T)}

# special values
zero(::Type{CLogarithmic{T}}) where {T} = CLogarithmic(zero(ULogarithmic{T}))
one(::Type{CLogarithmic{T}}) where {T} = CLogarithmic(one(ULogarithmic{T}))

# predicates
iszero(x::CLogarithmic) = iszero(x.abs)
isone(x::CLogarithmic) = isone(x.abs) && iszero(x.angle)
isinf(x::CLogarithmic) = isinf(x.abs)
isfinite(x::CLogarithmic) = isfinite(x.abs)
isnan(x::CLogarithmic) = isnan(x.abs)

# sign
sign(x::CLogarithmic{T}) where {T} = iszero(x) ? zero(x) : CLogarithmic{T}(uexp(T,0), x.angle)
abs(x::CLogarithmic) = x.abs
angle(x::CLogarithmic) = x.angle
real(x::CLogarithmic) = x.abs * cos(x.angle)
imag(x::CLogarithmic) = x.abs * sin(x.angle)

# ordering
(==)(x::CLogarithmic, y::CLogarithmic) = x.abs==y.abs && x.angle==y.angle
isequal(x::CLogarithmic, y::CLogarithmic) = isequal(x.abs, y.abs) && isequal(x.angle, y.angle)
