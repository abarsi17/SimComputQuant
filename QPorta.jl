export
    QPorta,
    H,
    X,
    Y,
    Z

arrayPortes = []

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
    push!(arrayPortes, h)
    return h
end

#Porta quántica PauliX també coneguda com la Porta NOT
function X()
    matriu = [0 1; 1 0]
    x = QPorta("X", matriu)
    push!(arrayPortes, x)
    return x
end

#Porta quántica PauliY
function Y()
    matriu = [0 -im; im 0]
    y = QPorta("Y", matriu)
    push!(arrayPortes, y)
    return y
end

#Porta quántica PauliZ
function Z()
    matriu = [1 0; 0 -1]
    z = QPorta("Z", matriu)
    push!(arrayPortes, z)
    return z
end

#Matriu identitat de tamany n x n
function I(n=2)
    matriu = zeros(n,n)
    for i in 1:n
        matriu[i,i] = 1
    end
    i = QPorta("I", matriu)
    push!(arrayPortes, i)
    return i
end

#Porta quántica CNOT, treballa en dos qubits {x, y}
function CX()
    """matriu = zeros(4,4)
    matriu[1,1] = 1
    matriu[2,2] = 1
    matriu[3,4] = 1
    matriu[4,3] = 1"""
    matriu = [0 1;1 0]
    cx = QPorta("⊕", matriu)
    push!(arrayPortes, cx)
    return cx
end

#Porta quàntica SWAP, treball amb dos qubits
function SWAP()
    matriu = zeros(4,4)
    matriu[1,1] = 1
    matriu[2,3] = 1
    matriu[3,2] = 1
    matriu[4,4] = 1
    swap = QPorta("✕", matriu)
    push!(arrayPortes, swap)
    return swap
end

#Porta quàntica Toffoli, treballa amb tres qubits
function T()
    """matriu = zeros(8,8)
    for i in 1:6
        matriu[i,i] = 1
    end
    matriu[7,8] = 1
    matriu[8,7] = 1
    #ⓧ"""
    matriu = [0 1;1 0]
    t = QPorta("⊗", matriu)
    push!(arrayPortes, t)
    return t
end

#Funcio ajuda per a saber les portes quàntiques
function ajuda()
    println("Aquest es un llista de les portes quantiques disponibles")
    println("Aquestes comportes quàntiques treballen amb 1 qubit:")
    println("\t- Pauli X -> X()")
    println("\t- Pauli Y -> Y()")
    println("\t- Pauli Z -> Z()")
    println("\t- Hadamard -> H()")
    println("\t- Identitat -> I(n)")
    println("Aquestes comportes quàntiques treballen amb 2 o mes qubits:")
    println("\t- CNOT -> CX()")
    println("\t- SWAP -> SWAP()")
    println("\t- Toffoli -> T()")
end
