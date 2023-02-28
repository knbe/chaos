using Plots

# "state" struct
# contains the state space configuration at time t
mutable struct State
	t::Float64	# time
	q::Float64	# generalised coordinate
	Dq::Float64	# generalised velocity
end

# pendulum struct
# contains the pendulum's configuration state and other parameters
mutable struct Pendulum
	state::State	# configuration state at time t
	m::Float64	# mass
	g::Float64	# gravity
	l::Float64	# length
	c::Float64	# damping coeff.
	Ω_d::Float64	# driving freq.
	f_d::Float64	# amplitude
end

# function to initialize/construct a pendulum
function Pendulum()
	# initial conditions (default values)
	t = 0.0		# initial time
	θ₀ = 0.2	# initial θ (angular coordinate)
	Dθ₀ = 0.0	# initial Dθ (angular velocity)
	state = State(t, θ₀, Dθ₀) # initial state space configuration

	# parameters (defaults)
	m = 1.0	
	g = 9.81
	l = 9.81
	c = 0.5
	Ω_d = 2/3
	f_d = 1.2

	return Pendulum(state, m, g, l, c, Ω_d, f_d)
end

# compute acceleration
function get_acceleration(p::Pendulum)
	g = p.g
	l = p.l
	θ = p.state.q
	Dθ = p.state.Dq
	c = p.c
	Ω_d = p.Ω_d
	f_d = p.f_d
	t = p.state.t

	acceleration = -(g/l) * sin(θ) - c * Dθ + f_d * sin(Ω_d * t)
	return acceleration
end

# integrator
function integrate_euler_cromer!(state::State, acceleration::Float64, dt::Float64)

	state.Dq += acceleration * dt
	state.q += state.Dq * dt
	state.t += dt

	return state
end

function print_params(p, tt, dt, nt)
	println("initial state: ", p.state)
	println("m:		", p.m)
	println("g:		", p.g)
	println("l:		", p.l)
	println("c:		", p.c)
	println("Ω_d:		", p.Ω_d)
	println("f_d:		", p.f_d)
	println("tt:		", tt)
	println("dt:		", dt)
	println("nt:		", nt)
end

function evolve!(p::Pendulum, nt::Int, dt::Float64, data)
	for t in 1:nt
		# compute acceleration
		acceleration = get_acceleration(p)

		# compute new state at t + dt
		new_state = integrate_euler_cromer!(p.state, acceleration, dt)

		# evolve pendulum to new state
		p.state = new_state
		push!(data, [ p.state.t, p.state.q, p.state.Dq ])
	end
end

function movetorange(x)
	if x > π
		while x > π
			x -= 2π
		end
	end
	if x < -π
		while x < -π
			x += 2π
		end
	end
	return x
end

function make_plots(data, p::Pendulum, tt::Float64, dt::Float64)
	t = [ data[i][1] for i in 1:length(data) ]
	θ = [ data[i][2] for i in 1:length(data) ]
	θ_mod = map(movetorange, θ)
	Dθ = [ data[i][3] for i in 1:length(data) ]

	θt_plot = plot(t, θ, 
			xlabel="t (s)", 
			ylabel="θ (rad)",
			color="black",
			size=(600,400),
			linewidth=.2,
			)
	θt_mod_plot = plot(t, θ_mod, 
			xlabel="t (s)", 
			ylabel="θ (rad)",
			color="black",
			size=(600,400),
			linewidth=.2,
			)
	phase_plot = plot(θ, Dθ, 
			xlabel="θ (rad)", 
			ylabel="Dθ (rad/s)",
			color="black",
			size=(600,400),
			linewidth=.2,
			)
	phase_mod_plot = plot(θ_mod, Dθ, 
			xlabel="θ (rad)", 
			ylabel="Dθ (rad/s)",
			color="black",
			size=(600,400),
			linewidth=.01,
			)


	# poincare plot
	n_max = floor(tt/(2π/p.Ω_d))

	poincare_θ = [ ]
	poincare_Dθ = [ ]
	for n in 1:n_max
		sampling_time = (2π * n) / p.Ω_d
		approx_index = Int64(round(sampling_time / dt))
		push!(poincare_θ, θ_mod[approx_index])
		push!(poincare_Dθ, Dθ[approx_index])
		n += 1
	end

	poincare_map = scatter(poincare_θ, poincare_Dθ, 
				xlabel="θ (rad)", 
				ylabel="Dθ (rad/s)", 
				color="black",
				markersize=1.0,
				size=(600,400),
				)


	# poincare plot at max drive force
	#n_max = floor(tt/((2π - π/4)/p.Ω_d))

	poincare_θ_max = [] 
	poincare_Dθ_max = []
	for n in 1:n_max
		sampling_time = (2π * n - π/4) / p.Ω_d
		approx_index = Int64(round(sampling_time / dt))
		push!(poincare_θ_max, θ_mod[approx_index])
		push!(poincare_Dθ_max, Dθ[approx_index])
		n += 1
	end

	poincare_map_max = scatter(poincare_θ_max, poincare_Dθ_max, 
				xlabel="θ (rad)", 
				ylabel="Dθ (rad/s)", 
				color="black",
				markersize=1.0,
				size=(600,400),
				)

	plot(θt_plot, phase_mod_plot, poincare_map, poincare_map_max)

end

function run(tt::Float64=100.0, dt::Float64=0.001)
	nt = Int64(tt/dt) # number of time steps
	p = Pendulum()	# initialize pendulum
	data = [[ p.state.t, p.state.q, p.state.Dq ]] # data array
	print_params(p, tt, dt, nt)
	evolve!(p, nt, dt, data)
	make_plots(data, p, tt, dt)
end

run(10000.0, 0.01)
