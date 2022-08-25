export
    QPorta,
    H,
    X,
    Y,
    Z

#Porta quántica, se utilitza per a poder manipular els QuBits
mutable struct QPorta
    nom
    matriu

    function QPorta(nom, matriu)
        nom = nom
        new(nom, matriu)
    end

end

#Porta quántica Hadamard
function H()
    matriu = ones(ComplexF64, (2,2))
    matriu[2,2] = -1
    mult = 1/sqrt(2)
    matriu *= mult
    h = QPorta("H", matriu)
    return h
end

#Porta quántica PauliX també coneguda com la Porta NOT
function X()
    matriu = [0 1; 1 0]
    x = QPorta("X", matriu)
    return x
end

#Porta quántica PauliY
function Y()
    matriu = [0 -im; im 0]
    y = QPorta("Y", matriu)
    return y
end

#Porta quántica PauliZ
function Z()
    matriu = [1 0; 0 -1]
    z = QPorta("Z", matriu)
    return z
end

#Matriu identitat
function I()
    matriu = [[1 0; 0 1]]
    i = QPorta("I", matriu)
    return i
end

function ajuda()
    println("Aquest es un llista de les portes quantiques disponibles:")
    println("\t- Pauli X")
    println("\t- Pauli Y")
    println("\t- Pauli Z")
    println("\t- Hadamard")
    println("\t- Identitat")
    println("\t- CNOT")
end

"""
#Porta quántica CNOT, treballa en dos qubits
function CX(reg::QRegistre)
    @assert 1 < reg.nQubits < 4 "Te que estar compres en el rang"
    index = 1
    m = zeros(Int, (1, 2^reg.nQubits))
    for q in reg.estat
        if q != 0
            m[index] = 1
        end
        index += 1
    end
end
"""
