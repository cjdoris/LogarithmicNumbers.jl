Base.promote_rule(::Type{Logarithmic{T}}, ::Type{Logarithmic{R}}) where {T,R} = Logarithmic{promote_type(T,R)}
Base.promote_rule(::Type{Logarithmic{T}}, ::Type{SLogarithmic{R}}) where {T,R} = SLogarithmic{promote_type(T,R)}
Base.promote_rule(::Type{SLogarithmic{T}}, ::Type{SLogarithmic{R}}) where {T,R} = SLogarithmic{promote_type(T,R)}
Base.promote_rule(::Type{SLogarithmic{T}}, ::Type{Logarithmic{R}}) where {T,R} = SLogarithmic{promote_type(T,R)}
Base.promote_rule(::Type{Logarithmic{T}}, ::Type{R}) where {T,R<:Real} = Logarithmic{promote_type(T,typeof(log(one(R))))}
Base.promote_rule(::Type{SLogarithmic{T}}, ::Type{R}) where {T,R<:Real} = Logarithmic{promote_type(T,typeof(log(one(R))))}
