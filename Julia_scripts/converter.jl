using Colors, Plots

function matriz_da_imagem(label, exemplo) # retorna a matriz de um exemplo de img com uma label
  w, h = 28, 28
  imagens = Array{UInt8}(undef, w, h, 1000)
  read!(string("./training set/0/data", string(label), ".txt"), imagens)

  return imagens[1:28,1:28,exemplo]'
end

function imprime_imagem(label, exemplo) # imprime a img correspondente
  imagem = matriz_da_imagem(label, exemplo)
  plot(Gray.(imagem/255), title= string("Exemplo ", string(exemplo), " do numero ", string(label)))
end