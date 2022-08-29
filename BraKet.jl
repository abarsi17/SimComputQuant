export
    ket,
    bra,
    braket

#Vector estat en forma de columna |·>
function ket(index :: Int, tamany :: Int)
    @assert tamany > 0 "El tamany del vector te que ser positiu"
    @assert 1 <= index <= tamany "El index te que ser positiu i no mes gran que el tamany del vector"
    #ret = spzeros(Int64, tamany) #resultat [index] = valor
    ret = zeros(Int64, (1,tamany))
    ret[index] = 1
    ret
end

function ket(estat)
    estat = reshape(estat, 1, length(estat))
    estat
end

#Vector estat en forma de fila conjugada <·|
function bra(index :: Int, tamany :: Int)
    ket(index, tamany)'
end

function bra(estat)
    estat = reshape(estat, length(estat), 1)
    estat
end

#Permitix treballar sobre vector en forma de fila conjugada i en forma de columna
function braket(iFila :: Int, iColumna :: Int, tamany :: Int)
    bra(iColumna, tamany) * ket(iFila, tamany)
end
