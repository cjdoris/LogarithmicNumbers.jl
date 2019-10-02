"""
A [logarithmic number system](https://en.wikipedia.org/wiki/Logarithmic_number_system).

Provides the signed [`Logarithmic`](@ref) and unsigned [`ULogarithmic`](@ref) types, which represent real numbers and positive real numbers respectively.
"""
module LogarithmicNumbers

using Requires, Random

import Base:
	exp, log, *, /, ^, inv, +, -, prod, sum, angle, show,
	write, read, float, big, unsigned, signed, widen,
	typemin, typemax, zero, one, iszero, isone, isinf,
	isfinite, isnan, sign, signbit, abs, ==, isequal, <, ≤,
	cmp, isless, nextfloat, prevfloat, rand, promote_rule,
	conj, real, imag

export ULogarithmic, Logarithmic, CLogarithmic

include("types.jl")
include("constructors.jl")
include("ulogarithmic.jl")
include("logarithmic.jl")
include("clogarithmic.jl")
include("promotion.jl")
include("arithmetic.jl")
include("random.jl")
include("io.jl")
include("init.jl")

# type aliases
for T in (Float64, Float32, Float16, BigFloat)
  ULogT = Symbol(:ULog, T)
  LogT = Symbol(:Log, T)
  CLogT = Symbol(:CLog, T)
  @eval begin
      const $(ULogT) = $(ULogarithmic{T})
      const $(LogT) = $(Logarithmic{T})
      const $(CLogT) = $(CLogarithmic{T})
      export $(ULogT), $(LogT), $(CLogT)
  end
end

end # module
