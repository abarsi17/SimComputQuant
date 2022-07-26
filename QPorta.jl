export
    QPorta

using PyCall

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



"""DE MOMENT NO SERVIX"""
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
