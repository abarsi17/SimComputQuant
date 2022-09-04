function algDeutsch(valor::Int)
    reg = QRegistre(4)
    c = QCircuit(reg)

    for i in 1:3
        scq.aplicarPorta(c, scq.H(), i)
    end
    scq.aplicarPorta(c, scq.X(), 4)
    scq.aplicarPorta(c, scq.H(), 4)

    #ORACLE

    #CONSTANT
    if valor == 1
        scq.aplicarPorta(c, scq.CX(), 1, 4)
        scq.aplicarPorta(c, scq.X(), 1)
        scq.aplicarPorta(c, scq.CX(), 1, 4)
        scq.aplicarPorta(c, scq.CX(), 2, 4)
        scq.aplicarPorta(c, scq.X(), 2)
        scq.aplicarPorta(c, scq.CX(), 2, 4)
        scq.aplicarPorta(c, scq.CX(), 3, 4)
        scq.aplicarPorta(c, scq.X(), 3)
        scq.aplicarPorta(c, scq.CX(), 3, 4)
    #BALANCEJA
    else
        scq.aplicarPorta(c, scq.CX(), 3, 4)
        scq.aplicarPorta(c, scq.CX(), 2, 4)
        scq.aplicarPorta(c, scq.T(), 1,2,4)
    end

    for i in 1:3
        scq.aplicarPorta(c, scq.H(), i)
    end
    for i in 1:3
        scq.mesurar(c, i)
    end
    c
end
