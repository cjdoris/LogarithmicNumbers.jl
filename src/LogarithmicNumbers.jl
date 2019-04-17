"""
A [logarithmic number system](https://en.wikipedia.org/wiki/ULogarithmic_number_system).

Provides the signed [`Logarithmic`](@ref) and unsigned [`ULogarithmic`](@ref) types, which represent real numbers and positive real numbers respectively.
"""
module LogarithmicNumbers

using Requires, Random

export ULogarithmic, Logarithmic

include("types.jl")
include("constructors.jl")
include("logarithmic.jl")
include("slogarithmic.jl")
include("promotion.jl")
include("arithmetic.jl")
include("io.jl")
include("init.jl")

# type aliases
for T in (Float64, Float32, Float16, BigFloat)
  @eval const $(Symbol(:ULog,T)) = ULogarithmic{$T}
  @eval const $(Symbol(:Log,T)) = Logarithmic{$T}
  @eval export $(Symbol(:ULog,T)), $(Symbol(:Log,T))
end

end # module
