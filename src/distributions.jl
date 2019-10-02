import .Distributions

Distributions.cdf(::Type{E}, args...; opts...) where {E<:AnyLog} = exp(E, Distributions.logcdf(args...; opts...))
Distributions.ccdf(::Type{E}, args...; opts...) where {E<:AnyLog} = exp(E, Distributions.logccdf(args...; opts...))
Distributions.pdf(::Type{E}, args...; opts...) where {E<:AnyLog} = exp(E, Distributions.logpdf(args...; opts...))
