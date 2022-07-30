using LogarithmicNumbers, Test, Aqua

Aqua.test_all(LogarithmicNumbers)

function _approx(x,y)
    ans = isapprox(x, y, atol=1e-3) || (isnan(x) && isnan(y))
    ans || @show x y
    ans
end

# use these to check for type stability
_exp(args...) = @inferred exp(args...)
_log(args...) = @inferred log(args...)
_add(args...) = @inferred +(args...)
_sub(args...) = @inferred -(args...)
_mul(args...) = @inferred *(args...)
_div(args...) = @inferred /(args...)
_pow(args...) = @inferred ^(args...)
_float(args...) = @inferred float(args...)
_inv(args...) = @inferred inv(args...)
_prod(args...) = @inferred prod(args...)
_sum(args...) = @inferred sum(args...)

# sample values
vals = Any[-Inf, -20, -20.0, -2, -2.0, -1, -1.0, -0.5, 0, 0.0, 0.5, 1, 1.0, 2, 2.0, 20, 20.0, Inf, NaN]

# sample vectors
vecs = (
Float64[x for x in vals if x isa Float64],
Float64[x for x in vals if x isa Float64 && !isinf(x)],
Float64[x for x in vals if x isa Float64 && !iszero(x)],
Float64[x for x in vals if x isa Float64 && !isinf(x) && x ≥ 0],
Int[x for x in vals if x isa Int],
Int[x for x in vals if x isa Int && x ≥ 0],
)

atypes = (ULogarithmic, Logarithmic)
atypes2 = (ULogarithmic, ULogFloat32, Logarithmic, LogFloat32)

@testset "LogarithmicNumbers" begin

    @testset "types" begin
        @test @isdefined ULogarithmic
        @test @isdefined Logarithmic
        @test @isdefined ULogFloat16
        @test @isdefined ULogFloat32
        @test @isdefined ULogFloat64
        @test @isdefined LogFloat16
        @test @isdefined LogFloat32
        @test @isdefined LogFloat64
    end

    @testset "exp" begin
        for A in atypes2, x in vals
            y = _exp(A, x)
            if A in (ULogarithmic, Logarithmic)
                @test y isa A{typeof(x)}
            else
                @test y isa A
            end
        end
    end

    @testset "construct" begin
        for A in atypes2, x in vals
            if A <: ULogarithmic && x < 0
                @test_throws DomainError @inferred A(x)
            else
                y = @inferred A(x)
                @test y isa A
                if A <: ULogarithmic
                    @test _approx(y.log, log(x))
                else
                    @test _approx(y.abs.log, log(abs(x)))
                    @test _approx(y.signbit, signbit(x))
                end
            end
        end
        @test ULogFloat64(ULogFloat64(0)) === ULogFloat64(0)
        @test ULogFloat64(ULogFloat32(0)) === ULogFloat64(0)
        @test ULogarithmic(ULogFloat32(0)) === ULogFloat32(0)
        @test LogFloat64(LogFloat64(0)) === LogFloat64(0)
        @test LogFloat64(LogFloat32(0)) === LogFloat64(0)
        @test Logarithmic(LogFloat32(0)) === LogFloat32(0)
        @test LogFloat64(ULogarithmic(0)) == LogFloat64(0)
        @test Logarithmic(ULogarithmic(0)) === Logarithmic(0)
    end

    @testset "float" begin
        for A in atypes2, x in vals
            A <: ULogarithmic && x < 0 && continue
            y = A(x)
            @test _float(y) isa AbstractFloat
            @test _approx(_float(y), x)
            @test @inferred(AbstractFloat(y)) isa AbstractFloat
            @test _approx(@inferred(AbstractFloat(y)), x)
            @test @inferred(Float64(y)) isa Float64
            @test _approx(@inferred(Float64(y)), x)
            @test @inferred(Float32(y)) isa Float32
            @test _approx(@inferred(Float32(y)), x)
        end
    end

    @testset "promote" begin
        for A1 in atypes, A2 in atypes, T1 in (nothing, Int, Float64), T2 in (nothing, Int, Float64)
            A3 = A1 <: Logarithmic || A2 <: Logarithmic ? Logarithmic : ULogarithmic
            T3 = T1 === nothing ? T2 === nothing ? nothing : T2 : T2 === nothing ? T1 : promote_type(T1, T2)
            B1 = T1 === nothing ? A1 : A1{T1}
            B2 = T2 === nothing ? A2 : A2{T2}
            B3 = T3 === nothing ? A3 : A3{T3}
            @test promote_type(A1, A2) == A3
        end
    end

    @testset "big" begin
        for A in atypes, x in vals
            A <: ULogarithmic && x < 0 && continue
            y = A(x)
            z = @inferred big(y)
            B = A <: ULogarithmic ? ULogarithmic{BigFloat} : Logarithmic{BigFloat}
            @test z isa B
            @test _approx(_float(z), x)
        end
    end

    @testset "signed" begin
        for A in atypes, x in vals
            A <: ULogarithmic && x < 0 && continue
            y = A(x)
            @test signed(y) isa Logarithmic
            if x < 0
                @test_throws DomainError @inferred(unsigned(y))
            else
                @test @inferred(unsigned(y)) isa ULogarithmic
            end
        end
    end

    @testset "type functions" begin

        @testset "float" begin
            @test float(ULogFloat64) == Float64
            @test float(ULogFloat32) == Float32
            @test float(LogFloat64) == Float64
            @test float(LogFloat32) == Float32
        end

        @testset "widen" begin
            @test widen(ULogFloat64) == ULogarithmic{BigFloat}
            @test widen(ULogFloat32) == ULogFloat64
            @test widen(LogFloat64) == Logarithmic{BigFloat}
            @test widen(LogFloat32) == LogFloat64
        end

        @testset "big" begin
            @test big(ULogFloat64) == ULogarithmic{BigFloat}
            @test big(ULogFloat32) == ULogarithmic{BigFloat}
            @test big(LogFloat64) == Logarithmic{BigFloat}
            @test big(LogFloat32) == Logarithmic{BigFloat}
        end

        @testset "unsigned" begin
            @test unsigned(ULogFloat64) == ULogFloat64
            @test unsigned(ULogFloat32) == ULogFloat32
            @test unsigned(LogFloat64) == ULogFloat64
            @test unsigned(LogFloat32) == ULogFloat32
        end

        @testset "signed" begin
            @test signed(ULogFloat64) == LogFloat64
            @test signed(ULogFloat32) == LogFloat32
            @test signed(LogFloat64) == LogFloat64
            @test signed(LogFloat32) == LogFloat32
        end

    end

    @testset "special values" begin

        @testset "zero" begin
            @test zero(ULogarithmic) === exp(ULogarithmic, -Inf)
            @test zero(ULogFloat64) === exp(ULogFloat64, -Inf)
            @test zero(ULogFloat32) === exp(ULogFloat32, -Inf)
            @test zero(Logarithmic) === Logarithmic(zero(ULogarithmic))
            @test zero(LogFloat64) === LogFloat64(zero(ULogFloat64))
            @test zero(LogFloat32) === LogFloat32(zero(ULogFloat32))
        end

        @testset "one" begin
            @test one(ULogarithmic) === exp(ULogarithmic, 0.0)
            @test one(ULogFloat64) === exp(ULogFloat64, 0.0)
            @test one(ULogFloat32) === exp(ULogFloat32, 0.0)
            @test one(Logarithmic) === Logarithmic(one(ULogarithmic))
            @test one(LogFloat64) === LogFloat64(one(ULogFloat64))
            @test one(LogFloat32) === LogFloat32(one(ULogFloat32))
        end

        @testset "typemin" begin
            @test typemin(ULogFloat64) === ULogFloat64(0.0)
            @test typemin(ULogFloat32) === ULogFloat32(0.0)
            @test typemin(LogFloat64) === LogFloat64(-Inf)
            @test typemin(LogFloat32) === LogFloat32(-Inf)
        end

        @testset "typemax" begin
            @test typemax(ULogFloat64) === ULogFloat64(Inf)
            @test typemax(ULogFloat32) === ULogFloat32(Inf)
            @test typemax(LogFloat64) === LogFloat64(Inf)
            @test typemax(LogFloat32) === LogFloat32(Inf)
        end

    end

    @testset "predicates" begin

        @testset "iszero" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                @test @inferred(iszero(y)) == iszero(x)
            end
        end

        @testset "isone" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                @test @inferred(isone(y)) == isone(x)
            end
        end

        @testset "isinf" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                @test @inferred(isinf(y)) == isinf(x)
            end
        end

        @testset "isfinite" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                @test @inferred(isfinite(y)) == isfinite(x)
            end
        end

        @testset "isnan" begin
            for A in atypes, x in (vals..., NaN, -NaN)
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                @test @inferred(isnan(y)) == isnan(x)
            end
        end

    end

    @testset "ordering" begin

        @testset "sign" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                @test _float(@inferred(sign(y))) === float(sign(x))
            end
        end

        @testset "signbit" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                @test @inferred(signbit(y)) == signbit(x)
            end
        end

        @testset "abs" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                @test _approx(_float(@inferred(abs(y))), abs(x))
            end
        end

        @testset "==" begin
            for A in atypes, x1 in vals, x2 in vals
                A <: ULogarithmic && (x1 < 0 || x2 < 0) && continue
                y1 = A(x1)
                y2 = A(x2)
                @test @inferred(y1 == y2) == (x1 == x2)
            end
        end

        @testset "isequal" begin
            for A in atypes, x1 in vals, x2 in vals
                A <: ULogarithmic && (x1 < 0 || x2 < 0) && continue
                y1 = A(x1)
                y2 = A(x2)
                @test @inferred(isequal(y1, y2)) == isequal(x1, x2)
            end
        end

        @testset "<" begin
            for A in atypes, x1 in vals, x2 in vals
                A <: ULogarithmic && (x1 < 0 || x2 < 0) && continue
                y1 = A(x1)
                y2 = A(x2)
                @test @inferred(y1 < y2) == (x1 < x2)
            end
        end

        @testset "≤" begin
            for A in atypes, x1 in vals, x2 in vals
                A <: ULogarithmic && (x1 < 0 || x2 < 0) && continue
                y1 = A(x1)
                y2 = A(x2)
                @test @inferred(y1 ≤ y2) == (x1 ≤ x2)
            end
        end

        @testset "cmp" begin
            for A in atypes, x1 in vals, x2 in vals
                A <: ULogarithmic && (x1 < 0 || x2 < 0) && continue
                y1 = A(x1)
                y2 = A(x2)
                @test @inferred(cmp(y1, y2)) == cmp(x1, x2)
            end
        end

        @testset "isless" begin
            for A in atypes, x1 in vals, x2 in vals
                A <: ULogarithmic && (x1 < 0 || x2 < 0) && continue
                y1 = A(x1)
                y2 = A(x2)
                @test @inferred(isless(y1, y2)) == isless(x1, x2)
            end
        end

        @testset "nextfloat" begin
            for A in atypes, x in vals
                x isa AbstractFloat || continue
                @test @inferred(nextfloat(_exp(A, x))) === _exp(A, nextfloat(x))
            end
        end

        @testset "prevfloat" begin
            for A in atypes, x in vals
                x isa AbstractFloat || continue
                if A <: Logarithmic && x == -Inf
                    @test @inferred(prevfloat(_exp(A, x))) === -_exp(A, nextfloat(-Inf))
                else
                    @test @inferred(prevfloat(_exp(A, x))) === _exp(A, prevfloat(x))
                end
            end
        end

    end

    @testset "arithmetic" begin

        @testset "pos" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                @test _approx(_float(+A(x)), float(x))
            end
        end

        @testset "neg" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                @test _approx(_float(-A(x)), float(-x))
            end
        end

        @testset "add" begin
            for A in atypes, x in vals, y in vals
                A <: ULogarithmic && (x < 0 || y < 0) && continue
                @test _approx(_float(_add(A(x), A(y))), x+y)
            end
            # check accuracy
            # log(exp(1000) + exp(1001)) = 1000 + log(1 + exp(1))
            @test _approx(log(exp(Logarithmic, 1000) + exp(Logarithmic, 1001)), 1001.313261)
        end

        @testset "sum" begin
            for A in atypes, xs in vecs
                A <: ULogarithmic && any(x<0 for x in xs) && continue
                if eltype(xs) <: AbstractFloat
                    @test _approx(_float(_sum(map(x->A(x),xs))), sum(xs))
                else
                    # sum is not type-stable because typeof(xs[1]+xs[2]) != typeof(xs[1]).
                    # hence this test is the same as above but without the stability check.
                    # we don't promise type stability unless the base type is a float, so
                    # this isn't a broken test.
                    @test _approx(_float(sum(map(x->A(x),xs))), sum(xs))
                end
            end
        end

        @testset "sub" begin
            for A in atypes, x in vals, y in vals
                A <: ULogarithmic && (x < 0 || y < 0) && continue
                if A <: ULogarithmic && x < y
                    @test_throws DomainError _float(_sub(A(x), A(y)))
                else
                    @test _approx(_float(_sub(A(x), A(y))), x-y)
                end
            end
            # check accuracy
            # log(exp(1001) - exp(1000)) == 1000 + log(exp(1) - 1)
            @test _approx(log(exp(Logarithmic, 1001) - exp(Logarithmic, 1000)), 1000.541324)
            # log(exp(x) - exp(-x)) == x + log(1 - exp(-2x)) == x + log(-expm1(-2x))
            @test _approx(log(exp(Logarithmic, 1e-100) - exp(Logarithmic, -1e-100)), -229.565362)
        end

        @testset "mul" begin
            for A in atypes, x in vals, y in vals
                A <: ULogarithmic && (x < 0 || y < 0) && continue
                @test _approx(_float(_mul(A(x), A(y))), x * y)
            end
        end

        @testset "prod" begin
            for A in atypes, xs in vecs
                A <: ULogarithmic && any(x<0 for x in xs) && continue
                @test _approx(_float(_prod(map(x->A(x), xs))), prod(xs))
            end
        end

        @testset "div" begin
            for A in atypes, x in vals, y in vals
                A <: ULogarithmic && (x < 0 || y < 0) && continue
                @test _approx(_float(_div(A(x), A(y))), x / y)
            end
        end

        @testset "pow" begin
            for A in atypes, x in vals, n in (-2,-1,0,1,2,-1.1,0.0,2.3)
                x < 0 && continue
                @test _approx(_float(_pow(A(x), n)), float(x)^n)
            end
        end

        @testset "inv" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                @test _approx(_float(_inv(A(x))), inv(x))
            end
        end

        @testset "log" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                @test _log(_exp(A, x)) === x
                if x < 0
                    @test_throws DomainError _log(A(x))
                else
                    @test _approx(_log(A(x)), log(x))
                end
            end
            @test _approx(log(exp(Logarithmic, 1000)), 1000)
        end

        @testset "log2" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                if x < 0
                    @test_throws DomainError log2(A(x))
                else
                    @test _approx(log2(A(x)), log2(x))
                end
            end
            # log2(exp(x)) = x / log(2)
            @test _approx(log2(exp(Logarithmic, 1000)), 1442.695040)
        end

        @testset "log10" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                if x < 0
                    @test_throws DomainError log10(A(x))
                else
                    @test _approx(log10(A(x)), log10(x))
                end
            end
            # log10(exp(x)) = x / log(10)
            @test _approx(log10(exp(Logarithmic, 1000)), 434.294481)
        end

        @testset "log1p" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                if x < -1
                    @test_throws DomainError log1p(A(x))
                else
                    @test _approx(log1p(A(x)), log1p(x))
                end
            end
            @test _approx(log1p(exp(Logarithmic, 1000)), 1000.0)
        end

        @testset "exp" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                @test _approx(_float(exp(A(x))), exp(x))
            end
        end

    end

    @testset "hash" begin
        for A in atypes, x in vals
            A <: ULogarithmic && x < 0 && continue
            y = A(x)
            @test hash(y) isa UInt
        end
        for x in vals
            x < 0 && continue
            y1 = ULogarithmic(x)
            y2 = Logarithmic(x)
            @test hash(y1) == hash(y2)
            @test hash(-y1) == hash(-y2)
            @test hash(y1) != hash(-y1)
        end
    end

    @testset "random" begin
        for A in atypes2
            xs = rand(A, 1000)
            @test all(x isa A for x in xs)
            @test all(0 ≤ x ≤ 1 for x in xs)
        end
    end

    @testset "IO" begin

        @testset "show" begin
            @test repr(_exp(ULogarithmic, -12)) == "exp(-12)"
            @test repr(_exp(Logarithmic, -34)) == "+exp(-34)"
            @test repr(-_exp(Logarithmic, -45)) == "-exp(-45)"
        end

        @testset "read / write" begin
            for A in atypes, x in vals
                A <: ULogarithmic && x < 0 && continue
                y = A(x)
                io = IOBuffer()
                write(io, y)
                seekstart(io)
                z = read(io, typeof(y))
                @test y === z
            end
        end

    end

end
