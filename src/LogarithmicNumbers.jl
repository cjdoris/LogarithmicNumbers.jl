"""
A [logarithmic number system](https://en.wikipedia.org/wiki/Logarithmic_number_system).

Provides the signed [`Logarithmic`](@ref) and unsigned [`ULogarithmic`](@ref) types, which represent real numbers and positive real numbers respectively.
"""
module LogarithmicNumbers

using Requires, Random

import Base: exp, log, *, /, ^, inv, +, -, prod, sum, show, write, read, float, big, unsigned, signed, widen, typemin, typemax, zero, one, iszero, isone, isinf, isfinite, isnan, sign, signbit, abs, ==, <, ≤, cmp, isless, nextfloat, prevfloat, rand, promote_rule

export AbstractLogarithmic, ULogarithmic, Logarithmic

include("types.jl")
include("constructors.jl")
include("ulogarithmic.jl")
include("logarithmic.jl")
include("promotion.jl")
include("arithmetic.jl")
include("random.jl")
include("io.jl")
include("init.jl")

# type aliases
for T in (Float64, Float32, Float16, BigFloat)
  ULogT = Symbol(:ULog, T)
  LogT = Symbol(:Log, T)
  @eval begin
      const $(ULogT) = $(ULogarithmic{T})
      const $(LogT) = $(Logarithmic{T})
      export $(ULogT), $(LogT)
  end
end

end # module
