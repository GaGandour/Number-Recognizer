#wrapper para organizar tudo

module NumberRecognizer

#inclusão na ordem das dependências
include("PCA_calculator.jl")

include("training.jl")
using .TrainingData
export DigitReference, construct_digit_references, read_images, plot_image

include("image_classification.jl")
using .ImageClassification
export classify_image


end