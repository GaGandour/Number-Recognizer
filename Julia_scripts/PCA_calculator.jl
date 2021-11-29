# =====================================================================
# *********************************************************************
#                        PCA Calculator
# *********************************************************************
# =====================================================================
#
# Dupla: Gabriel Gandour, Pedro Puglia
#
# ---------------------------------------------------------------------
# Dados de entrada:
# A     matriz mxn
#
# Saída:
# Decomposição PCA, ou seja:
# Y     matriz mxp, com p < n
# Sigma matriz px1, contendo as variâncias.

using LinearAlgebra # função norm()

function Desv_Media(X::Matrix)
    m,n = size(X)
    e = zeros(m,1)
    soma = zeros(1,n)
    for i = 1:m
        soma = soma + X[i,1:n]'
        e[i,1] = 1
    end
    media = (1/m)*soma
    return X - e*media
end

function PCA(A::Matrix, p::Int64) 
    tol = 1e-12
    m,n = size(A)
    A = copy(Desv_Media(A))
    F = svd(A; full = true)
    U, S, V = F.U, F.S, F.V
    Sigma = zeros(m,n)
    for i = 1:p
        Sigma[i,i] = S[i]
    end
    Y = U[1:m,1:p]*Sigma[1:p,1:n]



    return Y[1:m,1]
end

X = [105.0 245 685 147 193 156 720 198 253 360 488 1102 1472 57 1374 375 54;
103 227 803 160 235 175 874 203 265 365 570 1137 1582 73 1256 475 64;
103 242 750 122 184 147 566 220 171 337 418 957 1462 53 1572 458 62;
66 267 586 93 209 139 1033 187 143 334 355 674 1494 47 1506 135 41]

print(PCA(X,4))