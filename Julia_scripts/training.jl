#=
    Modulo de cálculo dos componentes principais do
    conjunto de treinamento
=#

module TrainingData
export DigitReference
using ..PCACalculator

"PCA de referência para um dígito"
struct DigitReference
    digit::Int
    pc::Matrix{Float64}
    n_principal_components::Int
    function DigitReference(digit::Int, pc::Matrix{Float64})
        if !(0 <= digit <= 9)
            error("Dígito deve estar entre 0 e 9")
        end
        new(digit, pc, size(pc)[2])
    end
end

function DigitReference(digit::Int, 
    base_images::Vector{Matrix{Float64}}, p::Int)
    #achar um Y representativo para o conjunto de Dados
    #por enquanto, a média
    Y = sum(PCA.(base_images, p)) / length(base_images)
    return DigitReference(digit, Y)
end

end
