"""
A [logarithmic number system](https://en.wikipedia.org/wiki/Logarithmic_number_system).

Provides the signed [`Logarithmic`](@ref) and unsigned [`ULogarithmic`](@ref) types, which represent real numbers and positive real numbers respectively.
"""
module LogarithmicNumbers

using Requires, Random

export ULogarithmic, Logarithmic

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
If you know `logx=log(abs(x))` then use [`exp(Logarithmic, logx, signbit)`](@ref exp(::Type{Logarithmic},::Real)) instead.
"""
struct Logarithmic{T} <: Real
    abs::ULogarithmic{T}
    signbit::Bool
    Logarithmic{T}(abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} = new{T}(abs, signbit)
end

# for convenience
const AnyLog{T} = Union{ULogarithmic{T}, Logarithmic{T}}



# construct by exponentiation

exp(::Type{ULogarithmic{T}}, x::Real) where {T<:Real} =
exp(ULogarithmic{T}, convert(T, x))

exp(::Type{ULogarithmic}, x::T) where {T<:Real} =
exp(ULogarithmic{T}, x)

exp(::Type{Logarithmic{T}}, x::Real) where {T<:Real} =
Logarithmic{T}(exp(ULogarithmic{T}, x))

exp(::Type{Logarithmic}, x::T) where {T<:Real} =
exp(Logarithmic{T}, x)

# convenience
uexp(x) = exp(ULogarithmic, x)
uexp(T,x) = exp(ULogarithmic{T}, x)

# convert to ULogarithmic
ULogarithmic{T}(x::Real) where {T<:Real} = exp(ULogarithmic{T}, log(x))

ULogarithmic{T}(x::ULogarithmic{T}) where {T<:Real} = x

ULogarithmic(x::Real) = exp(ULogarithmic, log(x))

ULogarithmic(x::ULogarithmic) = x

# convert to Logarithmic

Logarithmic{T}(x::Real) where {T<:Real} =
Logarithmic{T}(ULogarithmic{T}(abs(x)), signbit(x))

Logarithmic{T}(x::Logarithmic{T}) where {T<:Real} = x

Logarithmic{T}(abs::ULogarithmic, signbit::Bool=false) where {T<:Real} =
Logarithmic{T}(ULogarithmic{T}(abs), signbit)

Logarithmic(x::Real) =
Logarithmic(ULogarithmic(abs(x)), signbit(x))

Logarithmic(abs::ULogarithmic{T}, signbit::Bool=false) where {T<:Real} =
Logarithmic{T}(abs, signbit)

Logarithmic(x::Logarithmic) = x

# conversion
float(x::ULogarithmic) = AbstractFloat(x)
float(::Type{A}) where {A<:AnyLog} = typeof(float(one(A)))
(::Type{T})(x::ULogarithmic) where {T<:AbstractFloat} = T(exp(float(x.log)))
big(x::ULogarithmic{T}) where {T} = uexp(big(x.log))
unsigned(x::ULogarithmic) = x
signed(x::ULogarithmic) = Logarithmic(x)

# type functions
widen(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{widen(T)}
big(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{big(T)}
typemin(::Type{ULogarithmic{T}}) where {T} = uexp(typemin(T))
typemax(::Type{ULogarithmic{T}}) where {T} = uexp(typemax(T))
unsigned(::Type{ULogarithmic{T}}) where {T} = ULogarithmic{T}
signed(::Type{ULogarithmic{T}}) where {T} = Logarithmic{T}

# special values
zero(::Type{ULogarithmic{T}}) where {T} = uexp(T, -Inf)
one(::Type{ULogarithmic{T}}) where {T} = uexp(T, zero(T))

# predicates
iszero(x::ULogarithmic) = isinf(x.log) && signbit(x.log)
isone(x::ULogarithmic) = iszero(x.log)
isinf(x::ULogarithmic) = isinf(x.log) && !signbit(x.log)
isfinite(x::ULogarithmic) = !isinf(x)
isnan(x::ULogarithmic) = isnan(x.log)

# sign
sign(x::ULogarithmic) = iszero(x) ? zero(x) : one(x)
signbit(x::ULogarithmic) = false
abs(x::ULogarithmic) = x

# ordering
(==)(x::ULogarithmic, y::ULogarithmic) = x.log == y.log
isequal(x::ULogarithmic, y::ULogarithmic) = isequal(x.log, y.log)
<(x::ULogarithmic, y::ULogarithmic) = x.log < y.log
≤(x::ULogarithmic, y::ULogarithmic) = x.log ≤ y.log
cmp(x::ULogarithmic, y::ULogarithmic) = cmp(x.log, y.log)
isless(x::ULogarithmic, y::ULogarithmic) = isless(x.log, y.log)

# epsilon
nextfloat(x::ULogarithmic) = uexp(nextfloat(x.log))
prevfloat(x::ULogarithmic) = uexp(prevfloat(x.log))


# conversion
float(x::Logarithmic) = AbstractFloat(x)
(::Type{T})(x::Logarithmic) where {T<:AbstractFloat} = (y=float(x.abs); T(ifelse(x.signbit, -y, y)))
big(x::Logarithmic) = Logarithmic(big(x.abs), x.signbit)
unsigned(x::Logarithmic) = (x.signbit && !iszero(x) && throw(DomainError(x)); x.abs)
signed(x::Logarithmic) = x

# type functions
widen(::Type{Logarithmic{T}}) where {T} = Logarithmic{widen(T)}
big(::Type{Logarithmic{T}}) where {T} = Logarithmic{big(T)}
typemin(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}(typemax(ULogarithmic{T}), true)
typemax(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}(typemax(ULogarithmic{T}))
unsigned(::Type{Logarithmic{T}}) where {T} = ULogarithmic{T}
signed(::Type{Logarithmic{T}}) where {T} = Logarithmic{T}

# special values
zero(::Type{Logarithmic{T}}) where {T} = Logarithmic(zero(ULogarithmic{T}))
one(::Type{Logarithmic{T}}) where {T} = Logarithmic(one(ULogarithmic{T}))

# predicates
iszero(x::Logarithmic) = iszero(x.abs)
isone(x::Logarithmic) = isone(x.abs) && !x.signbit
isinf(x::Logarithmic) = isinf(x.abs)
isfinite(x::Logarithmic) = isfinite(x.abs)
isnan(x::Logarithmic) = isnan(x.abs)

# sign
sign(x::Logarithmic) = (s=sign(x.abs); ifelse(x.signbit, -s, s))
signbit(x::Logarithmic) = x.signbit
abs(x::Logarithmic) = x.abs

# ordering
(==)(x::Logarithmic, y::Logarithmic) = (iszero(x) && iszero(y)) || (x.abs==y.abs && x.signbit==y.signbit)
isequal(x::Logarithmic, y::Logarithmic) = isequal(x.abs, y.abs) && isequal(x.signbit, y.signbit)
<(x::Logarithmic, y::Logarithmic) = x.signbit ? y.signbit ? (y.abs < x.abs) : !(iszero(x) && iszero(y)) : y.signbit ? (false) : (x.abs < y.abs)
≤(x::Logarithmic, y::Logarithmic) = x.signbit ? y.signbit ? (y.abs ≤ x.abs) : true : y.signbit ? (iszero(x) && iszero(y)) : (x.abs ≤ y.abs)
isless(x::Logarithmic, y::Logarithmic) = x.signbit ? y.signbit ? isless(y.abs,x.abs) : true : y.signbit ? false : isless(x.abs,y.abs)

# epsilon
nextfloat(x::Logarithmic) = x.signbit && !iszero(x) ? Logarithmic(prevfloat(x.abs), true) : Logarithmic(nextfloat(x.abs))
prevfloat(x::Logarithmic) = x.signbit || iszero(x) ? Logarithmic(nextfloat(x.abs), true) : Logarithmic(prevfloat(x.abs))


atypes = (ULogarithmic, Logarithmic)

# logarithmic + logarithmic

for (i,A) in enumerate(atypes)
    for (j,B) in enumerate(atypes)
        C = i<j ? B : A
        @eval promote_rule(::Type{$A}, ::Type{$B}) = $C
        @eval promote_rule(::Type{$A}, ::Type{$B{T}}) where {T} = $C{T}
        @eval promote_rule(::Type{$A{T}}, ::Type{$B}) where {T} = $C{T}
        @eval promote_rule(::Type{$A{S}}, ::Type{$B{T}}) where {S,T} =
        $C{promote_type(S,T)}
    end
end

# logarithmic + real

# generated for type-stability
@generated promote_rule(::Type{ULogarithmic}, ::Type{R}) where {R<:Real} =
try
    :($(typeof(ULogarithmic(one(R)))))
catch
    :(Union{})
end

promote_rule(::Type{A}, ::Type{R}) where {A<:AnyLog, R<:Real} =
promote_type(A, promote_type(ULogarithmic, R))


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

rand(rng::AbstractRNG, ::Random.SamplerType{E}) where {T<:AbstractFloat, E<:AnyLog{T}} =
exp(E, -randexp(rng, T))
rand(rng::AbstractRNG, ::Random.SamplerType{E}) where {E<:AnyLog} =
exp(E, -randexp(rng))

function show(io::IO, x::ULogarithmic)
    print(io, "exp(")
    show(io, x.log)
    print(io, ")")
end

function show(io::IO, x::Logarithmic)
    x.signbit && print(io, "-")
    show(io, x.abs)
end

write(io::IO, x::ULogarithmic) = write(io, x.log)
write(io::IO, x::Logarithmic) = write(io, x.abs, x.signbit)

read(io::IO, ::Type{ULogarithmic{T}}) where {T} = uexp(T, read(io, T))
read(io::IO, ::Type{Logarithmic{T}}) where {T} = Logarithmic{T}(read(io, ULogarithmic{T}), read(io, Bool))

function __init__()
    @require Distributions="31c24e10-a181-5473-b8eb-7969acd0382f" begin
        Distributions.cdf(::Type{E}, args...; opts...) where {E<:AnyLog} = exp(E, Distributions.logcdf(args...; opts...))
        Distributions.ccdf(::Type{E}, args...; opts...) where {E<:AnyLog} = exp(E, Distributions.logccdf(args...; opts...))
        Distributions.pdf(::Type{E}, args...; opts...) where {E<:AnyLog} = exp(E, Distributions.logpdf(args...; opts...))
    end
    @require StatsFuns="4c63d2b9-4356-54db-8cca-17b64c39e42c" begin
        for lfn in propertynames(StatsFuns)
            m = match(r"^(.*)log(pdf|cdf|ccdf)", string(lfn))
            if m !== nothing
                fn = Symbol(m[1], m[2])
                @eval StatsFuns.$(fn)(::Type{E}, args...; opts...) where {E<:AnyLog} = exp(E, StatsFuns.$(lfn)(args...; opts...))
            end
        end
    end
end

# type aliases
const ULogarithmicF16 = ULogarithmic{Float16}
const ULogarithmicF32 = ULogarithmic{Float32}
const ULogarithmicF64 = ULogarithmic{Float64}
const LogarithmicF16 = Logarithmic{Float16}
const LogarithmicF32 = Logarithmic{Float32}
const LogarithmicF64 = Logarithmic{Float64}
export ULogarithmicF16, ULogarithmicF32, ULogarithmicF64, LogarithmicF16, LogarithmicF32, LogarithmicF64

end # module
