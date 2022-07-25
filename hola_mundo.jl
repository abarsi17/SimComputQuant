using PyCall

function hola()
    println("HOLA MUNDO")
end


mutable struct p1
    state
end



using Printf

struct Hora
    hora :: Int64
    minuto :: Int64
    segundo :: Int64
end

function imprimirhora(tiempo)
    @printf("%02d:%02d:%02d", tiempo.hora, tiempo.minuto, tiempo.segundo)
end

function jesus(args, ad)
    args.state = zeros(2*ad)
end

mutable struct QRegistry
    state
end

function init(reg, nqbits)
    reg.state = zeros(nqbits .^ 2, im)
    reg.state[1] = im
end
