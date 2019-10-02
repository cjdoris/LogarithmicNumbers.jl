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
vals = (-Inf, -100, -100.0, -2, -2.0, -1, -1.0, -0.5, 0, 0.0, 0.5, 1, 1.0, 2, 2.0, 100, 100.0, Inf)

# sample vectors
vecs = (
	Float64[x for x in vals if x isa Float64],
	Float64[x for x in vals if x isa Float64 && !isinf(x)],
	Float64[x for x in vals if x isa Float64 && !iszero(x)],
	Float64[x for x in vals if x isa Float64 && !isinf(x) && x ≥ 0],
	Int[x for x in vals if x isa Int],
	Int[x for x in vals if x isa Int && x ≥ 0],
)

atypes = (ULogarithmic, Logarithmic, CLogarithmic)

@testset "LogarithmicNumbers" begin

	@testset "types" begin
	    @test @isdefined ULogarithmic
	    @test @isdefined Logarithmic
	    @test @isdefined CLogarithmic
	end

	@testset "exp" begin
		for A in atypes, x in vals
			@test _exp(A, x) isa A{typeof(x)}
		end
	end

	@testset "convert" begin
	    for A in atypes, x in vals
	    	if x < 0 && A == ULogarithmic
	    		@test_throws DomainError A(x)
	    	else
	    		@test (@inferred A(x)) isa A
	    	end
	    end
	end

    @testset "log" begin
    	for A in atypes, x in vals
    		y = A==CLogarithmic ? Complex(x) : x
			@test _log(_exp(A, x)) === y
    	end
    end

	@testset "float" begin
	    for A in atypes, x in vals
	    	_float(_exp(A, x)) ≈ exp(x) || @info("float1",A,x)
	    	@test _float(_exp(A, x)) ≈ exp(x)
	    	if x < 0 && A == ULogarithmic
	    		nothing
	    	elseif x==-Inf && A == CLogarithmic
	    		@test AbstractFloat(A(x)) == x
	    	else
	    		@test _float(A(x)) ≈ x
	    	end
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
			if isinf(x) && iszero(n)
				# should be 1.0 but is NaN
				@test_broken _approx(_float(_pow(_exp(A, x), n)), exp(x)^n)
				@test isnan(_float(_pow(_exp(A, x), n)))
			else
			    @test _approx(_float(_pow(_exp(A, x), n)), exp(x)^n)
			end
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
	    	elseif A==CLogarithmic && y==Inf && x<y
	    		@test_broken _approx(_float(_sub(_exp(A, x), _exp(A, y))), exp(x)-exp(y))
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