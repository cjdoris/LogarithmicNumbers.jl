Base.log(x::Logarithmic) = x.log
Base.:*(x::Logarithmic{T}, y::Logarithmic{T}, rest::Logarithmic{T}...) where {T} = exp(T, +(log.((x, y, rest...))...))
Base.:/(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = exp(T, x.log - y.log)
Base.:^(x::Logarithmic, n::Real) = exp(x.log * n)
Base.:^(x::Logarithmic, n::Integer) = exp(x.log * n)
Base.inv(x::Logarithmic{T}) where {T} = exp(T, -x.log)
# Base.:+(x::Logarithmic, y::Logarithmic) = x.log ≥ y.log ? x * Logarithmic(1 + float(y/x)) : y * Logarithmic(float(x/y) + 1)
Base.:+(x::Logarithmic{T}, y::Logarithmic{T}, rest::Logarithmic{T}...) where {T} = _add(x, y, rest...)
Base.:-(x::Logarithmic{T}, y::Logarithmic{T}) where {T} = (xlog=x.log; ylog=y.log; xlog<ylog && error("difference is negative"); exp(xlog + log(1 - Base.exp(ylog-xlog))))

@inline _add(xs::Logarithmic{T}...) where {T} = (xlogs=log.(xs); maxlog=max(xlogs...); isinf(maxlog) ? exp(maxlog) : exp(maxlog + log(+((Base.exp).(xlogs.-maxlog)...))))

Base.prod(xs::AbstractArray{<:Logarithmic}) = exp(sum(log.(xs)))
Base.sum(xs::AbstractArray{<:Logarithmic}) = (xlogs=log.(xs); maxlog=maximum(xlogs); isinf(maxlog) ? exp(maxlog) : exp(maxlog + log(sum(Base.exp.(xlogs.-maxlog)))))


Base.:-(x::SLogarithmic) = SLogarithmic(x.abs, !x.signbit)
Base.log(x::SLogarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); log(x.abs))
Base.:*(x::SLogarithmic{T}, y::SLogarithmic{T}) where {T} = SLogarithmic{T}(x.abs * y.abs, x.signbit ⊻ y.signbit)
Base.:^(x::SLogarithmic, n::Integer) = SLogarithmic(x.abs^n, x.signbit & isodd(n))
Base.:^(x::SLogarithmic, n::Real) = (x.signbit && !iszero(x) && throw(DomainError(x)); SLogarithmic(x.abs^n))
Base.inv(x::SLogarithmic{T}) where {T} = SLogarithmic{T}(inv(x.abs), s.signbit)
Base.:+(x::SLogarithmic{T}, y::SLogarithmic{T}) where {T} = x.signbit==y.signbit ? SLogarithmic(x.abs + y.abs, x.signbit) : x.abs ≥ y.abs ? SLogarithmic(x.abs - y.abs, x.signbit) : SLogarithmic(y.abs - x.abs, y.signbit)
Base.:-(x::SLogarithmic{T}, y::SLogarithmic{T}) where {T} = x.signbit==y.signbit ? x.abs ≥ y.abs ? SLogarithmic(x.abs - y.abs, x.signbit) : SLogarithmic(y.abs - x.abs, !y.signbit) : SLogarithmic(x.abs + y.abs, x.signbit)
