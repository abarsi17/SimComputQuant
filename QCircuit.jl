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
        calcRegistre(c)
    end

    dibuixarCircuit(c, porta, qubit)
    c.registre.estat
end

#Per a portes quantiques que necesiten 2 qubits. De moment soles CNOT
#aplicarPorta(c, scq.CX(), 2, 3)
#aplicarPorta(c, scq.T(), 2, 3, 4)
function aplicarPorta(c::QCircuit, porta::QPorta, qubits...)
    @assert 0 < qubits[1] <= c.registre.nQubits && 0 < qubits[2] <= c.registre.nQubits "El qubit passat esta fora del rang"
    @assert qubits[1] < qubits[2] "El orden te que ser ascendent"
    #Comprobar que el primer o el segon qubit es diferent de |0> i que la porta es la SWAP
    if (c.registre.registre[qubits[1]].estat != [1;0] || c.registre.registre[qubits[2]].estat != [1;0]) && porta.nom == "✕"
        #El que fem es almacenar el valor del primer estat en una variable auxiliar, per a despres poder canviar els valors d'un estat en un altre
        aux = c.registre.registre[qubits[1]].estat
        c.registre.registre[qubits[1]].estat = c.registre.registre[qubits[2]].estat
        c.registre.registre[qubits[2]].estat = aux
        calcRegistre(c)

    #Comprobar que el primer qubit es diferent de |0>
    elseif c.registre.registre[qubits[1]].estat != [1;0]
        if porta.nom == "⊕"
            c.registre.registre[qubits[2]].estat = porta.matriu * c.registre.registre[qubits[2]].estat
            calcRegistre(c)
        elseif porta.nom == "⊗"
            #Comprobar que el segon qubit es diferent de |0>, per a la porta Toffoli
            if c.registre.registre[qubits[2]].estat != [1;0]
                c.registre.registre[qubits[3]].estat = porta.matriu * c.registre.registre[qubits[3]].estat
                calcRegistre(c)
            end
        end
    end
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
        calcRegistre(c)
    else
        m = QPorta("M",[])
    end
    dibuixarCircuit(c, m, qubit)
    c
end

#Eliminar l'ulitma porta introduida en el qubit assignat
function eliminar(c::QCircuit, qubit)
    comprovar = 0
    iter = 1
    porta = 0
    while comprovar == 0 && iter <= c.registre.nQubits
        @assert c.qubit[string("qubit[",iter,"]")][length(c.qubit["qubit[1]"])] != "M" "No se pot eliminar una vegada has realitzat la mesura del qubit"
        @assert c.qubit[string("qubit[",iter,"]")][length(c.qubit["qubit[1]"])] != "⊕" "No se pot eliminar"
        @assert c.qubit[string("qubit[",iter,"]")][length(c.qubit["qubit[1]"])] != "⊗" "No se pot eliminar"
        @assert c.qubit[string("qubit[",iter,"]")][length(c.qubit["qubit[1]"])] != "✕" "No se pot eliminar"
        if c.qubit[string("qubit[",1,"]")][length(c.qubit["qubit[1]"])] == arrayPortes[iter].nom
            porta = arrayPortes[iter]
            comprovar = 1
        end
        iter += 1
    end

    c.registre.registre[qubit].estat = inv(porta.matriu) * c.registre.registre[qubit].estat
    calcRegistre(c)
    for k in 1:c.registre.nQubits
        pop!(c.qubit[string("qubit[",k,"]")])
    end
    c
end

#Per a simplificar funcions, el que fa es calcular el registre una vegada s'aplica o s'elimina una porta del circuit
function calcRegistre(c::QCircuit)
    aux = c.registre.registre[1].estat
    for i in 2:c.registre.nQubits
        aux = kron(c.registre.registre[i].estat, aux)

    end
    #Per a redondejar, la primera volta que entra aumenta un poc el temps comparat en les atres voltes
    for j in 1:length(aux)
        aux[j] = round(aux[j], digits = 4)
    end
    c.registre.estat = aux
end

#Per a dibuixar el circuit.
# dibuixarCircuit(c, CX, [1,2])
function dibuixarCircuit(c::QCircuit, porta::QPorta, qubits)
    #Portes de multiples qubits
    #CNOT
    if porta.nom == "⊕"
        for num in 1:c.registre.nQubits
            if num == qubits[1]
                push!(c.qubit[valorsKey[num]], "•")
            elseif num == qubits[2]
                push!(c.qubit[valorsKey[num]], porta.nom)
            elseif num > qubits[1] && num < qubits[2]
                push!(c.qubit[valorsKey[num]], " ")
            else
                push!(c.qubit[valorsKey[num]], "-")
            end
        end
    #Toffoli
    elseif porta.nom == "⊗"
        for num in 1:c.registre.nQubits
            if num == qubits[1]
                push!(c.qubit[valorsKey[num]], "•")
            elseif num == qubits[2]
                push!(c.qubit[valorsKey[num]], "•")
            elseif num == qubits[3]
                push!(c.qubit[valorsKey[num]], porta.nom)
            elseif num > qubits[1] && num < qubits[2]
                push!(c.qubit[valorsKey[num]], " ")
            elseif num > qubits[2] && num < qubits[3]
                push!(c.qubit[valorsKey[num]], " ")
            else
                push!(c.qubit[valorsKey[num]], "-")
            end
        end
    #SWAP
    elseif porta.nom == "✕"
        for num in 1:c.registre.nQubits
            if num == qubits[1]
                push!(c.qubit[valorsKey[num]], porta.nom)
            elseif num == qubits[2]
                push!(c.qubit[valorsKey[num]], porta.nom)
            elseif num > qubits[1] && num < qubits[2]
                push!(c.qubit[valorsKey[num]], " ")
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
