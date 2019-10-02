# construct by exponentiation
"""
    exp(T, x)

The number `exp(x)` represented as a `T`.
"""
exp(::Type{T} where {T<:AnyLog}, x::Real)

exp(::Type{ULogarithmic{T}}, x::Real) where {T<:Real} =
	exp(ULogarithmic{T}, convert(T, x))

exp(::Type{ULogarithmic}, x::T) where {T<:Real} =
	exp(ULogarithmic{T}, x)

exp(::Type{Logarithmic{T}}, x::Real) where {T<:Real} =
	Logarithmic{T}(exp(ULogarithmic{T}, x))

exp(::Type{Logarithmic}, x::T) where {T<:Real} =
	exp(Logarithmic{T}, x)

exp(::Type{CLogarithmic{T}}, x::Union{Real,Complex}) where {T<:Real} =
	CLogarithmic{T}(exp(ULogarithmic{T}, real(x)), imag(x))

exp(::Type{CLogarithmic}, x::T) where {T<:Real} =
	exp(CLogarithmic{T}, x)

exp(::Type{CLogarithmic}, x::Complex{T}) where {T<:Real} =
	exp(CLogarithmic{T}, x)

# convenience
uexp(x) = exp(ULogarithmic, x)
uexp(T,x) = exp(ULogarithmic{T}, x)

# convert to ULogarithmic
ULogarithmic{T}(x::Real) where {T<:Real} = exp(ULogarithmic{T}, log(x))

ULogarithmic{T}(x::ULogarithmic{T}) where {T<:Real} = x

ULogarithmic(x::Real) = exp(ULogarithmic, log(x))

ULogarithmic(x::ULogarithmic) = x

# convert to Logarithmic

Logarithmic{T}(x::Real) where {T<:Real} =
	Logarithmic{T}(ULogarithmic{T}(abs(x)), signbit(x))

Logarithmic{T}(x::Logarithmic{T}) where {T<:Real} = x

Logarithmic{T}(abs::ULogarithmic, signbit::Bool=false) where {T<:Real} =
	Logarithmic{T}(ULogarithmic{T}(abs), signbit)

Logarithmic(x::Real) =
	Logarithmic(ULogarithmic(abs(x)), signbit(x))

Logarithmic(abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} =
	Logarithmic{T}(abs, signbit)

Logarithmic(x::Logarithmic) = x

# convert to CLogarithmic

CLogarithmic{T}(x::Union{Real,Complex}) where {T<:Real} =
	CLogarithmic{T}(ULogarithmic{T}(abs(x)), convert(T, angle(x)))

CLogarithmic{T}(x::CLogarithmic{T}) where {T<:Real} = x

CLogarithmic{T}(x::CLogarithmic) where {T<:Real} =
	CLogarithmic{T}(x.abs, x.angle)

CLogarithmic{T}(abs::ULogarithmic, angle::Real=zero(T)) where {T<:Real} =
	CLogarithmic{T}(ULogarithmic{T}(abs), convert(T, angle))

CLogarithmic(x::Union{Real,Complex}) =
	CLogarithmic(ULogarithmic(abs(x)), angle(x))

CLogarithmic(abs::ULogarithmic{T}, angle::A=zero(T)) where {T<:Real, A<:Real} =
	CLogarithmic{promote_type(T,A)}(abs, angle)
