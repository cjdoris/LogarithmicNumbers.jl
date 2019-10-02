atypes = (ULogarithmic, Logarithmic, CLogarithmic)

# logarithmic + logarithmic

for (i,A) in enumerate(atypes)
	for (j,B) in enumerate(atypes)
		C = i<j ? B : A
		@eval promote_rule(::Type{$A}, ::Type{$B}) = $C
		@eval promote_rule(::Type{$A}, ::Type{$B{T}}) where {T} = $C{T}
		@eval promote_rule(::Type{$A{T}}, ::Type{$B}) where {T} = $C{T}
		@eval promote_rule(::Type{$A{S}}, ::Type{$B{T}}) where {S,T} =
			$C{promote_type(S,T)}
    end
end

# logarithmic + real

# generated for type-stability
@generated promote_rule(::Type{ULogarithmic}, ::Type{R}) where {R<:Real} =
	try
		:($(typeof(ULogarithmic(one(R)))))
	catch
		:(Union{})
	end

promote_rule(::Type{A}, ::Type{R}) where {A<:AnyLog, R<:Real} =
	promote_type(A, promote_type(ULogarithmic, R))

# logarithmic + complex
# only CLogarithmic+Complex is promoted, so that Logarithmic+Complex is promoted to Complex{Logarithmic}

# generated for type-stability
@generated promote_rule(::Type{CLogarithmic}, ::Type{C}) where {C<:Complex} =
	try
		:($(typeof(CLogarithmic(one(C)))))
	catch
		:(Union{})
	end

promote_rule(::Type{CLogarithmic{T}}, ::Type{C}) where {T, C<:Complex} =
	promote_type(CLogarithmic{T}, promote_type(CLogarithmic, C))
