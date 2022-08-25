export
    QCircuit,
    aplicarPorta

#Variable general per a ficar la key del diccionari
const valorsKey = ["qubit[1]", "qubit[2]", "qubit[3]"]

#Conjunt de operacions per realitzar operacions sobre un QRegistre
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

    #Per a un qubit
    if c.registre.nQubits == 1
        c.registre.estat = c.registre.estat * porta.matriu
    #Per a n qubits, on n > 1
    else
        c.registre.registre[qubit].estat = porta.matriu * c.registre.registre[qubit].estat
        #aux = c.registre.registre[1].estat
        for i in 1:c.registre.nQubits-1
            c.registre.estat = kron(c.registre.registre[i+1].estat, c.registre.registre[i].estat)
        end
    end
    #Per a redondejar, la primera volta que entra aumenta un poc el temps comparat en les atres voltes
    j = 1
    for valor in c.registre.estat
        c.registre.estat[j] = round(valor, digits = 4)
        j += 1
    end

    c.registre.estat = reshape(c.registre.estat, 1, 2^c.registre.nQubits)
    push!(c.qubit[valorsKey[qubit]], porta.nom)

    c.registre.estat
end
