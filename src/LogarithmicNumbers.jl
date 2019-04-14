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

end # module
