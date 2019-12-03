Base.@pure addtype(T) = typeof(zero(T)+log1p(exp(zero(T))))

# generic

exp(x::AnyLog) = uexp(x)

# ULogarithmic

log(x::ULogarithmic) = x.log
# *(x::ULogarithmic{T}, y::ULogarithmic{T}, rest::ULogarithmic{T}...) where {T} = uexp(T, +(log.((x, y, rest...))...))
*(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} = uexp(x.log + y.log)
/(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} = uexp(x.log - y.log)
^(x::ULogarithmic, n::Real) = uexp(x.log * n)
^(x::ULogarithmic, n::Integer) = uexp(x.log * n)
inv(x::ULogarithmic{T}) where {T} = uexp(-x.log)
+(x::ULogarithmic{T}) where {T} = uexp(addtype(T), x.log)
+(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} =
	let xlog=x.log, ylog=y.log
		uexp(addtype(T), if xlog == ylog
			xlog + log1p(one(T))
		elseif xlog ≥ ylog
			xlog + log1p(exp(ylog - xlog))
		else
			ylog + log1p(exp(xlog - ylog))
		end)
	end
-(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} =
	let xlog=x.log, ylog=y.log
		uexp(addtype(T), if xlog ≥ ylog
			if iszero(x)
				xlog
			else
				xlog + log1p(-exp(ylog - xlog))
			end
		else
			throw(DomainError((x, y), "difference is negative"))
		end)
	end

# Logarithmic

-(x::Logarithmic) = Logarithmic(x.abs, !x.signbit)
log(x::Logarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); log(x.abs))
*(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = Logarithmic(x.abs * y.abs, x.signbit ⊻ y.signbit)
/(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = Logarithmic(x.abs / y.abs, x.signbit ⊻ y.signbit)
^(x::Logarithmic, n::Integer) = Logarithmic(x.abs^n, x.signbit & isodd(n))
^(x::Logarithmic, n::Real) = (x.signbit && !iszero(x) && throw(DomainError(x)); Logarithmic(x.abs^n))
inv(x::Logarithmic{T}) where {T} = Logarithmic(inv(x.abs), x.signbit)
+(x::Logarithmic) = Logarithmic(+x.abs, x.signbit)
+(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = x.signbit==y.signbit ? Logarithmic(x.abs + y.abs, x.signbit) : x.abs ≥ y.abs ? Logarithmic(x.abs - y.abs, x.signbit) : Logarithmic(y.abs - x.abs, y.signbit)
-(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = x.signbit==y.signbit ? x.abs ≥ y.abs ? Logarithmic(x.abs - y.abs, x.signbit) : Logarithmic(y.abs - x.abs, !y.signbit) : Logarithmic(x.abs + y.abs, x.signbit)

# CLogarithmic

log(x::CLogarithmic) = Complex(x.abs.log, x.angle)
conj(x::CLogarithmic) = CLogarithmic(x.abs, -x.angle)
*(x::CLogarithmic{T}, y::CLogarithmic{T}) where {T} = 
	CLogarithmic(x.abs * y.abs, x.angle + y.angle)
/(x::CLogarithmic{T}, y::CLogarithmic{T}) where {T} =
	CLogarithmic(x.abs / y.abs, x.angle - y.angle)
^(x::CLogarithmic, n::Integer) = CLogarithmic(x.abs^n, x.angle*n)
^(x::CLogarithmic, n::Real) = CLogarithmic(x.abs^n, x.angle*n)
inv(x::CLogarithmic) = CLogarithmic(inv(x.abs), -x.angle)
+(x::CLogarithmic) = CLogarithmic(+x.abs, x.angle)
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
