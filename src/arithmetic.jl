Base.log(x::ULogarithmic) = x.log
Base.:*(x::ULogarithmic{T}, y::ULogarithmic{T}, rest::ULogarithmic{T}...) where {T} = exp(T, +(log.((x, y, rest...))...))
Base.:/(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} = exp(T, x.log - y.log)
Base.:^(x::ULogarithmic, n::Real) = exp(x.log * n)
Base.:^(x::ULogarithmic, n::Integer) = exp(x.log * n)
Base.inv(x::ULogarithmic{T}) where {T} = exp(T, -x.log)
# Base.:+(x::ULogarithmic, y::ULogarithmic) = x.log ≥ y.log ? x * ULogarithmic(1 + float(y/x)) : y * ULogarithmic(float(x/y) + 1)
Base.:+(x::ULogarithmic{T}, y::ULogarithmic{T}, rest::ULogarithmic{T}...) where {T} = _add(x, y, rest...)
Base.:-(x::ULogarithmic{T}, y::ULogarithmic{T}) where {T} = (xlog=x.log; ylog=y.log; xlog<ylog && error("difference is negative"); exp(xlog + log(1 - Base.exp(ylog-xlog))))

@inline _add(xs::ULogarithmic{T}...) where {T} = (xlogs=log.(xs); maxlog=max(xlogs...); isinf(maxlog) ? exp(maxlog)::typeof(exp(maxlog + log(+((Base.exp).(xlogs.-maxlog)...)))) : exp(maxlog + log(+((Base.exp).(xlogs.-maxlog)...))))

Base.prod(xs::AbstractArray{<:ULogarithmic}) = exp(sum(log.(xs)))
Base.sum(xs::AbstractArray{<:ULogarithmic}) = (xlogs=log.(xs); maxlog=maximum(xlogs); isinf(maxlog) ? exp(maxlog)::typeof(exp(maxlog + log(sum(Base.exp.(xlogs.-maxlog))))) : exp(maxlog + log(sum(Base.exp.(xlogs.-maxlog)))))


Base.:-(x::Logarithmic) = Logarithmic(x.abs, !x.signbit)
Base.log(x::Logarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); log(x.abs))
Base.:*(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = Logarithmic{T}(x.abs * y.abs, x.signbit ⊻ y.signbit)
Base.:^(x::Logarithmic, n::Integer) = Logarithmic(x.abs^n, x.signbit & isodd(n))
Base.:^(x::Logarithmic, n::Real) = (x.signbit && !iszero(x) && throw(DomainError(x)); Logarithmic(x.abs^n))
Base.inv(x::Logarithmic{T}) where {T} = Logarithmic{T}(inv(x.abs), s.signbit)
Base.:+(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = x.signbit==y.signbit ? Logarithmic(x.abs + y.abs, x.signbit) : x.abs ≥ y.abs ? Logarithmic(x.abs - y.abs, x.signbit) : Logarithmic(y.abs - x.abs, y.signbit)
Base.:-(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = x.signbit==y.signbit ? x.abs ≥ y.abs ? Logarithmic(x.abs - y.abs, x.signbit) : Logarithmic(y.abs - x.abs, !y.signbit) : Logarithmic(x.abs + y.abs, x.signbit)
