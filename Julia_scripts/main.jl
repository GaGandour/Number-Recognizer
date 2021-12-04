include("number_recognizer.jl")
using .NumberRecognizer

refs = construct_digit_references(800, 5)

##
test = read_images(0, 900)

display(classify_image(test, 5, refs, 100.0))
plot_image(test, 0)