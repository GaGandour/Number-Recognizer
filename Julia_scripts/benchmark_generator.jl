include("PCA_calculator.jl")


include("training.jl")
using .TrainingData

include("tests_extrator.jl")
using .TestExtractor

include("image_classification.jl")
using .ImageClassification

using StatsPlots

function correct_guesses_byNorm()
    test_Labels = get_testLabels()
    test_pixels = get_testPixels()

    refs = construct_digit_references(1000, 10)

    acertos = zeros(10)
    total = zeros(10)

    for i in eachindex(test_Labels)
        total[test_Labels[i]+1] += 1
        if classify_image(get_Image_byLabel_and_Matrix(test_pixels,i), 10, refs, 100.0)[1] == test_Labels[i]
            acertos[test_Labels[i]+1] += 1
        end
    end
    return acertos./total
end

function generate_barPlot(byNorm::Vector{Float64}, byHypo::Vector{Float64})
    ctg = repeat(["Sem teste de hipótese", "Com teste de hipótese"], inner = 10)
    ticklabel = string.(collect('0':'9'))
    groupedbar([byNorm 2*byHypo], bar_position = :dodge, bar_width=0.7, xticks=(1:10, ticklabel), group = ctg, xlabel = "Dígitos", ylabel = "Taxa de Acerto",
    title = "Taxa de acerto por dígito por método", lw = 0, framestyle = :box, legend = :bottomleft)
end

generate_barPlot(correct_guesses_byNorm(),correct_guesses_byNorm())