"""
Provides the [`Logarithmic`](@ref) type, which represents a positive real number by its logarithm, and the [`SLogarithmic`](@ref) type which is a signed version.
"""
module LogarithmicNumbers

using Requires, Random

export Logarithmic, SLogarithmic

include("types.jl")
include("constructors.jl")
include("logarithmic.jl")
include("slogarithmic.jl")
include("promotion.jl")
include("arithmetic.jl")
include("io.jl")
include("init.jl")

end # module
