log(x::ULogarithmic) = x.log
*(x::ULogarithmic{T}, y::ULogarithmic{T}, rest::ULogarithmic{T}...) where {T} = uexp(T, +(log.((x, y, rest...))...))
/(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} = uexp(T, x.log - y.log)
^(x::ULogarithmic, n::Real) = uexp(x.log * n)
^(x::ULogarithmic, n::Integer) = uexp(x.log * n)
inv(x::ULogarithmic{T}) where {T} = uexp(T, -x.log)
# +(x::ULogarithmic, y::ULogarithmic) = x.log ≥ y.log ? x * ULogarithmic(1 + float(y/x)) : y * ULogarithmic(float(x/y) + 1)
+(x::ULogarithmic{T}, y::ULogarithmic{T}, rest::ULogarithmic{T}...) where {T} = _add(x, y, rest...)
-(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} = (xlog=x.log; ylog=y.log; xlog<ylog && error("difference is negative"); uexp(xlog + log(1 - exp(ylog-xlog))))

@inline _add(xs::ULogarithmic{T}...) where {T} = (xlogs=log.(xs); maxlog=max(xlogs...); isinf(maxlog) ? uexp(maxlog)::typeof(uexp(maxlog + log(+(exp.(xlogs.-maxlog)...)))) : uexp(maxlog + log(+(exp.(xlogs.-maxlog)...))))

prod(xs::AbstractArray{<:ULogarithmic}) = uexp(sum(log.(xs)))
sum(xs::AbstractArray{<:ULogarithmic}) = (xlogs=log.(xs); maxlog=maximum(xlogs); isinf(maxlog) ? uexp(maxlog)::typeof(uexp(maxlog + log(sum(exp.(xlogs.-maxlog))))) : uexp(maxlog + log(sum(exp.(xlogs.-maxlog)))))

-(x::Logarithmic) = Logarithmic(x.abs, !x.signbit)
log(x::Logarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); log(x.abs))
*(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = Logarithmic{T}(x.abs * y.abs, x.signbit ⊻ y.signbit)
/(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = Logarithmic{T}(x.abs / y.abs, x.signbit ⊻ y.signbit)
^(x::Logarithmic, n::Integer) = Logarithmic(x.abs^n, x.signbit & isodd(n))
^(x::Logarithmic, n::Real) = (x.signbit && !iszero(x) && throw(DomainError(x)); Logarithmic(x.abs^n))
inv(x::Logarithmic{T}) where {T} = Logarithmic{T}(inv(x.abs), x.signbit)
+(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = x.signbit==y.signbit ? Logarithmic(x.abs + y.abs, x.signbit) : x.abs ≥ y.abs ? Logarithmic(x.abs - y.abs, x.signbit) : Logarithmic(y.abs - x.abs, y.signbit)
-(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = x.signbit==y.signbit ? x.abs ≥ y.abs ? Logarithmic(x.abs - y.abs, x.signbit) : Logarithmic(y.abs - x.abs, !y.signbit) : Logarithmic(x.abs + y.abs, x.signbit)

