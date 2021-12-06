using Plots, LinearAlgebra

include("PCACalculator.jl")
using .PCACalculator
include("digit_model.jl")
using .DigitData

##
#normalidade das normas
#= for i = 0:9
    images = read_images(i, 1:1000)
    norms = norm.(PCA.(collect.(eachslice(images, dims = 3)), 10))

    display(histogram(norms, lab="Normas para $i"))
end =#

##

refs = construct_digit_models(1000, 10)

#= for i = 0:9
    images = read_images(i, 1:1000)

    pcas = PCA.(collect.(eachslice(images, dims = 3)), 10)
    norms = norm.(pca - refs[i+1].average_principal_component for pca in pcas)

    display(histogram(norms, lab="Normas para $i"))
end =#

images = read_images(5, 1:1000)

    pcas = PCA.(collect.(eachslice(images, dims = 3)), 10)
    norms = norm.(pca - refs[7+1].average_principal_component for pca in pcas)

    display(histogram(norms, lab="Normas para 5/7"))