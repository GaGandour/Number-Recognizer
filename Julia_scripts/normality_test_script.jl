using Plots, LinearAlgebra

include("PCA_calculator.jl")
using .PCACalculator
include("training.jl")
using .TrainingData

##
#normalidade das normas
for i = 0:9
    images = read_images(i, 1:1000)
    norms = norm.(PCA.(collect.(eachslice(images, dims = 3)), 10))

    display(histogram(norms, lab="Normas para $i"))
end

##

refs = construct_digit_references(1000, 10)

for i = 0:9
    images = read_images(i, 1:1000)

    pcas = PCA.(collect.(eachslice(images, dims = 3)), 10)
    norms = norm.(pca - refs[i+1].pc for pca in pcas)

    display(histogram(norms, lab="Normas para $i"))
end
