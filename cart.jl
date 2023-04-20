const global g::Float64 = 9.81 # grav. acc. constant
const global dt::Float64 = 0.001 # time step

mutable struct Pendulum
	mass::Float64
	length::Float64	# rod length
	position::Vector{Vector{Float64}}
	velocity::Vector{Vector{Float64}}
end

mutable struct Cart
	mass::Float64
	width::Float64	# physical width of cart in x-direc
	position::Vector{Vector{Float64}}
	velocity::Vector{Vector{Float64}}
end

function Pendulum(; mass=1.0, length=1.0)
	position = Vector{Float64}[]
	velocity = Vector{Float64}[]
	return Pendulum(mass, length, position, velocity)
end

function Cart(; mass=1.0, width=2.0)
	position = Vector{Float64}[]
	velocity = Vector{Float64}[]
	return Cart(mass, width, position, velocity)
end

function initialize_system!(
	pen1::Pendulum, pen2::Pendulum, cart::Cart; 
	θ₁::Float64=30.0, θ₂::Float64=30.0, x₃::Float64=0.0)
	
	push!(cart.position, [x₃, 0.0])
	push!(pen1.position, [x₃ - cart.width / 2 - pen1.length*sind(θ₁), -pen1.length*cosd(θ₁)])
	push!(pen2.position, [x₃ + cart.width / 2 + pen2.length*sind(θ₂), -pen2.length*cosd(θ₂)])
end

function evolve!(pen1::Pendulum, pen2::Pendulum, cart)

	totaltime = 20.0
	numsteps = Int(floor(totaltime / dt))

	for step in 1:numsteps

	end

end

function main()
	pen1 = Pendulum()
	pen2 = Pendulum()
	cart = Cart()
	
	initialize_system!(
		pen1, 
		pen2, 
		cart; 
		θ₁=30.0, 
		θ₂=30.0, 
		x₃=0.0
	)

	evolve!(pen1, pen2, cart)
end
