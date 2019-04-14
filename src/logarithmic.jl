# conversion
Base.float(x::Logarithmic) = Base.exp(x.log)
Base.big(x::Logarithmic{T}) where {T} = exp(big(x.log))
Base.unsigned(x::Logarithmic) = x
Base.signed(x::Logarithmic) = SLogarithmic(x)

# type functions
Base.widen(::Type{Logarithmic{T}}) where {T} = Logarithmic{widen(T)}
Base.big(::Type{Logarithmic{T}}) where {T} = Logarithmic{big(T)}
Base.typemin(::Type{Logarithmic{T}}) where {T} = exp(typemin(T))
Base.typemax(::Type{Logarithmic{T}}) where {T} = exp(typemax(T))
Base.unsigned(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}
Base.signed(::Type{Logarithmic{T}}) where {T} = SLogarithmic{T}

# special values
Base.zero(::Type{Logarithmic{T}}) where {T} = exp(T, -Inf)
Base.one(::Type{Logarithmic{T}}) where {T} = exp(T, zero(T))

# predicates
Base.iszero(x::Logarithmic) = isinf(x.log) && signbit(x.log)
Base.isone(x::Logarithmic) = iszero(x.log)
Base.isinf(x::Logarithmic) = isinf(x.log) && !signbit(x.log)
Base.isfinite(x::Logarithmic) = !isinf(x)
Base.isnan(x::Logarithmic) = isnan(x.log)

# sign
Base.sign(x::Logarithmic) = iszero(x) ? zero(x) : one(x)
Base.signbit(x::Logarithmic) = false
Base.abs(x::Logarithmic) = x

# ordering
Base.:(==)(x::Logarithmic, y::Logarithmic) = x.log == y.log
Base.:<(x::Logarithmic, y::Logarithmic) = x.log < y.log
Base.:≤(x::Logarithmic, y::Logarithmic) = x.log ≤ y.log
Base.cmp(x::Logarithmic, y::Logarithmic) = cmp(x.log, y.log)

# epsilon
Base.nextfloat(x::Logarithmic) = exp(nextfloat(x.log))
Base.prevfloat(x::Logarithmic) = exp(prevfloat(x.log))

# random
Base.rand(rng::AbstractRNG, ::Random.SamplerType{Logarithmic{T}}) where {T<:AbstractFloat} = exp(T, -randexp(rng, T))
Base.rand(rng::AbstractRNG, ::Random.SamplerType{Logarithmic}) = rand(rng, Random.SamplerType{Logarithmic{Float64}}())