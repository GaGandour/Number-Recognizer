include("number_recognizer.jl")
using .NumberRecognizer

refs = construct_digit_models(800, 10)

##

avg_class = AverageClassifier(500.0)

normal_class = NormalClassifier(0.0)

test = read_images(0, 950)

display(avg_class(test, 10, refs))
display(normal_class(test, 10, refs))
# plot_image(test, 0)