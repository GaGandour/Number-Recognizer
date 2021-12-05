#wrapper para organizar tudo

module NumberRecognizer

#inclusão na ordem das dependências
include("PCACalculator.jl")

include("digit_model.jl")
using .DigitData
export construct_digit_models, AverageClassifier, NormalClassifier, read_images, plot_image

end