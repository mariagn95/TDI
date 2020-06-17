%                                                       María Guadaño Nieto
%
%%%%% -------------------- Práctica 1 -------------------- %%%%%
% INTRODUCCIÓN AL PROCESAMIENTO DE IMÁGENES EN EL DOMINIO ESPACIAL
%
%%
%% I. Lectura, visualización y almacenamiento de imágenes
%%
%% ----- Dimensiones y tipos de imagenes
clear all, close all, clc
Pimientos=imread('peppers.png');
Monedas=imread('coins.png');
Cara=imread('cara.tif');
whos %%---Muestra las caracteristicas
size(Cara)
z=zeros(5,6)
I_gris=uint8(z+128)
%%
%-- 'imshow' permite visualizar una matriz de valores en forma de imagen
%-- si no se indica el rango de niveles de la imagen a visualizar,
%-- considera que el rango dinamico es el maximo permitid
%-- Es recomendable generar una nueva figura antes de su utilizacion
figure, imshow(Pimientos)
figure, imshow(Monedas)
figure, imshow(Cara)
figure, imshow(I_gris)

%-- 'imtool' permite visualizar imagenes, ademas de conocer las
%-- coordenadas de cada pixel cuando el cursor del raton pasa sobre el pixel
imtool(Pimientos)
imtool(Monedas)
imtool(Cara)

%% Algunas funciones de conversion de tipos de imagenes
%% ----- Una imagen binaria pase a ser RGB.
close all;
Cara_mapa = [255 255 0; 255 0 0];
imtool(Cara_mapa)
Cara_rgb = ind2rgb(Cara, Cara_mapa);
imshow(Cara_rgb)
title('Imagen binaria');
imwrite(Cara_rgb, 'Cara_rgb.tif')

%% -----  Una imagen RGB pase a escala de grises.
close all;
Pimientos_gray = rgb2gray(Pimientos);
imshow(Pimientos_gray);
title('Imagen en escala de grises');

%% ----- Una imagen de RGB pase a imagen indexada con 255 niveles.
close all;
[Pimientos_255, MAP_Pimientos] = rgb2ind(Pimientos, 255);
imshow(Pimientos_255, MAP_Pimientos);
title('Imagen indexada 255 niveles');

%% ----- Una imagen de RGB pase a imagen indexada con 5 niveles.
close all;
[Pimientos_5, MAP_Pimientos] = rgb2ind(Pimientos, 5);
imshow(Pimientos_5, MAP_Pimientos);
title('Imagen indexada 5 niveles');
imwrite(Pimientos_5, MAP_Pimientos, 'Pimientos_5.png')

%% ----- Una imagen de grises pase a imagen indexada con 5 niveles.
close all;
[Monedas_index, MAP_Monedas] = gray2ind(Monedas, 5);
imshow(Monedas_index, MAP_Monedas);
title('Imagen indexada 5 niveles');

%% ----- Una imagen de grises pase a binaria.
close all;
Monedas_binaria = im2bw(Monedas);
imshow(Monedas_binaria );
title('Imagen binaria');




%%
%% II.  Modificación de la resolución y del número de niveles
%%

clear all, close all, clc

%% ----- Diezmado o interpolacion
Lena = imread('Lena_512.tif');

%-- 'imresize' permite redifinir el tamaño de la imagen, modificando asi la
%-- resolucion espacial de la imagen. 
%-- El segundo argumento de entrada permite determinar si la imagen resultante 
%-- corresponde a un diezmado (valor del segundo parámetro inferior a 1) o a 
%-- una interpolación (valor del segundo parámetro superior a 1) 

%% ----- Diezmado
%- Mayor resolucion espacial
Lena_256 = imresize(Lena,0.5);
figure, imshow(Lena_256)
imwrite(Lena_256, 'Lena_256.tif'), title('Lena 256')

%- Menor resolucion espacial
Lena_128 = imresize(Lena,0.25);
figure, imshow(Lena_128)
imwrite(Lena_128, 'Lena_128.tif'),  title('Lena 128')


%% ----- Interpolación
%-- Crear una imagen del mismo tamaño que la imagen original
%-- 'nearest' Interpolación de vecino más cercano; al píxel de salida se le 
%-- asigna el valor del píxel en el que se encuentra el punto. 
%-- No se consideran otros píxeles.
Lena_512a = imresize (Lena_128,4,'nearest');
figure, imshow(Lena_512a), title('Lena nearest')

%-- 'bilinear' Interpolación bilineal; el valor de píxel de salida es un 
%-- promedio ponderado de píxeles en la vecindad 2 por 2 más cercana
Lena_512a = imresize (Lena_128,4,'bilinear');
figure, imshow(Lena_512a), title('Lena bilineal')

%% ----- Reducción del número de niveles 
%-- La calidad de una imagen también depende del número de niveles de intensidad
%-- utilizados (resolución en intensidad)
close all;
Lena = imread('Lena_512.tif');
[Lena_512_16, MAP_16niv] = gray2ind(Lena, 16);
[Lena_512_4, MAP_4niv] = gray2ind(Lena, 4);
[Lena_512_2, MAP_2niv] = gray2ind(Lena, 2);

figure;
subplot(1, 3, 1), imshow(Lena_512_16, MAP_16niv), title('16 niveles');
subplot(1, 3, 2), imshow(Lena_512_4, MAP_4niv), title('4 niveles');
subplot(1, 3, 3),imshow(Lena_512_2, MAP_2niv), title('2 niveles');

%%
%% III.  Histograma y mejora de contraste
%%
%% ----- Histograma
%-- El histograma de una imagen permite observar cuantitativamente la 
%-- distribución de niveles de intensidad de una imagen --> 'imhist'
%-- Si la funcion 'imhist' se utiliza sin argumentos de salida, se genera 
%-- una figura con visualizacion del histograma
%-- Al representa el histogreama, el segundo argumento debe  ser LUT
figure;
subplot(4,1,1), imhist(Lena,256), title('Historgrama original')
subplot(4,1,2), imhist(Lena_512_16,MAP_16niv), title('Historgrama 16')
subplot(4,1,3), imhist(Lena_512_4,MAP_4niv), title('Historgrama 4')
subplot(4,1,4), imhist(Lena_512_2,MAP_2niv), title('Historgrama 2')


%% ----- Ecualización del histograma
close all;
Pout = imread('pout.tif');
Pout_eq = histeq(Pout);

figure;
subplot(2,2,1), imshow(Pout), title('Imagen original')
subplot(2,2,2), imshow(Pout_eq), title('Imagen ecualizada')
subplot(2,2,3), imhist(Pout), title('Historgrama de la imagen original')
axis auto   %--Límites de representación de los ejes de coordenadas
subplot(2,2,4), imhist(Pout_eq), title('Historgrama de la imagen ecualizada')
axis auto



%%
%% IV.  Interpretación del color y transformaciones puntuales
%%

clear all, close all, clc

%% ----- Cargar una imagen
%-- Se debe extraer la componete roja y visualizarla
Pimientos = imread('peppers.png');
Pimientos_gray = rgb2gray(Pimientos);
Pimientos_red = Pimientos( :, :, 1);

figure;
subplot(1,2,1), imshow(Pimientos_gray), title('Imagen en escala de grises')
subplot(1,2,2), imshow(Pimientos_red), title('Componente roja')

%% ----- Obtencción del histograma de cada componente R, G, B
Pimientos_grey = Pimientos(:, :, 2);
Pimientos_blue = Pimientos(:, :, 3);

figure;
subplot(1,3,1), imshow(Pimientos_red), title('Componente R')
subplot(1,3,2), imshow(Pimientos_grey), title('Componente G')
subplot(1,3,3), imshow(Pimientos_blue), title('Componente B')


%% ----- Obtencción del negativo de la componente roja
%-- Nos piden calcular el negativo; hay dos formas de implementarlo, una mal.
%-- NPimientos_red = -imagen + 255; Mal!
NPimientos_red = 255-Pimientos_red; % Bien!

%-- Volver a construir la imagen original, conservando G y B pero añadiendo
%-- el negativo de la componente roja.
Imagen = Pimientos;
Imagen( :, :, 1) = NPimientos_red;

figure;
subplot(1,2,1), imshow(NPimientos_red), title('Imagen del negativo')
subplot(1,2,2), imshow(Imagen), title('Imagen reconstruida')

%-- Para comprobar que sale bien, el ajo debería ser más o menos color cyan


%% ----- Representación del contenido de la componente roja en una imagen RGB
%-- El color predominante de la imagen resultante debe ser el rojo
%-- G y B deben de ser 0
Y = zeros(size(Pimientos));
Y = uint8(Y);
Y( :, :, 1) = Pimientos_red;

figure;
subplot(1,2,1), imshow(Pimientos), title('Imagen original')
subplot(1,2,2), imshow(Y), title('Imagen con componente roja')
