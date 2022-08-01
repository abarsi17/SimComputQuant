export
    QRegistre

#On se almacenen els QuBits
mutable struct QRegistre
    estat
    nQubits
    #Constructor del registre de QuBits amb nombres complexos
    function QRegistre(nQubits)
        #nQuBits -> nombre de QuBits en el registre
        #Per a convertir a nombre complex un vector de 0s de tamany 2^N
        #Convertir a Matriu de nombres complexos
        estat = zeros(ComplexF64, (1,2 .^ nQubits))
        estat[1] = 1
        #Per a crear un QRegistre, si no posarem aquest parametre unicamente ens crearia una matriu
        new(estat,nQubits)
    end
end

#Funció que asegura que es cumplix la propietat de que |a|^2 + |b|^2 = 1
function ortonormal(estat)
    sum = 0
    for i in 1:length(estat)
        sum += abs(estat[i])^2
    end

    sum = sqrt(sum)

    if sum == 1
        println("Es conjunt ortonormal")
    else
        println("No es un conjunt ortonormal")
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
