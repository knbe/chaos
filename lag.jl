

mutable struct Manifold
	name::String
	D::Int64	# dimensions
	coord
end

mutable struct System
	name::String
	param1::Float64
end

#mutable struct γ
#	path
#end

struct path{T}
	p::T
end

function path(t)
	return
end

struct localtuple{T}
	t
	p::T
	Dp::T
end


# use the map function for coordinate transforms and shit
# map(x -> x^2 + 1, [ a, b, a ])
