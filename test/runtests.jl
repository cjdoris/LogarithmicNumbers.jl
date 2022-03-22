using LogarithmicNumbers, Test

_approx(x,y) = (x ≈ y) || (isnan(x) && isnan(y))

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

    @testset "log" begin
    	for A in atypes, x in vals
			@test _log(_exp(A, x)) === x
    	end
    end

    @testset "mul" begin
    	for A in atypes, x in vals, y in vals
    		@test _approx(_float(_mul(_exp(A, x), _exp(A, y))), exp(x) * exp(y))
    	end
    end

    @testset "div" begin
    	for A in atypes, x in vals, y in vals
    		@test _approx(_float(_div(_exp(A, x), _exp(A, y))), exp(x) / exp(y))
    	end
    end

    @testset "pow" begin
		for A in atypes, x in vals, n in (-2,-1,0,1,2,-1.1,0.0,2.3)
			@test _approx(_float(_pow(_exp(A, x), n)), exp(x)^n)
        end
    end

    @testset "inv" begin
        for A in atypes, x in vals
            @test _approx(_float(_inv(_exp(A, x))), inv(exp(x)))
        end
    end

    @testset "add" begin
        for A in atypes, x in vals, y in vals
    		@test _approx(_float(_add(_exp(A, x), _exp(A, y))), exp(x)+exp(y))
        end
    end

    @testset "sub" begin
        for A in atypes, x in vals, y in vals
        	if A==ULogarithmic && x<y
	    		@test_throws DomainError _float(_sub(_exp(A, x), _exp(A, y)))
	    	else
	    		@test _approx(_float(_sub(_exp(A, x), _exp(A, y))), exp(x)-exp(y))
	    	end
        end
    end

    @testset "prod" begin
        for A in atypes, xs in vecs
        	_approx(_float(_prod(map(x->_exp(A,x), xs))), prod(exp.(xs))) || @info("prod",A,xs)
        	@test _approx(_float(_prod(map(x->_exp(A,x), xs))), prod(exp.(xs)))
        end
    end

    @testset "sum" begin
        for A in atypes, xs in vecs
        	if eltype(xs) <: AbstractFloat
	            @test _approx(_float(_sum(map(x->exp(A,x),xs))), sum(exp.(xs)))
	        else
	        	# sum is not type-stable because typeof(xs[1]+xs[2]) != typeof(xs[1]).
	        	# hence this test is the same as above but without the stability check.
	        	# we don't promise type stability unless the base type is a float, so
	        	# this isn't a broken test.
	        	@test _approx(_float(sum(map(x->exp(A,x),xs))), sum(exp.(xs)))
	        end
        end
    end

end
