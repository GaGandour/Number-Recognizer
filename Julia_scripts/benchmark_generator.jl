include("PCA_calculator.jl")


include("training.jl")
using .TrainingData

include("tests_extrator.jl")
using .TestExtractor

include("image_classification.jl")
using .ImageClassification

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

display(acertos./total)