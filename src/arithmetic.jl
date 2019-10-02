# generic

exp(x::AnyLog) = uexp(x)

# ULogarithmic

log(x::ULogarithmic) = x.log
*(x::ULogarithmic{T}, y::ULogarithmic{T}, rest::ULogarithmic{T}...) where {T} = uexp(T, +(log.((x, y, rest...))...))
/(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} = uexp(T, x.log - y.log)
^(x::ULogarithmic, n::Real) = uexp(x.log * n)
^(x::ULogarithmic, n::Integer) = uexp(x.log * n)
inv(x::ULogarithmic{T}) where {T} = uexp(T, -x.log)
# +(x::ULogarithmic, y::ULogarithmic) = x.log ≥ y.log ? x * ULogarithmic(1 + float(y/x)) : y * ULogarithmic(float(x/y) + 1)
+(x::ULogarithmic{T}, y::ULogarithmic{T}, rest::ULogarithmic{T}...) where {T} = _add(x, y, rest...)
-(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} = (xlog=x.log; ylog=y.log; xlog<ylog && throw(DomainError((x,y), "difference is negative")); uexp(xlog - -log(1 - exp(-float(==(xlog, ylog) ? zero(xlog-ylog) : xlog-ylog)))))

@inline _add(xs::ULogarithmic{T}...) where {T} = (xlogs=log.(xs); maxlog=max(xlogs...); isinf(maxlog) ? uexp(maxlog)::typeof(uexp(maxlog + log(+(exp.(float.(xlogs.-maxlog))...)))) : uexp(maxlog + log(+(exp.(.-float.(maxlog.-xlogs))...))))

prod(xs::AbstractArray{<:ULogarithmic}) = uexp(sum(log.(xs)))
sum(xs::AbstractArray{<:ULogarithmic}) = (xlogs=log.(xs); maxlog=maximum(xlogs); isinf(maxlog) ? uexp(maxlog)::typeof(uexp(maxlog + log(sum(exp.(.-float.(maxlog.-xlogs)))))) : uexp(maxlog + log(sum(exp.(.-float.(maxlog.-xlogs))))))

# Logarithmic

-(x::Logarithmic) = Logarithmic(x.abs, !x.signbit)
log(x::Logarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); log(x.abs))
*(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = Logarithmic{T}(x.abs * y.abs, x.signbit ⊻ y.signbit)
/(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = Logarithmic{T}(x.abs / y.abs, x.signbit ⊻ y.signbit)
^(x::Logarithmic, n::Integer) = Logarithmic(x.abs^n, x.signbit & isodd(n))
^(x::Logarithmic, n::Real) = (x.signbit && !iszero(x) && throw(DomainError(x)); Logarithmic(x.abs^n))
inv(x::Logarithmic{T}) where {T} = Logarithmic{T}(inv(x.abs), x.signbit)
+(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = x.signbit==y.signbit ? Logarithmic(x.abs + y.abs, x.signbit) : x.abs ≥ y.abs ? Logarithmic(x.abs - y.abs, x.signbit) : Logarithmic(y.abs - x.abs, y.signbit)
-(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = x.signbit==y.signbit ? x.abs ≥ y.abs ? Logarithmic(x.abs - y.abs, x.signbit) : Logarithmic(y.abs - x.abs, !y.signbit) : Logarithmic(x.abs + y.abs, x.signbit)

# CLogarithmic

log(x::CLogarithmic) = Complex(x.abs.log, x.angle)
conj(x::CLogarithmic) = CLogarithmic(x.abs, -x.angle)
*(x::CLogarithmic{T}, y::CLogarithmic{T}) where {T} = 
	CLogarithmic{T}(x.abs * y.abs, x.angle + y.angle)
/(x::CLogarithmic{T}, y::CLogarithmic{T}) where {T} =
	CLogarithmic{T}(x.abs / y.abs, x.angle - y.angle)
^(x::CLogarithmic, n::Integer) = CLogarithmic(x.abs^n, x.angle*n)
^(x::CLogarithmic, n::Real) = CLogarithmic(x.abs^n, x.angle*n)
inv(x::CLogarithmic) = CLogarithmic(inv(x.abs), -x.angle)
+(x::CLogarithmic{T}, y::CLogarithmic{T}) where {T} =
	if isinf(x) && isinf(y) && x.angle ≈ y.angle
		t = exp(zero(Complex{T}))
		x * t
	elseif iszero(x) && iszero(y)
		t = exp(zero(Complex{T}))
		x * t
	elseif x.abs ≥ y.abs
		t = exp(Complex(y.abs.log-x.abs.log,y.angle-x.angle))
		t += one(t)
		x * t
	else
		t = exp(Complex(x.abs.log-y.abs.log,x.angle-y.angle))
		t += one(t)
		t * y
	end
-(x::CLogarithmic{T}, y::CLogarithmic{T}) where {T} =
	if iszero(x) && iszero(y)
		t = exp(zero(Complex{T}))
		x * t
	elseif x.abs ≥ y.abs
		t = exp(Complex(y.abs.log-x.abs.log,y.angle-x.angle))
		t = one(t) - t
		x * t
	else
		t = exp(Complex(x.abs.log-y.abs.log,x.angle-y.angle))
		t = t - one(t)
		t * y
	end
