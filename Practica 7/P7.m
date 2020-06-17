%                                                       María Guadaño Nieto
%
%%%%% -------------------- Práctica 7 -------------------- %%%%%
%    ANÁLISIS DE IMAGEN UTILIZANDO HERRAMIENTAS MORFOLÓGICAS
%
%%
%% I. Preprocesado
%%
%% ----- Lectura de la imagen e identificación manualmente los 7 chips de mayor tamaño
clear all, close all, clc;

I_celulas = imread('I_celulas.bmp');
figure,
imshow(I_celulas),title('Imagen original');

%% ----- Aplicación del filtro alternado espacial (ASF3) open-close con un EE
% -- Hay que utilizar discos de tamaño creciente(radio 1, radio 2 y radio 3)
% -- Visualización de la secuencia de imágenes obtenida
% -- Tras aplicar cada una de las etapas del ASF3
%% ----- RADIO 1
EE1 = strel ('disk',1);
I_open1 = imopen(I_celulas,EE1);
I_ASF1 = imclose(I_open1, EE1);

imwrite(I_ASF1, 'I_ASF1.bmp');
figure, imshow(I_ASF1), title('Radio 1');


%% ----- RADIO 2
EE2 = strel ('disk', 2);
I_open2 = imopen(I_ASF1,EE2);
I_ASF2 = imclose(I_open2, EE2);

imwrite(I_ASF2, 'I_ASF2.bmp');
figure, imshow(I_ASF2), title('Radio 2');


%% ----- RADIO 3

EE3 = strel ('disk', 3);
I_open3 = imopen(I_ASF2,EE3);
I_ASF3 = imclose(I_open3, EE3);

imwrite(I_ASF3, 'I_ASF3.bmp');
figure, imshow(I_ASF3), title('Radio 3');



%%
%% II. Segmentación por watershed
%%
%% a. Obtención de los marcadores de célula
close all;

%% ----- i.Obtención del negativo de 'I_ASF3'
I_neg = imcomplement(I_ASF3);
figure, imshow(I_neg), title('Negativo de I ASF3')


%% ----- ii.Erosionar 'I_neg' con un EE plano
% -- Un EE plano correspondiente a un disco 9 --> 'I_marker'
EE9 = strel('disk', 9);
I_marker = imerode(I_neg, EE9);
figure, imshow(I_marker), title('Erosión del negativo de I ASF3')

%% ----- iii.Reconstrucción morfológica de 'I_neg' utilizando un marcador 'I_market'
I_rec = imreconstruct(I_marker, I_neg);
figure, imshow(I_rec), title('Reconstrucción morfológica del negativo')

%% ----- iv.Obtención de una imagen binaria
% -- Los pixeles de primer plano tienen que indicar los máximos regionales
% -- de 'I_rec' --> 'I_max_reg'
I_max_reg = imregionalmax(I_rec);
figure; imshow(I_max_reg), title('Imagen binaria de la imagen reconstruida')

% -- Hay que eliminar grupos de pixeles con máximos que no interesan
I_max_reg2 = imclearborder (I_max_reg);
figure, imshow(I_max_reg2), title('Eliminación de supuestos máximos')

% --Para eliminar estas regiones se realiza una segmentacion bibaria y 
% -- se obtiene la caracteristica de nivel medio de la imagen.
% -- Consideraremos 150 como el valor de intensidad umbral para determinar
% -- si el mínimo regional corresponde o no al interior de una célula.
I_max_reg3= I_max_reg2;
 cc = bwlabel(I_max_reg2);
 n_objetos = max(max(cc(:)));
 stats = regionprops(cc,I_celulas, 'MeanIntensity');
 for nob=1:n_objetos
     if stats(nob).MeanIntensity >= 150
         [r,c] = find(cc == nob);
         I_max_reg3(r,c)=0;
     end
 end 
 
 figure; imshow(I_max_reg3), title('Marcador interno')



%% b. Obtención del marcador externo
close all;
% -- Hacemos segmentacion por watershed. Primero se dilata la imagen para
% -- asegurarse que el marcador esta fuera de la celula, con un disco de
% -- radio 7 (expandimos los punto de primer plano), a continuacion se
% -- realiza watershed para..................
 
I_dilate = imdilate(logical(I_max_reg3),strel('disk',7));
D = bwdist(I_dilate);
DL = watershed(D);
bgm = (DL == 0);
figure, imshow(imadd(255*uint8(bgm),I_celulas)), title('Imagen binaria final')

%% c. Combinación de los marcadores internos y externos
close all;
I_minimos = bgm | I_max_reg3;
figure, imshow(I_minimos), title('Minimos')



%% d. Obtención de la variable asociada a la técnica watershed
close all;
H_Sobel = fspecial('Sobel');
I_horiz = imfilter(double(I_celulas), H_Sobel);
figure, imshow(I_horiz);
I_vert = imfilter(double(I_celulas), H_Sobel');
figure, imshow(I_vert);
I_celulas_grad = sqrt((I_horiz.^2) + (I_vert.^2));
figure, imshow(I_celulas_grad, []), title('Módulo del gradiente')


%% e. Reducción de los mínimos regionales para evitar la sobresegmentación
close all;

% -- Hay que poner los marcadores para watershed 
% -- (automaticamente con el comando)
I_celulas_grad_mrk = imimposemin (I_celulas_grad, I_minimos);


%% f. Aplicación de la técnica de segmentación por watershed y extracción de las líneas de watershed
close all;
L = watershed (I_celulas_grad_mrk);
L_frontera = (L == 0);
figure; imshow(L_frontera), title('Segmentación watershed')


%% g. Superposición de la imagen 'L_frontera' a la imagen partida
close all;
I_Superpuesta = imadd(I_celulas, uint8(255*L_frontera));
figure, imshow(I_Superpuesta), title('Superposución de imagenes')






