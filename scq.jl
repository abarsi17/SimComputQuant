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

end
