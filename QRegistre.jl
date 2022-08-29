export
    QRegistre,
    ortonormal

#Estructura del Qubit
mutable struct Qubit
    estat

    function Qubit()
        estat = zeros(ComplexF64, 2)
        estat[1] = 1
        new(estat)
    end
end

#On se almacenen els QuBits
mutable struct QRegistre
    registre
    nQubits
    estat
    #Constructor del registre de QuBits amb nombres complexos
    function QRegistre(nQubits)
        registre = []
        for i in 1:nQubits
            push!(registre, Qubit())
        end
        estat = registre[1].estat
        for i in 2:nQubits
            estat = kron(registre[i].estat, estat)
        end
        estat = reshape(estat, 1, 2^nQubits)
        new(registre, nQubits, estat)
    end
end

#Funció que asegura que es cumplix la propietat de que |a|^2 + |b|^2 = 1
function ortonormal(estat)
    sum = 0
    for i in 1:length(estat)
        sum += abs(estat[i])^2
    end

    sum = sqrt(sum)
    sum = round(sum, digits = 4)

    if sum == 1
        println("Es conjunt ortonormal")
    else
        println("No es un conjunt ortonormal")
    end
end

#Per a vore tots els valors del registre. Ja que quant ix per pantalla es simplifica amb ...
function voreCompleta(reg::QRegistre, opcio::Int=2)
    println("Estat de la ixida")
    #Opcio 1 en forma de fila
    if opcio == 1
        for valor in reg.estat
            print(valor," ")
        end
    #Opcio 2 en forma de columna
    elseif opcio == 2
        for valor in reg.estat
            println(valor)
        end
    else
        println("No es contempla aquesta opcio")
    end
end



"""DE MOMENT NO SERVIX"""

function measure(reg::QRegistre, msk, remove = false)
    """for num in msk
        if typeof(msk) != typeof([0]) || size(msk,1) != log2(size(reg.estat, 1)) || !all(typeof(num) == Int64 && (num == 0 || num == 1))
            println("No es una mascara valida")
        else
            println("SI")
        end
    end"""
    mask = zeros(size(msk,2))
    for i in 1:trunc(Int64, size(msk,2))
        if msk[i] == 1
            mask[i] = i
        end
    end
    tq = trunc(Int64, log2(size(reg.estat,1)))
    """for num in msk
        if !all(num < tq && num > -1)
            println("Fora de rang")
        end
    end"""
    mes = zeros(size(mask,1))
    #FALLA A PARTIR DE ASI
    for qbit in mask
        r = rand()
        p = 0
        max = 2 ^ (tq - (qbit + p))
        cnt = 0
        rdy = true
        for i in 1:size(reg.estat,1)
            if cnt == max
                rdy = !rdy
                cnt = 0
            end
            if rdy
                p += abs(reg.estat[i])
            end
            cnt += 1
        end
        if r < p
            m = 0
        else
            m = 1
        end
    end
end
