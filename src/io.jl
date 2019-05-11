function show(io::IO, x::ULogarithmic)
  print(io, "exp(")
  show(io, x.log)
  print(io, ")")
end

function show(io::IO, x::Logarithmic)
  x.signbit && print(io, "-")
  show(io, x.abs)
end

write(io::IO, x::ULogarithmic) = write(io, x.log)
write(io::IO, x::Logarithmic) = write(io, x.abs, x.signbit)

read(io::IO, ::Type{ULogarithmic{T}}) where {T} = uexp(T, read(io, T))
read(io::IO, ::Type{Logarithmic{T}}) where {T} = Logarithmic{T}(read(io, ULogarithmic{T}), read(io, Bool))