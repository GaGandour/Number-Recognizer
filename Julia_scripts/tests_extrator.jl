using Colors, Plots

#= function imprimir_imagem(image::Matrix{Float64}, label::UInt8)
    plot(Gray.(image), title= string("Imagem", " do número ", string(label)))
end =#
  
module TestExtractor
export get_testLabels, get_testPixels, get_Image_byLabel_and_Matrix

function get_testLabels()
    labels = Array{UInt8}(undef, 10008)
    read!(string("./training set/t10k-labels.idx1-ubyte"), labels)
    for i = 1:8
        popfirst!(labels)
    end
    return labels
end

function get_testPixels()
    pixels = Array{UInt8}(undef, 7840016)
    read!(string("./training set/t10k-images.idx3-ubyte"), pixels)
    for i = 1:16
        popfirst!(pixels)
    end
    return pixels
end

function get_Image_byLabel_and_Matrix(pixels::Vector{UInt8}, label::Int64)
    w = 28
    offset = w*w*(label-1)
    imagem = zeros(w,w)
    for i = 1:w
        for j=1:w
            imagem[i,j] = pixels[w*(i-1)+j + offset]
        end
    end
    return imagem/255
end

end

#= test_Labels = get_testLabels()
test_pixels = get_testPixels() =#

#= n = 40

imprimir_imagem(get_Image_byLabel_and_Matrix(test_pixels, n),test_Labels[n]) =#