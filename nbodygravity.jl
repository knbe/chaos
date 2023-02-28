
mutable struct State
	t::Float64
	q::Vector{Float64}
	Dq::Vector{Float64}
end

mutable struct Body
	name::String
	mass::Float64
	r::Vector{Float64}
	v::Vector{Float64}
	Body(name, mass, r, v) = new(name, mass, r, v)
end

mutable struct System
	numBodies
	body::Vector{Body}
	#state::State
end

function get_pos(state::State, i::Int64)

end

function initialize(bodies::Vector{Body})
	numBodies = length(bodies)
	s = System(numBodies, bodies)
	return s
end

function evolve!(s::System)
end

function demo()
	b1 = Body("sun", 0.995, [0.0, 0.0, 0.0], [0.0, 0.0, 0.0])
	b2 = Body("earth", 0.005, [1.0, 0.0, 0.0], [0.0, 1.0, 0.0])
	b3 = Body("L4", 0.0001, [0.495, -sqrt(3)/2, 0.0], [sqrt(3)/2, 0.495, 0.0])

	#s = System(3, [b1, b2, b3], 
	s = initialize([b1, b2, b3])

	evolve!(s)

	#println(s.body[3].r)

end
