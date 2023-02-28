# "physical" pendulum

using Plots

mutable struct Pendulum
	Γ	# tuple of phase coordinates

	t::Float64		# current time (manifold time)
	dt::Float64		# time step
	tt::Float64		# total time 
	nt::Int64		# num time steps

	g::Float64
	l::Float64
	c::Float64
	Ω_d::Float64
	f_d::Float64
end

function initialize()
	θ₀ = 0.2
	dθ₀ = 0
	Γ = [ [θ₀,dθ₀] ]

	t = 0.0
	dt = 0.001
	tt = 60.0
	nt = Int64(tt/dt)

	g = 9.81
	l = 9.81
	c = 0.5
	Ω_d = 2/3
	f_d = 1.2

	return Pendulum(Γ, t, dt, tt, nt, g, l, c, Ω_d, f_d)
end

function integrate_verlet(p::Pendulum, a::Float64, t::Int64)
	θ = p.Γ[t][1]
	dθ = p.Γ[t][2]
	dt = p.dt

	if t == 1
		dθ_new = dθ + a * dt * 0.5
		θ_new = θ + dθ_new * dt * 0.5
	else
		dθ_new = p.Γ[t-1][2] + a * dt
		θ_new = θ + dθ_new * dt
	end

	return [θ_new, dθ_new]
end

function integrate_euler_cromer(p::Pendulum, a::Float64, t::Int64)
	θ = p.Γ[t][1]
	dθ = p.Γ[t][2]
	dt = p.dt

	dθ_new = dθ + a * dt
	θ_new = θ + dθ_new * dt

	return [θ_new, dθ_new]
end


function get_acceleration(p::Pendulum, t::Int64, time::Float64)
	θ = p.Γ[t][1]
	dθ = p.Γ[t][2]
	g = p.g
	l = p.l
	c = p.c
	f_d = p.f_d
	Ω_d = p.Ω_d
	accel = -(g/l) * sin(θ) - c*dθ + f_d * sin(Ω_d * p.t)
	return accel
end

function evolve!(p::Pendulum)
	time = 0.0
	for t in 1:p.nt
		# compute acceleration
		a = get_acceleration(p, t, time)
		#println("t = ", t, p.Γ[t], a)

		# integrate to new positions
		Γ_new = integrate_verlet(p, a, t)
		#Γ_new = integrate_euler_cromer(p, a, t)
		
#		if Γ_new[1] > π
#			Γ_new[1] -= 2π
#		elseif Γ_new[1] < π
#			Γ_new[1] += 2π
#		end

		p.t += p.dt
		time += p.dt

		push!(p.Γ, Γ_new)
	end
end

function make_plot(p::Pendulum)
	plot()

	tdata = (0.0:(p.dt):(p.tt - p.dt))
	θdata = [p.Γ[t][1] for t in 1:p.nt]
	dθdata = [p.Γ[t][2] for t in 1:p.nt]

	plot!(tdata, θdata)
	#plot!(θdata, dθdata)
	#ylims!(-2π,2π)
	plot!()
end

function run()
	p = initialize()

	evolve!(p)
	make_plot(p)
end

run()
