using LogarithmicNumbers, Test

_approx(x,y) = isapprox(x, y, atol=1e-3) || (isnan(x) && isnan(y))

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
vals = (-Inf, -20, -20.0, -2, -2.0, -1, -1.0, -0.5, 0, 0.0, 0.5, 1, 1.0, 2, 2.0, 20, 20.0, Inf)

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
					@test y.log ≈ log(x)
				else
					@test y.abs.log ≈ log(abs(x))
					@test y.signbit ≈ signbit(x)
				end
			end
		end
	end

	@testset "float" begin
		for A in atypes2, x in vals
			A <: ULogarithmic && x < 0 && continue
			y = A(x)
			@test _float(y) isa AbstractFloat
			@test _float(y) ≈ Float32(x)
			@test @inferred(AbstractFloat(y)) isa AbstractFloat
			@test @inferred(AbstractFloat(y)) ≈ Float32(x)
			@test @inferred(Float64(y)) isa Float64
			@test @inferred(Float64(y)) ≈ Float32(x)
			@test @inferred(Float32(y)) isa Float32
			@test @inferred(Float32(y)) ≈ Float32(x)
		end
	end

	@testset "big" begin
		for A in atypes, x in vals
			A <: ULogarithmic && x < 0 && continue
			y = A(x)
			z = @inferred big(y)
			B = A <: ULogarithmic ? ULogarithmic{BigFloat} : Logarithmic{BigFloat}
			@test z isa B
			@test _float(z) ≈ Float32(x)
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
			@test zero(ULogFloat64) === exp(ULogFloat64, -Inf)
			@test zero(ULogFloat32) === exp(ULogFloat32, -Inf)
			@test zero(LogFloat64) === LogFloat64(zero(ULogFloat64))
			@test zero(LogFloat32) === LogFloat32(zero(ULogFloat32))
		end

		@testset "one" begin
			@test one(ULogFloat64) === exp(ULogFloat64, 0)
			@test one(ULogFloat32) === exp(ULogFloat32, 0)
			@test one(LogFloat64) === LogFloat64(one(ULogFloat64))
			@test one(LogFloat32) === LogFloat32(one(ULogFloat32))
		end

		@testset "typemin" begin
			@test typemin(ULogFloat64) === ULogFloat64(0)
			@test typemin(ULogFloat32) === ULogFloat32(0)
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
				@test @inferred(sign(y)) == sign(y)
			end
		end

		@testset "signbit" begin
			for A in atypes, x in vals
				A <: ULogarithmic && x < 0 && continue
				y = A(x)
				@test @inferred(signbit(y)) == signbit(y)
			end
		end

		@testset "abs" begin
			for A in atypes, x in vals
				A <: ULogarithmic && x < 0 && continue
				y = A(x)
				@test float(@inferred(abs(y))) ≈ abs(x)
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
				@test @inferred(nextfloat(_exp(A, x))) == _exp(A, nextfloat(x))
			end
		end

		@testset "prevfloat" begin
			for A in atypes, x in vals
				x isa AbstractFloat || continue
				if A <: Logarithmic && x == -Inf
					@test @inferred(prevfloat(_exp(A, x))) == -_exp(A, nextfloat(-Inf))
				else
					@test @inferred(prevfloat(_exp(A, x))) == _exp(A, prevfloat(x))
				end
			end
		end

	end

	@testset "arithmetic" begin

		@testset "pos" begin
			for A in atypes, x in vals
				A <: ULogarithmic && x < 0 && continue
				@test float(+A(x)) ≈ float(x)
			end
		end

		@testset "neg" begin
			for A in atypes, x in vals
				A <: ULogarithmic && x < 0 && continue
				@test float(-A(x)) ≈ float(-x)
			end
		end

		@testset "add" begin
			for A in atypes, x in vals, y in vals
				A <: ULogarithmic && (x < 0 || y < 0) && continue
				@test _approx(_float(_add(A(x), A(y))), x+y)
			end
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
					@test _log(A(x)) ≈ log(x)
				end
			end
		end

		@testset "exp" begin
			for A in atypes, x in vals
				A <: ULogarithmic && x < 0 && continue
				@test float(exp(A(x))) ≈ exp(x)
			end
		end

	end

	@testset "random" begin
		for A in atypes
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
