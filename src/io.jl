function Base.show(io::IO, x::Logarithmic)
  print(io, "exp(")
  show(io, x.log)
  print(io, ")")
end

function Base.show(io::IO, x::SLogarithmic)
  x.signbit && print(io, "-")
  show(io, x.abs)
end

Base.write(io::IO, x::Logarithmic) = write(io, x.log)
Base.write(io::IO, x::SLogarithmic) = write(io, x.abs, x.signbit)

Base.read(io::IO, ::Type{Logarithmic{T}}) where {T} = exp(T, read(io, T))
Base.read(io::IO, ::Type{SLogarithmic{T}}) where {T} = exptosexp(T, read(io, Logarithmic{T}), read(io, Bool))