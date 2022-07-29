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
    mult

    function QPorta(nom, matriu, mult=1)
        nom = nom
        new(nom, matriu, mult)
    end

end

#Porta quántica Hadamard
function H()
    matriu = ones(ComplexF64, (2,2))
    matriu[2,2] = -1
    mult = 1/sqrt(2)
    h = QPorta("H", matriu, mult)
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


"""DE MOMENT NO SERVIX"""

function Hmat(n)
    h = ones(ComplexF64, (2,2))
    h[2,2] = -1
    if n > 1
        h = kron(h,Hmat(n-1))
    end
    return h
end

#args... Poder afegir mes d'un valor
function afegirLinia(qp::QPorta, args)
    push!(qp.linies, args)
    if qp.simple > 1 && size(args,1) > 1 || size(qp.linies,1) > 1
        qp.simple = false
    end
    #El producte de Kronecker
    aux = kron(1, qp.m)
    #El producte de dos Arrays
    qp.m = dot(aux, qp.m)
end


function setMult(qp::QPorta, mult)
    qp.m *= mult/qp.mult
    qp.mult = mult
end

function addMult(qp::QPorta, mult)
    qp.m *= mult
    qp.mult *= mult
end
