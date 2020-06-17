%                                                       María Guadaño Nieto
%
%%%%% -------------------- Práctica 2 -------------------- %%%%%
%           FILTRADO DE IMÁGES EN EL DOMINIO ESPACIAL
%
%%
%% I. Imágenes contaminadas con ruido 
%%
clear all, close all, clc

%-- Creación de la imagen sintética
Imagen_sint = uint8(zeros(256, 256)+128);

%-- Ruido Gaussiano
R_Gaussiano = imnoise(Imagen_sint, 'gaussian', 0, 0.02);

%-- Ruido Granular
R_Granular = imnoise(Imagen_sint, 'speckle', 0.02);

%-- Ruido sal y pimienta
R_SalPim = imnoise(Imagen_sint, 'salt & pepper', 0.02);

figure;
%-- Imagenes
subplot(2,4,1), imshow(Imagen_sint), title('Imagen sintética')
subplot(2,4,2), imshow(R_Gaussiano), title('Ruido Gaussiano')
subplot(2,4,3), imshow(R_Granular), title('Ruido Granular')
subplot(2,4,4), imshow(R_SalPim), title('Ruido Sal & Pimienta')
%-- Histogramas
subplot(2,4,5), imhist(Imagen_sint), axis auto
subplot(2,4,6), imhist(R_Gaussiano), axis auto
subplot(2,4,7), imhist(R_Granular), axis auto
subplot(2,4,8), imhist(R_SalPim), axis auto


%%
%% II. Filtros espaciales suavizadores
%%
close all;

%% ----- Filtrado lineal
%-- la función 'imfilter' para llevar a cabo la operación de filtrado lineal,
%-- para lo cual toma como parámetros la imagen original y la máscara de filtrado.
%-- La imagen resultante es del mismo tipo que la imagen original.

%-- Máscara de suavizado de tamaño 5x5
H = 1/25 * ones(5,5);

%-- Máscara de 35x35
T = 1/1225 * ones(35,35);

%% ---- 'zero padding'
%-- Filtrado de la imagen sintética con ruido
%-- Ruido Gaussiano (5x5)
FR_Gaussiano = imfilter(R_Gaussiano, H);
figure;
subplot(2,2,1), imshow(R_Gaussiano), title('Ruido Gaussiano')
subplot(2,2,2), imshow(FR_Gaussiano), title('Ruido Gaussiano Filtrado - zero padding')
subplot(2,2,3), imhist(R_Gaussiano), axis auto
subplot(2,2,4), imhist(FR_Gaussiano), axis auto

%-- Ruido Granular
FR_Granular = imfilter(R_Granular, H);
figure;
subplot(2,2,1), imshow(R_Granular), title('Ruido Granular')
subplot(2,2,2), imshow(FR_Granular), title('Ruido Granular Filtrado - zero padding')
subplot(2,2,3), imhist(R_Granular), axis auto
subplot(2,2,4), imhist(FR_Granular), axis auto

%-- Ruido Sal & Pimienta
FR_SalPim = imfilter(R_SalPim, H);
figure;
subplot(2,2,1), imshow(R_SalPim), title('Ruido Sal & Pimienta')
subplot(2,2,2), imshow(FR_SalPim), title('Ruido Sal & Pimienta Filtrado - zero padding')
subplot(2,2,3), imhist(R_SalPim), axis auto
subplot(2,2,4), imhist(FR_SalPim), axis auto


%% ---- 'mirror padding'
%-- Ruido Gaussiano (5x5)
FR_Gaussiano = imfilter(R_Gaussiano, H, 'symmetric');
figure;
subplot(2,2,1), imshow(R_Gaussiano), title('Ruido Gaussiano')
subplot(2,2,2), imshow(FR_Gaussiano), title('Ruido Gaussiano Filtrado - mirror padding')
subplot(2,2,3), imhist(R_Gaussiano), axis auto
subplot(2,2,4), imhist(FR_Gaussiano), axis auto

%-- Ruido Granular
FR_Granular = imfilter(R_Granular, H, 'symmetric');
figure;
subplot(2,2,1), imshow(R_Granular), title('Ruido Granular')
subplot(2,2,2), imshow(FR_Granular), title('Ruido Granular Filtrado - mirror padding')
subplot(2,2,3), imhist(R_Granular), axis auto
subplot(2,2,4), imhist(FR_Granular), axis auto

%-- Ruido Sal & Pimienta
FR_SalPim = imfilter(R_SalPim, H, 'symmetric');
figure;
subplot(2,2,1), imshow(R_SalPim), title('Ruido Sal & Pimienta')
subplot(2,2,2), imshow(FR_SalPim), title('Ruido Sal & Pimienta Filtrado - mirror padding')
subplot(2,2,3), imhist(R_SalPim), axis auto
subplot(2,2,4), imhist(FR_SalPim), axis auto


%-- Ruido Gaussiano 35x35
FR_Gaussiano_T_zp = imfilter(R_Gaussiano, T);
FR_Gaussiano_T_mp = imfilter(R_Gaussiano, T, 'symmetric');
figure;
subplot(2,3,1), imshow(R_Gaussiano), title('Ruido Gaussiano')
subplot(2,3,2), imshow(FR_Gaussiano_T_zp), title('Ruido Gaussiano - zero padding')
subplot(2,3,3), imshow(FR_Gaussiano_T_mp), title('Ruido Gaussiano - mirror padding')
subplot(2,3,4), imhist(R_Gaussiano), axis auto
subplot(2,3,5), imhist(FR_Gaussiano_T_zp), axis auto
subplot(2,3,6), imhist(FR_Gaussiano_T_mp), axis auto



%% ----- Filtrado no lineal
%-- Uno de los filtros no lineales más utilizados es el filtro de mediana, 
%-- que asigna a cada píxel de la imagen procesada la mediana de los valores 
%-- de los píxeles situados en un entorno local --> 'medfilt2'

%-- Filtro de mediana 5x5
%-- Ruido Gaussiano
FRM_Gaussiano = medfilt2(R_Gaussiano, [5 5], 'symmetric');
figure;
subplot(2,2,1), imshow(R_Gaussiano), title('Ruido Gaussiano')
subplot(2,2,2), imshow(FRM_Gaussiano), title('Ruido Gaussiano Filtrado')
subplot(2,2,3), imhist(R_Gaussiano), axis auto
subplot(2,2,4), imhist(FRM_Gaussiano), axis auto

%-- Ruido Granular
FRM_Granular = medfilt2(R_Granular, [5 5], 'symmetric');
figure;
subplot(2,2,1), imshow(R_Granular), title('Ruido Granular')
subplot(2,2,2), imshow(FRM_Granular), title('Ruido Granular Filtrado')
subplot(2,2,3), imhist(R_Granular), axis auto
subplot(2,2,4), imhist(FRM_Granular), axis auto

%-- Ruido Sal & Pimienta
FRM_SalPim = medfilt2(R_SalPim, [5 5], 'symmetric');
figure;
subplot(2,2,1), imshow(R_SalPim), title('Ruido Sal & Pimienta')
subplot(2,2,2), imshow(FRM_SalPim), title('Ruido Sal & Pimienta Filtrado')
subplot(2,2,3), imhist(R_SalPim), axis auto
subplot(2,2,4), imhist(FRM_SalPim), axis auto



%%
%% III. Filtros espaciales de realce de contornos
%%
%% ----- Filtrado espacial
close all;
I = imread('coins.png');

%-- El comando 'fspecial' permite crear máscaras de filtrado espacial de 
%-- determinados tipos. 
%-- Crear una máscara H de tamaño 3x3
Hprew = fspecial('prewitt');

%-- Hacer traspuesta para verticales
Hprew2 = Hprew';

%-- Utilizar las dos imagenes filtradas para construir una imagen que
%-- aproxime el módulo del gradiente
I_Hprew = imfilter(double(I), Hprew, 'symmetric');

I_Hprew2 = imfilter(double(I), Hprew2, 'symmetric');

figure;
subplot(2,3,1), imshow(I), title('Imagen original')
subplot(2,3,2), imshow(uint8(abs(I_Hprew))), title('Imagen filtro prewitt')
subplot(2,3,3), imshow(uint8(abs(I_Hprew2))), title('Imagen filtro prewitt traspuesta')
subplot(2,3,4), mesh(I)
subplot(2,3,5), mesh(abs(I_Hprew))
subplot(2,3,6), mesh(abs(I_Hprew2))

I_grad_Prewitt = uint8(0.5*(abs(I_Hprew)+abs(I_Hprew2))); 

%-- Umbralización de la I_grand_Prewitt para obtener una imagen binaria
I_Binaria = imbinarize(I_grad_Prewitt, 142/255);

figure;
subplot(2,3,1), imshow(I), title('Imagen original')
subplot(2,3,2), imshow(I_grad_Prewitt), title('Imagen filtrada')
subplot(2,3,3), imshow(I_Binaria), title('Imagen binaria')
subplot(2,3,4), mesh(I),  ylim('auto');
subplot(2,3,5), mesh(I_grad_Prewitt),  ylim('auto');
subplot(2,3,6), mesh(I_Binaria),  ylim('auto');



%% ----- Filtro isotrópico
H_iso = [-1 -1 -1
         -1 8 -1
         -1 -1 -1];

I_suavi = medfilt2(I,[5 5],'symmetric');
I_iso = imfilter(I_suavi, H_iso, 'symmetric');

I_Binaria_iso = imbinarize(I_iso, 85/255);

figure;
subplot(2,3,1), imshow(I), title('Imagen original')
subplot(2,3,2), imshow(abs(I_iso)), title('Imagen isotrópica ')
subplot(2,3,3), imshow(I_Binaria_iso), title('Imagen binaria isotrópica')
subplot(2,3,4), imhist(I), axis auto
subplot(2,3,5), imhist(abs(I_iso)), axis auto
subplot(2,3,6), imhist(I_Binaria_iso), axis auto



%% ----- Filtrado con procesado (suavizado)
%-- Primero se suaviza la imagen, se fltra y se umbraliza finalmente
close all; clear all; clc;
I = imread('coins.png');
%-- Máscara de tamaño 11x11
I_suav = medfilt2(I, [11 11], 'symmetric');

%-- Filtro de realce Prewitt y su traspuesta
Hprew = fspecial('prewitt');
Hprew2 = Hprew';

%-- Filtro isotrópico
H_iso = [-1 -1 -1
         -1 8 -1
         -1 -1 -1];
     
% Calculo del gradiente con el filtro de prewitt
I_Hprew = imfilter(I_suav, Hprew, 'symmetric');
I_Hprew2 = imfilter(I_suav, Hprew2, 'symmetric');

%-- Imagen conrealce
I_realce = uint8(0.5*(abs(I_Hprew) + abs(I_Hprew2)));

%-- Gradiente para el filtro isotrópico
I_realce_iso = uint8(abs(imfilter(I_suav, H_iso, 'symmetric')));

figure
subplot(2,2,1), imshow(I_realce), title('Filtro Prewitt')
subplot(2,2,2), imshow(I_realce_iso), title('Filtro isotropico')
subplot(2,2,3), imhist(I_realce), axis auto
subplot(2,2,4), imhist(I_realce_iso), axis auto


%-- Se umbraliza la imagen y se pasan los pixeles en primer plano de 1 a 255
I_BW_realce = imbinarize(I_realce)*255;
I_BW_realce_iso = imbinarize(I_realce_iso)*255;

figure
subplot(2,3,1), imshow(I_suav), title('Suavizada')
subplot(2,3,2), imshow(I_BW_realce), title('Binaria Prewitt')
subplot(2,3,3), imshow(I_BW_realce_iso), title('Binaria Isotropico')
subplot(2,3,4), imhist(I_suav), axis auto
subplot(2,3,5), imhist(I_BW_realce), axis auto
subplot(2,3,6), imhist(I_BW_realce_iso), axis auto


%% ----- Filtro de realce
H_realce = fspecial('Prewitt'); % Horizontales
H3 = H_realce'; % Verticales

I_BW_realce_h = imfilter(I_suav, H_realce, 'symmetric');
I_BW_realce_v = imfilter(I_suav, H3, 'symmetric');

figure;
subplot(2,3,1), imshow(I), title('Imagen original')
subplot(2,3,2), imshow(abs(I_BW_realce_v)), title('Imagen con realce vertical')
subplot(2,3,3), imshow(abs(I_BW_realce_h)), title('Imagen con realce horizontal')
subplot(2,3,4), imhist(I), axis auto
subplot(2,3,5), imhist(I_BW_realce_v), axis auto
subplot(2,3,6), imhist(I_BW_realce_h), axis auto

%-- Imagen con realce vertical y horizontal
I_completa = abs(0.5*I_BW_realce_v) + abs(0.5*I_BW_realce_h);

figure;
subplot(2,2,1), imshow(I), title('Imagen original')
subplot(2,2,2), imshow(abs(I_completa)), title('Imagen con realce comleto')
subplot(2,2,3), imhist(I), axis auto
subplot(2,2,4), imhist(I_completa), axis auto



%%
%% IV. Composición de imágenes
%%
close all;

%-- Creacción de imagen RGB
I_RGB = uint8(zeros(size(I,1),size(I,2),3));

%-- Sólo nos quredamos con la componente roja
%-- Se suma la componente roja a la imagen vertical
RGB(:,:,1) = imadd(I,I_realce_iso);

%-- Las componentes G y B son las de la imagen original
RGB(:,:,2) = I; 
RGB(:,:,3) = I;

figure, imshow(RGB);
