rand(rng::AbstractRNG, ::Random.SamplerType{E}) where {T<:AbstractFloat, E<:RealLog{T}} =
	exp(E, -randexp(rng, T))
rand(rng::AbstractRNG, ::Random.SamplerType{E}) where {E<:RealLog} =
	exp(E, -randexp(rng))

# todo: sample CLogarithmic
# (note that rand(Complex) samples uniformly from the unit square)