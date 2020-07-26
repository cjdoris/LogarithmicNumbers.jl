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
	convert(Logarithmic{T}, exp(ULogarithmic{T}, x))

exp(::Type{Logarithmic}, x::T) where {T<:Real} =
	exp(Logarithmic{T}, x)

exp(::Type{CLogarithmic{T}}, x::Union{Real,Complex}) where {T<:Real} =
	CLogarithmic{T}(exp(ULogarithmic{T}, real(x)), T(imag(x)))

exp(::Type{CLogarithmic}, x::T) where {T<:Real} =
	exp(CLogarithmic{T}, x)

exp(::Type{CLogarithmic}, x::Complex{T}) where {T<:Real} =
	exp(CLogarithmic{T}, x)

# convenience
uexp(x) = exp(ULogarithmic, x)
uexp(T,x) = exp(ULogarithmic{T}, x)
