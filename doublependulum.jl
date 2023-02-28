using Plots

mutable struct PhaseSpace
	θ::Vector{Float64}
	pθ::Vector{Float64}
	PhaseSpace(θ, pθ) = new(θ, pθ)
end

mutable struct DoublePendulum
	ξ::PhaseSpace
	m::Float64
	l::Float64
	DoublePendulum(ξ, m, l) = new(ξ, m, l)
end

function get_Dξ(sys::DoublePendulum)
	g = -9.81
	θ = sys.ξ.θ
	pθ = sys.ξ.pθ
	m = sys.m
	l = sys.l

	Dθ_1 = (6 / m * l^2) * 
		(2 * pθ[1] - 3 * cos(θ[1] - θ[2]) * pθ[2]) / 
		(16 - 9 * cos(θ[1] - θ[2])^2)

	Dθ_2 = (6 / m * l^2) * 
		(8 * pθ[1] - 3 * cos(θ[1] - θ[2]) * pθ[1]) / 
		(16 - 9 * cos(θ[1] - θ[2])^2)

	Dpθ_1 = (-0.5 * m * l^2) * (Dθ_1 * Dθ_2 * sin(θ[1] - θ[2]) + 3 * (g/l) * sin(θ[1]))
	Dpθ_2 = (-0.5 * m * l^2) * (-Dθ_1 * Dθ_2 * sin(θ[1] - θ[2]) + (g/l) * sin(θ[2]))

	return [Dθ_1, Dθ_2], [Dpθ_1, Dpθ_2]

end

function integrate_euler(sys::DoublePendulum, dt::Float64)
	θ = sys.ξ.θ
	pθ = sys.ξ.pθ
	Dθ, Dpθ = get_Dξ(sys)

	pθ_new = pθ .+ Dpθ .* dt
	θ_new = θ .+ Dθ .* dt

	ξ_new = PhaseSpace(θ_new, pθ_new)

	return ξ_new

#	x = Γ[1]
#	v = Γ[2]
#	v_new = v + a .* dt
#	x_new = x + v_new .* dt
#	return [x_new, v_new]
end

function tmp()
	
end

function evolve!(sys::DoublePendulum, dt::Float64, tt::Float64)

	nt = Int64(tt/dt)
	θdata = [ sys.ξ.θ ]
	pθdata = [ sys.ξ.pθ ]

	println(θdata[1])
	
	for t in 1:nt
		ξ_new = integrate_euler(sys, dt::Float64)
		sys.ξ = ξ_new
		
		push!(θdata, sys.ξ.θ)
		push!(pθdata, sys.ξ.pθ)
	end

	θ1data = [ θdata[i][1] for i in 1:nt ]
	pθ1data = [ pθdata[i][1] for i in 1:nt ]
	θ2data = [ θdata[i][2] for i in 1:nt ]
	pθ2data = [ pθdata[i][2] for i in 1:nt ]
	plot(θ1data, pθ1data)
	plot!(θ2data, pθ2data)

end

function initialize()
	θ₀ = [π/8, 0]
	pθ₀ = [0.0, 0.0]
	m = 1.0
	l = 1.0

	ξ = PhaseSpace(θ₀, pθ₀)
	sys = DoublePendulum(ξ, m, l)
	return sys
end

sys = initialize()
evolve!(sys, 0.001, 10.0)
