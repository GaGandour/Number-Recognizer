#=
    Modulo de cálculo dos componentes principais do
    conjunto de treinamento
=#

module DigitData
export AverageClassifier, NormalClassifier, construct_digit_models, read_images, plot_image
using ..PCACalculator
using LinearAlgebra

"PCA de referência para um dígito"
struct DigitModel
    digit::Int
    average_principal_component::Matrix{Float64}
    p::Int
    μ::Float64
    σ::Float64
    function DigitModel(digit::Int, pc::Matrix{Float64}, μ::Float64, σ::Float64)
        if !(0 <= digit <= 9)
            error("Dígito deve estar entre 0 e 9")
        end
        new(digit, pc, size(pc)[2], μ, σ)
    end
end

using Statistics: mean, std

function DigitModel(digit::Int, base_images::Vector{Matrix{Float64}}, p::Int)
    pcas = PCA.(base_images, p)
    Y = sum(pcas) / length(base_images)
    norms = norm.(pca - Y for pca in pcas)
    μ = mean(norms)
    σ = std(norms)
    return DigitModel(digit, Y, μ, σ)
end

function construct_digit_models(sample_size::Int, p::Int)
    refs = DigitModel[]
    for i = 0:9
        imgs = read_images(i, 1:sample_size)
        push!(refs, DigitModel(i, [collect(img) for img in eachslice(imgs, dims=3)], p))
    end
    return refs
end
abstract type Classifier end
abstract type ClassificationResult end

struct AverageClassifier <: Classifier
    tolerance::Float64
end

struct AvgClassResult <: ClassificationResult
    digit::Int
    difference::Float64
    tolerance::Float64
    method::String
end

#mudar tipo de retorno para indicar norma da diferença, tipo de comparação, etc
function (classifier::AverageClassifier)(image::Matrix{Float64}, p::Int, classes::Vector{DigitModel})
    image_Y = PCACalculator.PCA(image, p)
    differences = Dict(class.digit => norm(image_Y - class.average_principal_component) for class in classes)
    
    likely_digits = [class.digit for class in classes if differences[class.digit] < classifier.tolerance]
    
    #comapração com o PCA médio da categoria
    return AvgClassResult.(likely_digits, [differences[i] for i in likely_digits], classifier.tolerance, "Comparação com a média")
end

struct NormalClassifier <: Classifier
    alpha_value::Float64
    function NormalClassifier(alpha_value::Float64)
        new(clamp(alpha_value, 0, 1))
    end
end

struct NormalClassResult <: ClassificationResult
    digit::Int
    p_value::Float64
    α::Float64
    method::String
end

using Distributions: Normal, cdf
function (classifier::NormalClassifier)(image::Matrix{Float64}, p::Int, classes::Vector{DigitModel})
    image_Y = PCA(image, p)

    p_values = Dict(class.digit => begin 
                            dist = Normal(class.μ, class.σ)
                            1 - cdf(dist, class.μ + norm(image_Y - class.average_principal_component)) -
                                cdf(dist, class.μ - norm(image_Y - class.average_principal_component))
                            end for class in classes)
    likely_digits = [class.digit for class in classes if p_values[class.digit] >= classifier.alpha_value]
    sort!(likely_digits, by = el -> p_values[el], rev = true)
    return NormalClassResult.(likely_digits, [p_values[d] for d in likely_digits], classifier.alpha_value, "Cálculo do valor-p")
end


function read_images(label::Int, index::Union{Int, AbstractRange}) # retorna a matriz de um exemplo de img com uma label
    w, h = 28, 28
    imagens = Array{UInt8}(undef, w, h, 1000)
    read!(string("./training set/0/data", string(label), ".txt"), imagens)
    
    #transpoe as imagens, converte pra float
    imagens = permutedims(imagens, [2, 1, 3])
    return imagens[:, :, index]/255
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
