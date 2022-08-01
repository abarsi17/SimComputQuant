#Simulador d'un Computador Quantic
module scq

using PyCall
using LinearAlgebra
using SparseArrays

include("QRegistre.jl")
include("QPorta.jl")
include("Braket.jl")
include("QCircuit.jl")

scq

#Eixida per pantalla del registre quantic
function Base.show(io::IO, reg::QRegistre)
    println(io, "Estat de la ixida\n\t", reg.estat)
end

#Eixida per pantalla del circuit quantic
function Base.show(io::IO, c::QCircuit)
    for i in 1:c.registre.nQubits
        x = "- "
        for valors in c.qubit[valorsKey[i]]
            x *= valors * " - "
        end
        println(io, valorsKey[i], " -> ", x)
    end
end

end
