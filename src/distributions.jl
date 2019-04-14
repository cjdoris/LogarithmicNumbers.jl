import .Distributions

Distributions.cdf(::Type{E}, args...; opts...) where {E<:Union{ULogarithmic,Logarithmic}} = Base.exp(E, Distributions.logcdf(args...; opts...))
Distributions.ccdf(::Type{E}, args...; opts...) where {E<:Union{ULogarithmic,Logarithmic}} = Base.exp(E, Distributions.logccdf(args...; opts...))
Distributions.pdf(::Type{E}, args...; opts...) where {E<:Union{ULogarithmic,Logarithmic}} = Base.exp(E, Distributions.logpdf(args...; opts...))
