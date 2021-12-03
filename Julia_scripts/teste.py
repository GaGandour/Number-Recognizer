from PIL import Image
import numpy as np

w, h = 28, 28
tamanho = w*h
imagem = []
coluna = []
data = np.zeros((h, w, 3), dtype=np.uint8)
with open("./training set/0/data8.txt", "rb") as f:
    for i in range(w):
        coluna = []
        for j in range(h):
            data = f.read(1)
            coluna.append(data)
        
        imagem.append(coluna)

matriz = np.array(imagem) 
print(matriz.shape)
print(matriz)
# data[0:256, 0:256] = [255, 0, 0] # red patch in upper left
#img = Image.fromarray(matriz, mode='L')
#img.show()