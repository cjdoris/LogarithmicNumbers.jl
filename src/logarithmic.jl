# conversion
Base.float(x::ULogarithmic) = Base.exp(x.log)
Base.big(x::ULogarithmic{T}) where {T} = exp(big(x.log))
Base.unsigned(x::ULogarithmic) = x
Base.signed(x::ULogarithmic) = Logarithmic(x)

# type functions
Base.widen(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{widen(T)}
Base.big(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{big(T)}
Base.typemin(::Type{ULogarithmic{T}}) where {T} = exp(typemin(T))
Base.typemax(::Type{ULogarithmic{T}}) where {T} = exp(typemax(T))
Base.unsigned(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{T}
Base.signed(::Type{ULogarithmic{T}}) where {T} = Logarithmic{T}

# special values
Base.zero(::Type{ULogarithmic{T}}) where {T} = exp(T, -Inf)
Base.one(::Type{ULogarithmic{T}}) where {T} = exp(T, zero(T))

# predicates
Base.iszero(x::ULogarithmic) = isinf(x.log) && signbit(x.log)
Base.isone(x::ULogarithmic) = iszero(x.log)
Base.isinf(x::ULogarithmic) = isinf(x.log) && !signbit(x.log)
Base.isfinite(x::ULogarithmic) = !isinf(x)
Base.isnan(x::ULogarithmic) = isnan(x.log)

# sign
Base.sign(x::ULogarithmic) = iszero(x) ? zero(x) : one(x)
Base.signbit(x::ULogarithmic) = false
Base.abs(x::ULogarithmic) = x

# ordering
Base.:(==)(x::ULogarithmic, y::ULogarithmic) = x.log == y.log
Base.:<(x::ULogarithmic, y::ULogarithmic) = x.log < y.log
Base.:≤(x::ULogarithmic, y::ULogarithmic) = x.log ≤ y.log
Base.cmp(x::ULogarithmic, y::ULogarithmic) = cmp(x.log, y.log)

# epsilon
Base.nextfloat(x::ULogarithmic) = exp(nextfloat(x.log))
Base.prevfloat(x::ULogarithmic) = exp(prevfloat(x.log))

# random
Base.rand(rng::AbstractRNG, ::Random.SamplerType{ULogarithmic{T}}) where {T<:AbstractFloat} = exp(T, -randexp(rng, T))
Base.rand(rng::AbstractRNG, ::Random.SamplerType{ULogarithmic}) = rand(rng, Random.SamplerType{ULogarithmic{Float64}}())