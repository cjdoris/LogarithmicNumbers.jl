# conversion
Base.float(x::SLogarithmic) = (y=float(x.abs); ifelse(x.signbit, -y, y))
Base.big(x::SLogarithmic) = SLogarithmic(big(x.abs), x.signbit)
Base.unsigned(x::SLogarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); x.abs)
Base.signed(x::SLogarithmic) = x

# type functions
Base.widen(::Type{SLogarithmic{T}}) where {T} = SLogarithmic{widen(T)}
Base.big(::Type{SLogarithmic{T}}) where {T} = SLogarithmic{big(T)}
Base.typemin(::Type{SLogarithmic{T}}) where {T} = SLogarithmic{T}(typemax(Logarithmic{T}), true)
Base.typemax(::Type{SLogarithmic{T}}) where {T} = SLogarithmic{T}(typemax(Logarithmic{T}))
Base.unsigned(::Type{SLogarithmic{T}}) where {T} = Logarithmic{T}
Base.signed(::Type{SLogarithmic{T}}) where {T} = SLogarithmic{T}

# special values
Base.zero(::Type{SLogarithmic{T}}) where {T} = SLogarithmic(zero(Logarithmic{T}))
Base.one(::Type{SLogarithmic{T}}) where {T} = SLogarithmic(one(Logarithmic{T}))

# predicates
Base.iszero(x::SLogarithmic) = iszero(x.abs)
Base.isone(x::SLogarithmic) = isone(x.abs) && !x.signbit
Base.isinf(x::SLogarithmic) = isinf(x.abs)
Base.isfinite(x::SLogarithmic) = isfinite(x.abs)
Base.isnan(x::SLogarithmic) = isnan(x.abs)

# sign
Base.sign(x::SLogarithmic) = (s=sign(x.abs); ifelse(x.signbit, -s, s))
Base.signbit(x::SLogarithmic) = x.signbit
Base.abs(x::SLogarithmic) = SLogarithmic(x.abs)

# ordering
Base.:(==)(x::SLogarithmic, y::SLogarithmic) = (iszero(x) && iszero(y)) || (x.abs==y.abs && x.signbit==y.signbit)
Base.:<(x::SLogarithmic, y::SLogarithmic) = x.signbit ? y.signbit ? (y.abs < x.abs) : !(iszero(x) && iszero(y)) : y.signbit ? (false) : (x.abs < y.abs)
Base.:≤(x::SLogarithmic, y::SLogarithmic) = x.signbit ? y.signbit ? (y.abs ≤ x.abs) : true : y.signbit ? (iszero(x) && iszero(y)) : (x.abs ≤ y.abs)

# epsilon
Base.nextfloat(x::SLogarithmic) = x.signbit && !iszero(x) ? SLogarithmic(prevfloat(x.abs), true) : SLogarithmic(nextfloat(x.abs))
Base.prevfloat(x::SLogarithmic) = x.signbit || iszero(x) ? SLogarithmic(nextfloat(x.abs), true) : SLogarithmic(prevfloat(x.abs))

# random
Base.rand(rng::AbstractRNG, ::Random.SamplerType{SLogarithmic{T}}) where {T<:AbstractFloat} = exptosexp(T, rand(rng, Random.SamplerType{Logarithmic{T}}()))
Base.rand(rng::AbstractRNG, ::Random.SamplerType{SLogarithmic}) = rand(rng, Random.SamplerType{SLogarithmic{Float64}}())