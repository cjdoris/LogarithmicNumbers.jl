"""
A [logarithmic number system](https://en.wikipedia.org/wiki/Logarithmic_number_system).

Provides the signed [`Logarithmic`](@ref) and unsigned [`ULogarithmic`](@ref) types, which represent real numbers and positive real numbers respectively.
"""
module LogarithmicNumbers

using Requires, Random

export ULogarithmic, ULogFloat16, ULogFloat32, ULogFloat64
export Logarithmic, LogFloat16, LogFloat32, LogFloat64


### Types

"""
ULogarithmic(x)

Represents the positive real number `x` by storing its logarithm.

!!! tip
    If you know `logx=log(x)` then use [`exp(ULogarithmic, logx)`](@ref exp(::Type{ULogarithmic},::Real)) instead.
"""
struct ULogarithmic{T} <: Real
    log::T
    Base.exp(::Type{ULogarithmic{T}}, x::T) where {T<:Real} = new{T}(x)
end

"""
Logarithmic(x)

Represents the real number `x` by storing its absolute value as a [`ULogarithmic`](@ref) and its sign bit.

!!! tip
    If you know `logx=log(abs(x))` then use [`exp(Logarithmic, logx)`](@ref exp(::Type{Logarithmic},::Real)) instead.
"""
struct Logarithmic{T} <: Real
    abs::ULogarithmic{T}
    signbit::Bool
    Logarithmic{T}(abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} = new{T}(abs, signbit)
end

const ULogFloat16 = ULogarithmic{Float16}
const ULogFloat32 = ULogarithmic{Float32}
const ULogFloat64 = ULogarithmic{Float64}
const LogFloat16 = Logarithmic{Float16}
const LogFloat32 = Logarithmic{Float32}
const LogFloat64 = Logarithmic{Float64}

const AnyLogarithmic{T} = Union{ULogarithmic{T}, Logarithmic{T}}


### Constructors

function Base.exp(::Type{ULogarithmic{T}}, x::Real) where {T<:Real}
    exp(ULogarithmic{T}, convert(T, x))
end

function Base.exp(::Type{ULogarithmic}, x::T) where {T<:Real}
    exp(ULogarithmic{T}, x)
end

function Base.exp(::Type{Logarithmic{T}}, x::Real) where {T<:Real}
    Logarithmic{T}(exp(ULogarithmic{T}, x))
end

function Base.exp(::Type{Logarithmic}, x::T) where {T<:Real}
    exp(Logarithmic{T}, x)
end

uexp(x) = exp(ULogarithmic, x)
uexp(T,x) = exp(ULogarithmic{T}, x)

function ULogarithmic{T}(x::Real) where {T<:Real}
    exp(ULogarithmic{T}, log(x))
end

function ULogarithmic{T}(x::ULogarithmic{T}) where {T<:Real}
    x
end

function ULogarithmic(x::Real)
    exp(ULogarithmic, log(x))
end

function ULogarithmic(x::ULogarithmic)
    x
end

function Logarithmic{T}(x::Real) where {T<:Real}
    Logarithmic{T}(ULogarithmic{T}(abs(x)), signbit(x))
end

function Logarithmic{T}(x::Logarithmic{T}) where {T<:Real}
    x
end

function Logarithmic{T}(abs::ULogarithmic, signbit::Bool=false) where {T<:Real}
    Logarithmic{T}(ULogarithmic{T}(abs), signbit)
end

function Logarithmic(x::Real)
    Logarithmic(ULogarithmic(abs(x)), signbit(x))
end

function Logarithmic(abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real}
    Logarithmic{T}(abs, signbit)
end

function Logarithmic(x::Logarithmic)
    x
end


### float / big / signed / unsigned

function Base.float(x::AnyLogarithmic)
    AbstractFloat(x)
end

function (::Type{T})(x::ULogarithmic) where {T<:AbstractFloat}
    T(exp(float(x.log)))
end

function (::Type{T})(x::Logarithmic) where {T<:AbstractFloat}
    y = float(x.abs)
    x.signbit ? T(-y) : T(y)
end

function Base.big(x::ULogarithmic{T}) where {T}
    uexp(big(x.log))
end

function Base.big(x::Logarithmic)
    Logarithmic(big(x.abs), x.signbit)
end

function Base.unsigned(x::ULogarithmic)
    x
end

function Base.unsigned(x::Logarithmic)
    x.signbit && !iszero(x) && throw(DomainError(x))
    x.abs
end

function Base.signed(x::ULogarithmic)
    Logarithmic(x)
end

function Base.signed(x::Logarithmic)
    x
end


### Type functions

function Base.float(::Type{T}) where {T<:AnyLogarithmic}
    typeof(float(one(T)))
end

function Base.widen(::Type{ULogarithmic{T}}) where {T}
    ULogarithmic{widen(T)}
end

function Base.widen(::Type{Logarithmic{T}}) where {T}
    Logarithmic{widen(T)}
end

function Base.big(::Type{ULogarithmic{T}}) where {T}
    ULogarithmic{big(T)}
end

function Base.big(::Type{Logarithmic{T}}) where {T}
    Logarithmic{big(T)}
end

function Base.unsigned(::Type{ULogarithmic{T}}) where {T}
    ULogarithmic{T}
end

function Base.unsigned(::Type{Logarithmic{T}}) where {T}
    ULogarithmic{T}
end

function Base.signed(::Type{ULogarithmic{T}}) where {T}
    Logarithmic{T}
end

function Base.signed(::Type{Logarithmic{T}}) where {T}
    Logarithmic{T}
end


### Special values

function Base.zero(::Type{ULogarithmic{T}}) where {T}
    uexp(T, -Inf)
end

function Base.zero(::Type{ULogarithmic})
    uexp(-Inf)
end

function Base.zero(::Type{Logarithmic{T}}) where {T}
    Logarithmic(zero(ULogarithmic{T}))
end

function Base.zero(::Type{Logarithmic})
    Logarithmic(zero(ULogarithmic))
end

function Base.one(::Type{ULogarithmic{T}}) where {T}
    uexp(T, zero(T))
end

function Base.one(::Type{ULogarithmic})
    uexp(0.0)
end

function Base.one(::Type{Logarithmic{T}}) where {T}
    Logarithmic(one(ULogarithmic{T}))
end

function Base.one(::Type{Logarithmic}) where {T}
    Logarithmic(one(ULogarithmic))
end

function Base.typemin(::Type{ULogarithmic{T}}) where {T}
    uexp(typemin(T))
end

function Base.typemin(::Type{Logarithmic{T}}) where {T}
    Logarithmic{T}(typemax(ULogarithmic{T}), true)
end

function Base.typemax(::Type{ULogarithmic{T}}) where {T}
    uexp(typemax(T))
end

function Base.typemax(::Type{Logarithmic{T}}) where {T}
    Logarithmic{T}(typemax(ULogarithmic{T}))
end


### Predicates

function Base.iszero(x::ULogarithmic)
    isinf(x.log) && signbit(x.log)
end

function Base.iszero(x::Logarithmic)
    iszero(x.abs)
end

function Base.isone(x::ULogarithmic)
    iszero(x.log)
end

function Base.isone(x::Logarithmic)
    isone(x.abs) && !x.signbit
end

function Base.isinf(x::ULogarithmic)
    isinf(x.log) && !signbit(x.log)
end

function Base.isinf(x::Logarithmic)
    isinf(x.abs)
end

function Base.isfinite(x::ULogarithmic)
    isfinite(x.log) || signbit(x.log)
end

function Base.isfinite(x::Logarithmic)
    isfinite(x.abs)
end

function Base.isnan(x::ULogarithmic)
    isnan(x.log)
end

function Base.isnan(x::Logarithmic)
    isnan(x.abs)
end


### Ordering

function Base.sign(x::ULogarithmic)
    isnan(x) ? x : iszero(x) ? zero(x) : one(x)
end

function Base.sign(x::Logarithmic)
    isnan(x) ? x : iszero(x) ? zero(x) : x.signbit ? -one(x) : one(x)
end

function Base.signbit(x::ULogarithmic)
    false
end

function Base.signbit(x::Logarithmic)
    x.signbit
end

function Base.abs(x::ULogarithmic)
    x
end

function Base.abs(x::Logarithmic)
    x.abs
end

function Base.:(==)(x::ULogarithmic, y::ULogarithmic)
    x.log == y.log
end

function Base.:(==)(x::Logarithmic, y::Logarithmic)
    (iszero(x) && iszero(y)) || (x.abs==y.abs && x.signbit==y.signbit)
end

function Base.isequal(x::ULogarithmic, y::ULogarithmic)
    isequal(x.log, y.log)
end

function Base.isequal(x::Logarithmic, y::Logarithmic)
    isequal(x.abs, y.abs) && isequal(x.signbit, y.signbit)
end

function Base.:(<)(x::ULogarithmic, y::ULogarithmic)
    x.log < y.log
end

function Base.:(<)(x::Logarithmic, y::Logarithmic)
    if isnan(x) || isnan(y)
        false
    elseif x.signbit
        if y.signbit
            y.abs < x.abs
        else
            !iszero(x) || !iszero(y)
        end
    else
        if y.signbit
            false
        else
            x.abs < y.abs
        end
    end
end

function Base.:(≤)(x::ULogarithmic, y::ULogarithmic)
    x.log ≤ y.log
end

function Base.:(≤)(x::Logarithmic, y::Logarithmic)
    if isnan(x) || isnan(y)
        false
    elseif x.signbit
        if y.signbit
            y.abs ≤ x.abs
        else
            true
        end
    else
        if y.signbit
            iszero(x) && iszero(y)
        else
            x.abs ≤ y.abs
        end
    end
end

function Base.cmp(x::ULogarithmic, y::ULogarithmic)
    cmp(x.log, y.log)
end

function Base.isless(x::ULogarithmic, y::ULogarithmic)
    isless(x.log, y.log)
end

function Base.isless(x::Logarithmic, y::Logarithmic)
    if x.signbit
        if y.signbit
            isless(y.abs, x.abs)
        else
            true
        end
    else
        if y.signbit
            false
        else
            isless(x.abs, y.abs)
        end
    end
end

function Base.nextfloat(x::ULogarithmic)
    uexp(nextfloat(x.log))
end

function Base.nextfloat(x::Logarithmic)
    if x.signbit && !iszero(x)
        Logarithmic(prevfloat(x.abs), true)
    else
        Logarithmic(nextfloat(x.abs))
    end
end

function Base.prevfloat(x::ULogarithmic)
    uexp(prevfloat(x.log))
end

function Base.prevfloat(x::Logarithmic)
    if x.signbit || iszero(x)
        Logarithmic(nextfloat(x.abs), true)
    else
        Logarithmic(prevfloat(x.abs))
    end
end


### Promotion

_promote_rule(::Type, ::Type) = Union{}
for (i, A) in enumerate([ULogarithmic, Logarithmic])
    for (j, B) in enumerate([ULogarithmic, Logarithmic])
        C = i > j ? A : B
        @eval begin
            _promote_rule(::Type{$A}, ::Type{$B}) = $C
            _promote_rule(::Type{$A}, ::Type{$B{T}}) where {T} = $C{T}
            _promote_rule(::Type{$A{S}}, ::Type{$B}) where {S} = $C{S}
            _promote_rule(::Type{$A{S}}, ::Type{$B{T}}) where {S,T} = $C{promote_type(S,T)}
        end
    end
end

function Base.promote_rule(::Type{T}, ::Type{R}) where {T<:AnyLogarithmic, R<:AnyLogarithmic}
    _promote_rule(T, R)
end

@generated function Base.promote_rule(::Type{T}, ::Type{R}) where {T<:AnyLogarithmic, R<:Real}
    # TODO: Think about this some more. Always return ULogarithmic? Always Logarithmic?
    isunsigned = try
        typemin(R) ≥ 0
    catch
        false
    end
    L = isunsigned ? ULogarithmic : Logarithmic
    R2 = try
        typeof(L(one(R)))
    catch
        Union{}
    end
    promote_type(T, R2)
end

### Arithmetic

Base.:(+)(x::AnyLogarithmic) = x

Base.:(-)(x::ULogarithmic) = Logarithmic(x, true)
Base.:(-)(x::Logarithmic) = Logarithmic(x.abs, !x.signbit)

function Base.:(+)(x::T, y::T) where {T<:ULogarithmic}
    if x.log == y.log
        uexp(x.log + log1p(exp(zero(y.log) - zero(x.log))))
    elseif x.log ≥ y.log
        uexp(x.log + log1p(exp(y.log - x.log)))
    else
        uexp(y.log + log1p(exp(x.log - y.log)))
    end
end

function Base.:(+)(x::T, y::T) where {T<:Logarithmic}
    if x.signbit == y.signbit
        Logarithmic(x.abs + y.abs, x.signbit)
    elseif x.abs ≥ y.abs
        Logarithmic(x.abs - y.abs, x.signbit)
    else
        Logarithmic(y.abs - x.abs, y.signbit)
    end
end

function Base.:(-)(x::T, y::T) where {T<:ULogarithmic}
    if x.log < y.log
        throw(DomainError((x, y), "difference is negative"))
    else
        d = y.log - x.log
        if isnan(d) && iszero(x) && iszero(y)
            d = zero(y.log) - zero(x.log)
        end
        if d < -1
            c = log1p(-exp(d))
        else
            # accurate when d is small
            # e.g. exp(1e-100) - exp(-1e-100) ≈ exp(-229.56536)
            c = log(-expm1(d))
        end
        uexp(x.log + c)
    end
end

function Base.:(-)(x::T, y::T) where {T<:Logarithmic}
    if x.signbit == y.signbit
        if x.abs ≥ y.abs
            Logarithmic(x.abs - y.abs, x.signbit)
        else
            Logarithmic(y.abs - x.abs, !y.signbit)
        end
    else
        Logarithmic(x.abs + y.abs, x.signbit)
    end
end

function Base.:(*)(x::T, y::T) where {T<:ULogarithmic}
    uexp(x.log + y.log)
end

function Base.:(*)(x::T, y::T) where {T<:Logarithmic}
    Logarithmic(x.abs * y.abs, x.signbit ⊻ y.signbit)
end

function Base.:(/)(x::T, y::T) where {T<:ULogarithmic}
    uexp(x.log - y.log)
end

function Base.:(/)(x::T, y::T) where {T<:Logarithmic}
    Logarithmic(x.abs / y.abs, x.signbit ⊻ y.signbit)
end

function Base.:(^)(x::ULogarithmic, n::Real)
    if n == 0
        uexp(zero(x.log) * n)
    else
        uexp(x.log * n)
    end
end

function Base.:(^)(x::ULogarithmic, n::Integer)
    if n == 0
        uexp(zero(x.log) * n)
    else
        uexp(x.log * n)
    end
end

function Base.:(^)(x::Logarithmic, n::Integer)
    Logarithmic(x.abs^n, x.signbit & isodd(n))
end

function Base.:(^)(x::Logarithmic, n::Real)
    x.signbit && !iszero(x) && throw(DomainError(x))
    Logarithmic(x.abs^n)
end

function Base.inv(x::ULogarithmic)
    uexp(-x.log)
end

function Base.inv(x::Logarithmic)
    Logarithmic(inv(x.abs), x.signbit)
end

function Base.log(x::ULogarithmic)
    x.log
end

function Base.log(x::Logarithmic)
    x.signbit && !iszero(x) && throw(DomainError(x))
    log(x.abs)
end

function Base.log2(x::AnyLogarithmic)
    logx = log(x)
    log2 = log(oftype(logx, 2))
    logx / log2
end

function Base.log10(x::AnyLogarithmic)
    logx = log(x)
    log10 = log(oftype(logx, 10))
    logx / log10
end

function Base.log1p(x::AnyLogarithmic)
    log(one(x) + x)
end

function Base.exp(x::ULogarithmic)
    uexp(exp(x.log))
end

function Base.exp(x::Logarithmic)
    x.signbit ? inv(exp(x.abs)) : exp(x.abs)
end

### Hash

const _HASH = hash(ULogarithmic)

function Base.hash(x::ULogarithmic, h::UInt)
    hash(x.log, hash(_HASH, h))
end

function Base.hash(x::Logarithmic, h::UInt)
    # hash the same as ULogarithmic when signbit==false
    # TODO: hash special values (-Inf, -1, 0, 1, Inf) the same as Float64?
    hash(x.abs, x.signbit ? hash(_HASH, h) : h)
end

### Random

function Base.rand(rng::AbstractRNG, ::Random.SamplerType{E}) where {T<:AbstractFloat, E<:AnyLogarithmic{T}}
    exp(E, -randexp(rng, T))
end

function Base.rand(rng::AbstractRNG, ::Random.SamplerType{E}) where {E<:AnyLogarithmic}
    exp(E, -randexp(rng))
end


### IO

function Base.show(io::IO, x::ULogarithmic)
    print(io, "exp(")
    show(io, x.log)
    print(io, ")")
end

function Base.show(io::IO, x::Logarithmic)
    print(io, x.signbit ? "-" : "+")
    show(io, x.abs)
end

function Base.write(io::IO, x::ULogarithmic)
    write(io, x.log)
end

function Base.write(io::IO, x::Logarithmic)
    write(io, x.abs, x.signbit)
end

function Base.read(io::IO, ::Type{ULogarithmic{T}}) where {T}
    uexp(T, read(io, T))
end

function Base.read(io::IO, ::Type{Logarithmic{T}}) where {T}
    abs = read(io, ULogarithmic{T})
    signbit = read(io, Bool)
    Logarithmic{T}(abs, signbit)
end

_overload(mod, f, logf) = quote
    if isdefined($mod, $(QuoteNode(f))) && isdefined($mod, $(QuoteNode(logf)))
        @inline function $mod.$f(::Type{T}, args...; opts...) where {T<:AnyLogarithmic}
            exp(T, $mod.$logf(args...; opts...))
        end
    end
end

_overloads(mod, fs) = :($([_overload(mod, f, logf) for (f, logf) in fs]...);)

const DISTRIBUTIONS_OVERLOADS = [f => Symbol(:log, f) for f in [:cdf, :ccdf, :pdf]]
const STATSFUNS_DISTS = [:srdist, :nchisq, :hyper, :ntdist, :tdist, :binom, :pois, :fdist, :norm, :beta, :nfdist, :chisq, :gamma, :nbeta, :nbinom]
const STATSFUNS_OVERLOADS = [Symbol(d, f) => Symbol(d, :log, f) for d in STATSFUNS_DISTS for f in [:cdf, :ccdf, :pdf]]
const SPECIALFUNCTIONS_OVERLOADS = [f => Symbol(:log, f) for f in [:gamma, :factorial, :beta, :erfc, :erfcx]]

@eval function __init__()
    @require Distributions="31c24e10-a181-5473-b8eb-7969acd0382f" $(_overloads(:Distributions, DISTRIBUTIONS_OVERLOADS))
    @require StatsFuns="4c63d2b9-4356-54db-8cca-17b64c39e42c" $(_overloads(:StatsFuns, STATSFUNS_OVERLOADS))
    @require SpecialFunctions="276daf66-3868-5448-9aa4-cd146d93841b" $(_overloads(:SpecialFunctions, SPECIALFUNCTIONS_OVERLOADS))
    # TODO: Rmath
end

end
