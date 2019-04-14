# conversion
Base.float(x::Logarithmic) = (y=float(x.abs); ifelse(x.signbit, -y, y))
Base.big(x::Logarithmic) = Logarithmic(big(x.abs), x.signbit)
Base.unsigned(x::Logarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); x.abs)
Base.signed(x::Logarithmic) = x

# type functions
Base.widen(::Type{Logarithmic{T}}) where {T} = Logarithmic{widen(T)}
Base.big(::Type{Logarithmic{T}}) where {T} = Logarithmic{big(T)}
Base.typemin(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}(typemax(ULogarithmic{T}), true)
Base.typemax(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}(typemax(ULogarithmic{T}))
Base.unsigned(::Type{Logarithmic{T}}) where {T} = ULogarithmic{T}
Base.signed(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}

# special values
Base.zero(::Type{Logarithmic{T}}) where {T} = Logarithmic(zero(ULogarithmic{T}))
Base.one(::Type{Logarithmic{T}}) where {T} = Logarithmic(one(ULogarithmic{T}))

# predicates
Base.iszero(x::Logarithmic) = iszero(x.abs)
Base.isone(x::Logarithmic) = isone(x.abs) && !x.signbit
Base.isinf(x::Logarithmic) = isinf(x.abs)
Base.isfinite(x::Logarithmic) = isfinite(x.abs)
Base.isnan(x::Logarithmic) = isnan(x.abs)

# sign
Base.sign(x::Logarithmic) = (s=sign(x.abs); ifelse(x.signbit, -s, s))
Base.signbit(x::Logarithmic) = x.signbit
Base.abs(x::Logarithmic) = Logarithmic(x.abs)

# ordering
Base.:(==)(x::Logarithmic, y::Logarithmic) = (iszero(x) && iszero(y)) || (x.abs==y.abs && x.signbit==y.signbit)
Base.:<(x::Logarithmic, y::Logarithmic) = x.signbit ? y.signbit ? (y.abs < x.abs) : !(iszero(x) && iszero(y)) : y.signbit ? (false) : (x.abs < y.abs)
Base.:≤(x::Logarithmic, y::Logarithmic) = x.signbit ? y.signbit ? (y.abs ≤ x.abs) : true : y.signbit ? (iszero(x) && iszero(y)) : (x.abs ≤ y.abs)

# epsilon
Base.nextfloat(x::Logarithmic) = x.signbit && !iszero(x) ? Logarithmic(prevfloat(x.abs), true) : Logarithmic(nextfloat(x.abs))
Base.prevfloat(x::Logarithmic) = x.signbit || iszero(x) ? Logarithmic(nextfloat(x.abs), true) : Logarithmic(prevfloat(x.abs))

# random
Base.rand(rng::AbstractRNG, ::Random.SamplerType{Logarithmic{T}}) where {T<:AbstractFloat} = exptosexp(T, rand(rng, Random.SamplerType{ULogarithmic{T}}()))
Base.rand(rng::AbstractRNG, ::Random.SamplerType{Logarithmic}) = rand(rng, Random.SamplerType{Logarithmic{Float64}}())