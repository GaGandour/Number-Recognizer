include("PCAcalculator.jl")


include("digit_model.jl")
using .DigitData

include("tests_extrator.jl")
using .TestExtractor


using StatsPlots

function correct_guesses_byNorm()
    test_Labels = get_testLabels()
    test_pixels = get_testPixels()

    refs = construct_digit_models(1000, 10)

    acertos = zeros(10)
    total = zeros(10)

    avg_class = AverageClassifier(500.0)

    for i in eachindex(test_Labels)
        total[test_Labels[i]+1] += 1

        sorted_avg_class = sort(avg_class(get_Image_byLabel_and_Matrix(test_pixels,i), 10, refs), by = e -> e.difference)

        if sorted_avg_class[1].digit == test_Labels[i]
            acertos[test_Labels[i]+1] += 1
        end
    end
    return acertos./total
end

function correct_guesses_byHypo()
    test_Labels = get_testLabels()
    test_pixels = get_testPixels()

    refs = construct_digit_models(1000, 10)

    acertos = zeros(10)
    total = zeros(10)

    normal_class = NormalClassifier(0.0)

    for i in eachindex(test_Labels)
        total[test_Labels[i]+1] += 1

        sorted_avg_class = sort(normal_class(get_Image_byLabel_and_Matrix(test_pixels,i), 10, refs), by = e -> -e.p_value)
        digito = sorted_avg_class[1].digit
        if digito == test_Labels[i]
            acertos[test_Labels[i]+1] += 1
        end
    end
    return acertos./total
end

function correct_guesses_byMultRef()
    test_Labels = get_testLabels()
    test_pixels = get_testPixels()

    refs = construct_digit_models(1000, 10)

    acertos = zeros(10)
    total = zeros(10)

    multref_class = MultipleReferenceClassifier(100.0)

    for i in eachindex(test_Labels)
        total[test_Labels[i]+1] += 1

        sorted_multref_class = sort(multref_class(get_Image_byLabel_and_Matrix(test_pixels,i), 10, refs), by = e -> e.min_dist)
        digito = sorted_multref_class[1].digit
        if digito == test_Labels[i]
            acertos[test_Labels[i]+1] += 1
        end
    end
    return acertos./total
end

##

function generate_barPlot(byNorm::Vector{Float64}, byHypo::Vector{Float64})
    ctg = repeat(["Comparação com o PCA médio", "Comparação com múltiplos PCAs"], inner = 10)
    ticklabel = string.(collect('0':'9'))
    groupedbar([byNorm byHypo], bar_position = :dodge, bar_width=0.7, xticks=(1:10, ticklabel), group = ctg, xlabel = "Dígitos", ylabel = "Taxa de Acerto",
    title = "Taxa de acerto por dígito por método", lw = 0, framestyle = :box, legend = :bottomleft)
end

# correct_by_norm = correct_guesses_byNorm()
# correct_by_multref = correct_guesses_byMultRef()

generate_barPlot(correct_by_norm, correct_by_multref)