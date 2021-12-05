#=
    Classificação da imagem em classes pré definidas
=#
module ImageClassification

export classify_image

using ..PCACalculator
using ..TrainingData
using LinearAlgebra

function compare_image(image::Matrix{Float64}, p::Int, classes::Vector{DigitReference})
    image_Y = PCACalculator.PCA(image, p)
    differences = Dict(class.digit=> norm(image_Y - class.pc)  for class in classes)
    return differences
end

function classify_image(image::Matrix{Float64}, p::Int, classes::Vector{DigitReference}, tol::Float64)
    differences = compare_image(image, p, classes)
    likely_digits = [class.digit for class in classes if differences[class.digit] < tol]
    sort!(likely_digits, by = el -> differences[el])
    return likely_digits
end

end