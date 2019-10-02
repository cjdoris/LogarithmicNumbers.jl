import .StatsFuns

for lfn in propertynames(StatsFuns)
  m = match(r"^(.*)log(pdf|cdf|ccdf)", string(lfn))
  if m !== nothing
    fn = Symbol(m[1], m[2])
    @eval StatsFuns.$(fn)(::Type{E}, args...; opts...) where {E<:AnyLog} = exp(E, StatsFuns.$(lfn)(args...; opts...))
  end
end