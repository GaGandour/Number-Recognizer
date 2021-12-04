#=
    Modulo de cálculo dos componentes principais do
    conjunto de treinamento
=#

module TrainingData
export DigitReference, construct_digit_references, read_images, plot_image
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


function read_images(label::Int, index::Union{Int, AbstractRange}) # retorna a matriz de um exemplo de img com uma label
    w, h = 28, 28
    imagens = Array{UInt8}(undef, w, h, 1000)
    read!(string("./training set/0/data", string(label), ".txt"), imagens)
    
    #transpoe as imagens, converte pra float
    imagens = permutedims(imagens, [2, 1, 3])
    return imagens[:, :, index]/255
end

function construct_digit_references(sample_size::Int, p::Int)
    refs = DigitReference[]
    for i = 0:9
        imgs = read_images(i, 1:sample_size)
        push!(refs, DigitReference(i, [collect(img) for img in eachslice(imgs, dims=3)], p))
    end
    return refs
end

using Colors, Plots

function plot_image(label::Int, index::Int) # imprime a img correspondente
  imagem = read_image(label, exemplo)
  plot(Gray.(imagem), title= string("Índice ", string(index), " do número ", string(label)))
end

function plot_image(image::Matrix{Float64}, label::Int)
  plot(Gray.(image), title= string("Imagem", " do número ", string(label)))
end
end
