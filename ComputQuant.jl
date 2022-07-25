module ComputQuant

using PyCall
using LinearAlgebra
using SparseArrays

include("QRegistre.jl")
include("Braket.jl")
include("QCircuit.jl")
include("QPorta.jl")

#Computador Quantic
ComputQuant

end
