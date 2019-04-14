function Base.show(io::IO, x::ULogarithmic)
  print(io, "exp(")
  show(io, x.log)
  print(io, ")")
end

function Base.show(io::IO, x::Logarithmic)
  x.signbit && print(io, "-")
  show(io, x.abs)
end

Base.write(io::IO, x::ULogarithmic) = write(io, x.log)
Base.write(io::IO, x::Logarithmic) = write(io, x.abs, x.signbit)

Base.read(io::IO, ::Type{ULogarithmic{T}}) where {T} = exp(T, read(io, T))
Base.read(io::IO, ::Type{Logarithmic{T}}) where {T} = exptosexp(T, read(io, ULogarithmic{T}), read(io, Bool))