
# general
mutable struct System
	name::String
	numBodies::Int64
	numDofPerBody::Int64
	#body::Vector{Body}
end

function System(N::Int64, J::Int64; name::String="untitled")
	return System(name, N, J)
end

# local

mutable struct Body
	name::String
	mass::Float64
	pos::Vector{Float64}
	vel::Vector{Float64}
end

mutable struct ConfigurationSpace
	numCoordinates::Int64
end

ThreePlanets = System(2, 2, name="threebody")



b1 = Body("mass 1", 1.0, q, Dq)
