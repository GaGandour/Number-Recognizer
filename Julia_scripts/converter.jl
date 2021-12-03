using Colors, Plots

label = 7
w, h = 28, 28

exemplo = 3

imagens = Array{UInt8}(undef, w, h, 1000)
read!(string("./training set/0/data", string(label), ".txt"), imagens)

imagem = imagens[1:28,1:28,exemplo]'

#reinterpret(N0f8, imagens)
plot(Gray.(imagem/255))
# data[0:256, 0:256] = [255, 0, 0] # red patch in upper left
# img = Image.fromarray(matriz, mode='L')
# img.show()