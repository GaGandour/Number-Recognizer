#=
    Modulo de cálculo dos componentes principais do
    conjunto de treinamento
=#

module TrainingData
export DigitReference, construct_digit_references, read_images, plot_image
using ..PCACalculator

"PCA de referência para um dígito"
abstract type DigitReference end

struct MeanDigitReference <: DigitReference
    digit::Int
    average_principal_component::Matrix{Float64}
    n_principal_components::Int
    function MeanDigitReference(digit::Int, pc::Matrix{Float64})
        if !(0 <= digit <= 9)
            error("Dígito deve estar entre 0 e 9")
        end
        new(digit, pc, size(pc)[2])
    end
end

function MeanDigitReference(digit::Int, 
    base_images::Vector{Matrix{Float64}}, p::Int)
    #achar um Y representativo para o conjunto de Dados
    #por enquanto, a média
    Y = sum(PCA.(base_images, p)) / length(base_images)
    return MeanDigitReference(digit, Y)
end

function compare_image(image::Matrix{Float64}, p::Int, classes::Vector{MeanDigitReference})
    image_Y = PCACalculator.PCA(image, p)
    differences = Dict(class.digit => norm(image_Y - class.pc) for class in classes)
    return differences
end

#mudar tipo de retorno para indicar norma da diferença, tipo de comparação, etc
function classify_image(image::Matrix{Float64}, p::Int, classes::Vector{MeanDigitReference}, tol::Float64)
    differences = compare_image(image, p, classes)
    likely_digits = [class.digit for class in classes if differences[class.digit] < tol]
    sort!(likely_digits, by = el -> differences[el])
    return likely_digits
end

struct NormalDigitReference <: DigitReference
    digit::Int
    average_principal_component::Matrix{Float64}
    p::Int
    μ::Float64
    σ::Float64
    function NormalDigitReference(digit::Int, pc::Matrix{Float64}, μ::Float64, σ::Float64)
        if !(0 <= digit <= 9)
            error("Dígito deve estar entre 0 e 9")
        end
        new(digit, pc, size(pc)[2], μ, σ)
    end
end

using Statistics: mean, std

function NormalDigitReference(digit::Int, base_images::Vector{Matrix{Float64}}, p::Int)
    pcas = PCA.(base_images, p)
    Y = sum(pcas) / length(base_images)
    norms = norm.(pca - Y for pca in pcas)
    μ = mean(norms)
    σ = std(norms)
    return NormalDigitReference(digit, Y, μ, σ)
end

using Distributions: Normal

function compare_image(image::Matrix{Float64}, p::Int, classes::Vector{NormalDigitReference})
    image_Y = PCACalculator.PCA(image, p)
    differences = Dict(class.digit => norm(image_Y - class.pc) for class in classes)
    #calcular o valor-p
    for class = classes
        n = Normal(class.μ, class.σ)
         
    end
    return 
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
