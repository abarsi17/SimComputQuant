export
    QCircuit,
    aplicarPorta

#Variable general per a ficar la key del diccionari.
# qubit[0], qubit[1], ...
valorsKey = []

#Conjunt de operacions per realitzar operacions sobre un QRegistre
mutable struct QCircuit
    qubit
    registre
    function QCircuit(reg::QRegistre)
        #Diccionari per a fer referencia a cada qubit del circuit
        qubit = Dict()
        for i in 1:reg.nQubits
            push!(valorsKey, string("qubit[",i,"]"))
            qubit[valorsKey[i]] = []
        end
        registre = reg
        new(qubit, registre)
    end
end

#Aplicar una porta quantica sobre un qubit
#aplicarPorta(c, scq.H(), 1)
function aplicarPorta(c::QCircuit, porta::QPorta, qubit)
    @assert 0 < qubit <= c.registre.nQubits "El qubit passat esta fora del rang"

    #Per a un qubit
    if c.registre.nQubits == 1
        c.registre.estat = c.registre.estat * porta.matriu
    #Per a n qubits, on n > 1
    else
        c.registre.registre[qubit].estat = porta.matriu * c.registre.registre[qubit].estat
        aux = c.registre.registre[1].estat
        for i in 2:c.registre.nQubits
            aux = kron(c.registre.registre[i].estat, aux)
        end
        c.registre.estat = aux
    end
    #Per a redondejar, la primera volta que entra aumenta un poc el temps comparat en les atres voltes
    j = 1
    for valor in c.registre.estat
        c.registre.estat[j] = round(valor, digits = 4)
        j += 1
    end

    c.registre.estat = reshape(c.registre.estat, 1, 2^c.registre.nQubits)
    dibuixarCircuit(c, porta, qubit)
    c.registre.estat
end

#Per a portes quantiques que necesiten 2 qubits. De moment soles CNOT
#aplicarPorta(c, scq.CX(), 2, 3)
#aplicarPorta(c, scq.T(), 2, 3, 4)
function aplicarPorta(c::QCircuit, porta::QPorta, qubits...)
    @assert 0 < qubits[1] <= c.registre.nQubits && 0 < qubits[2] <= c.registre.nQubits "El qubit passat esta fora del rang"
    @assert (qubits[2] - qubits[1]) == 1 "La asignació de qubits te que ser consecutiva i de menor a major"

    #Especialment per a la porta Toffoli, ja que utilitza tres qubits
    if length(qubits) == 3
        @assert (qubits[3] - qubits[2]) == 1 && 0 < qubits[3] <= c.registre.nQubits "La asignació de qubits te que ser consecutiva i de menor a major o esta fora de rang"
    end
    #Comprobar que el primer o el segon qubit es diferent de |0>
    if (c.registre.registre[qubits[1]].estat != [1;0] || c.registre.registre[qubits[2]].estat != [1;0]) && porta.nom == "✕"
        aux = c.registre.registre[qubits[1]].estat
        c.registre.registre[qubits[1]].estat = c.registre.registre[qubits[2]].estat
        c.registre.registre[qubits[2]].estat = aux
        aux1 = c.registre.registre[1].estat
        for i in 2:c.registre.nQubits
            aux1 = kron(c.registre.registre[i].estat, aux1)
        end
        c.registre.estat = aux1

    #Comprobar que el primer qubit es diferent de |0>
    elseif c.registre.registre[qubits[1]].estat != [1;0]
        if porta.nom == "⊕"
            c.registre.registre[qubits[2]].estat = porta.matriu * c.registre.registre[qubits[2]].estat
            aux = c.registre.registre[1].estat
            for i in 2:c.registre.nQubits
                aux = kron(c.registre.registre[i].estat, aux)
            end
            c.registre.estat = aux
        elseif porta.nom == "⊗"
            #Comprobar que el segon qubit es diferent de |0>
            if c.registre.registre[qubits[2]].estat != [1;0]
                c.registre.registre[qubits[3]].estat = porta.matriu * c.registre.registre[qubits[3]].estat
                aux = c.registre.registre[1].estat
                for i in 2:c.registre.nQubits
                    aux = kron(c.registre.registre[i].estat, aux)
                end
                c.registre.estat = aux
            end
        end
    end
    #Per a redondejar, la primera volta que entra aumenta un poc el temps comparat en les atres voltes
    j = 1
    for valor in c.registre.estat
        c.registre.estat[j] = round(valor, digits = 4)
        j += 1
    end

    c.registre.estat = reshape(c.registre.estat, 1, 2^c.registre.nQubits)
    dibuixarCircuit(c, porta, qubits)
    c
end

function mesurar(c::QCircuit, qubit::Int)
    @assert 0 < qubit <= c.registre.nQubits "El qubit passat esta fora del rang"

    if c.registre.registre[qubit].estat != [1;0] && c.registre.registre[qubit].estat != [0;1]
        estat = zeros(ComplexF64, 2)
        estat[2] = 1
        c.registre.registre[qubit].estat = estat
        m = QPorta("M",[])
        aux = c.registre.registre[1].estat
        for i in 2:c.registre.nQubits
            aux = kron(c.registre.registre[i].estat, aux)
        end
        c.registre.estat = aux
    end
    #Per a redondejar, la primera volta que entra aumenta un poc el temps comparat en les atres voltes
    j = 1
    for valor in c.registre.estat
        c.registre.estat[j] = round(valor, digits = 4)
        j += 1
    end
    c.registre.estat = reshape(c.registre.estat, 1, 2^c.registre.nQubits)
    dibuixarCircuit(c, m, qubit)
    c
end

#Per a dibuixar el circuit.
# dibuixarCircuit(c, CX, [1,2])
function dibuixarCircuit(c::QCircuit, porta::QPorta, qubits)
    qubitAux = 0
    #Portes de multiples qubits
    #CNOT
    if porta.nom == "⊕"
        for num in 1:c.registre.nQubits
            if num == qubits[1]
                push!(c.qubit[valorsKey[num]], "•")
                qubitAux = 1
            elseif qubitAux == 1
                push!(c.qubit[valorsKey[num]], porta.nom)
                qubitAux = 0
            else
                push!(c.qubit[valorsKey[num]], "-")
            end
        end
    #Toffoli
    elseif porta.nom == "⊗"
        for num in 1:c.registre.nQubits
            if num == qubits[1]
                push!(c.qubit[valorsKey[num]], "•")
                qubitAux = 1
            elseif qubitAux == 1
                push!(c.qubit[valorsKey[num]], "•")
                qubitAux = 2
            elseif qubitAux == 2
                push!(c.qubit[valorsKey[num]], porta.nom)
                qubitAux = 0
            else
                push!(c.qubit[valorsKey[num]], "-")
            end
        end
    #SWAP
    elseif porta.nom == "✕"
        for num in 1:c.registre.nQubits
            if num == qubits[1]
                push!(c.qubit[valorsKey[num]], porta.nom)
                qubitAux = 1
            elseif qubitAux == 1
                push!(c.qubit[valorsKey[num]], porta.nom)
                qubitAux = 0
            else
                push!(c.qubit[valorsKey[num]], "-")
            end
        end
    #Portes d'un qubit
    else
        for num in 1:c.registre.nQubits
            if num == qubits
                push!(c.qubit[valorsKey[num]], porta.nom)
            else
                push!(c.qubit[valorsKey[num]], "-")
            end
        end
    end
end
