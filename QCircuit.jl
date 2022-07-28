#Conjunt de operacions per realitzar operacions sobre un QRegistre

export
    QCircuit,
    aplicarPorta

using PyCall

include("QPorta.jl")
include("QRegistre.jl")
include("Braket.jl")

#Variable general per a ficar la key del diccionari
const valorsKey = ["qubit[1]", "qubit[2]", "qubit[3]"]

mutable struct QCircuit
    qubit
    registre
    function QCircuit(reg::QRegistre)
        #Diccionari per a fer referencia a cada qubit del circuit
        qubit = Dict()
        for i in 1:reg.nQubits
            qubit[valorsKey[i]] = []
        end
        registre = reg
        new(qubit, registre)
    end
end

#Aplicar una porta quantica sobre un qubit
function aplicarPorta(c::QCircuit, porta::QPorta, qubit)
    @assert 0 < qubit <= c.registre.nQubits "El qubit passat esta fora del rang"

    push!(c.qubit[valorsKey[qubit]], porta.nom)

    if c.registre.nQubits == 2
        if qubit == 2
            m = reshape(c.registre.estat, (2,2)) * porta.matriu * porta.mult
            c.registre.estat = reshape(m, (1,4))

        elseif qubit == 1
            m = porta.mult * porta.matriu * reshape(c.registre.estat, (2,2))
            c.registre.estat = reshape(m, (1,4))
        end
    elseif c.registre.nQubits == 1
        c.registre.estat = c.registre.estat * porta.matriu * porta.mult
    end

end

#Porta Hadamard
function H()
    matriu = ones(ComplexF64, (2,2))
    matriu[2,2] = -1
    mult = 1/sqrt(2)
    h = QPorta("H", matriu, mult)
    return h
end

#Porta NOT
function X()
    matriu = [0 1; 1 0]
    x = QPorta("X", matriu)
    return x
end

"""DE MOMENT NO SERVIX"""

function Hmat(n)
    h = ones(ComplexF64, (2,2))
    h[2,2] = -1
    if n > 1
        h = kron(h,Hmat(n-1))
    end
    return h
end
