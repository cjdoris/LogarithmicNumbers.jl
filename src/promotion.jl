promote_rule(::Type{ULogarithmic{T}}, ::Type{ULogarithmic{R}}) where {T,R} = ULogarithmic{promote_type(T,R)}
promote_rule(::Type{ULogarithmic{T}}, ::Type{Logarithmic{R}}) where {T,R} = Logarithmic{promote_type(T,R)}
promote_rule(::Type{Logarithmic{T}}, ::Type{Logarithmic{R}}) where {T,R} = Logarithmic{promote_type(T,R)}
promote_rule(::Type{Logarithmic{T}}, ::Type{ULogarithmic{R}}) where {T,R} = Logarithmic{promote_type(T,R)}
promote_rule(::Type{ULogarithmic{T}}, ::Type{R}) where {T,R<:Real} = try ULogarithmic{promote_type(T,typeof(log(one(R))))}; catch; Union{}; end
promote_rule(::Type{Logarithmic{T}}, ::Type{R}) where {T,R<:Real} = try ULogarithmic{promote_type(T,typeof(log(one(R))))}; catch; Union{}; end
