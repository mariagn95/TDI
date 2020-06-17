%                                                       Mar�a Guada�o Nieto
%
%%%%% -------------------- Pr�ctica 4 -------------------- %%%%%
%                   SEGMENTACI�N DE IMAGEN (I)
%
%%
%% I. Histograma y umbralizaci�n
%%
%% ----- Lectura de la imagen y an�lisis del histograma
clear all, close all, clc;

I = imread('calculadora.TIF');
imtool(I);
figure, imhist(I), title('Histograma');

%% ----- Umbralizaci�n de la imagen
close all;

valor = 230;
umbral = valor/255;
I_U = im2bw(I, umbral);
imshow(I_U);



%%
%% II. Segmentaci�n y caracterizaci�n de regiones
%%
%% ----- Segmentaci�n de una imagen binaria
close all;

% -- La etiqueta 0 es el color blanco.
[Seg_I_U, Nobjetos] = bwlabel(I_U);
imtool(Seg_I_U,[])

%% ----- Visualizaci�n de la imagen en falso color
RGB_Segment = label2rgb(Seg_I_U);
figure, imshow(RGB_Segment)

%% ----- Analisis de las propiedades de las regiones segmentadas
% -- Este analisis se realiza para eliminar aqu�llas que no interesan

% -- La funci�n 'regionprops' permite analizar determinadas propiedades de 
% -- los objetos segmentados.
% -- Esta funci�n toma como uno de los argumentos de entrada la capa de etiquetas
% -- obtenida de la segmentaci�n (variable Seg_I_U), y como otro argumento la 
% -- caracter�stica de los objetos/regiones que se desea conocer. Puesto que 
% -- estamos interesados en el tama�o de los objetos consideraremos la propiedad
% -- 'Area', que proporciona el n�mero de p�xeles de un objeto.

Props = regionprops(Seg_I_U, 'Area')
% -- 'et' hace referencia al n�mero de etiqueta
% -- Los valores de las siguientes etiquetas los cogemos del props
% -- Props = 61�1 struct array with fields
et1 = 10;
et2 = 61; % Dos valores con poca �rea

Area_et1 = Props(et1).Area % Valor 1
Area_et2 = Props(et2).Area % Valor 4

%% ----- C�lculo del �rea de todos los objetos
V_Area = [];
for ind_obj=1:Nobjetos
	V_Area = [V_Area Props(ind_obj).Area];
end


%% ----- % Representaci�n del �rea de cada objeto etiquetado
% -- Se realiza para filtrar los objetos con poca �rea
% -- el comando 'stem' es para representar en una gr�fica el tama�o de 
% -- cada objeto
figure, stem(V_Area);
title('�rea (n� p�xeles) de cada objeto segmentado');

%% ----- Construcci�n de manera manual (no autom�tica) un array uni-dimensional (vector)
close all;
V_No_Interes = [3, 10, 61];



%% ----- Filtrado de la imagen binaria I_U, lasregiones de no inter�s
[n_filas, n_cols] = size(I_U);
for ind_nfila=1:n_filas
    for ind_ncol=1:n_cols
        if I_U(ind_nfila,ind_ncol)
            numero_et = Seg_I_U(ind_nfila,ind_ncol);
            if sum(ismember(V_No_Interes,numero_et)) > 0
                I_U(ind_nfila,ind_ncol) = 0;
            end
        end
    end
end

% -- Visualizaci�n la imagen binaria resultante
figure, imshow(I_U), title('Imagen binaria filtrada');

% -- Se deber�a tener al menos una regi�n en elinterior de cada tecla y no 
% -- deber�a haber p�xeles de primer plano en el exterior de las teclas.




%%
%% III. Procesado para identificaci�n de la tecla �Enter�
%%
%% ----- Procesamiento de la imagen binaria I_U
close all;

% -- Se procesa la imagen binaria I_U para agrupar en una misma regi�n 
% -- los caracteres asociados a la misma tecla, lo que permitir�a caracterizar
% -- cada tecla con una regi�n diferente.
% -- Para ello, se realiza un filtrado espacial de media (con una m�scara de 
% -- tama�o 5x5 sobre la imagen binaria I_U.


% -- Problema: asociada a la tecla enter hay varios objetos (varios pixeles conexos)
% -- Hay que agrupar los p�xles conexos de diferentes objetos que haya en un mismo grupo
% -- Lo que hay que hacer es coger el objeto de mayor �rea.

% -- Al hacer una media, las letras se van a difuminar,
% -- se van a unir en un nivel de gris intermedio.
% -- Aprovechando que la distancia entre objetos de interes (texto en teclas)
% -- es menor que la distancia que hay entre las teclas,
% -- a 'imfilter' se le mete una imagen uint8 (convertir binaria
% ('logical')).

% -- Elegir umbral con el histograma
% -- VARIABLE: imagen umbralizada con el filtro de media
% -- (tenemos machas de distinto tama�o, coger la mayor) --> hacer lo mismo 
% --que en el apartado II con props y el bucle
% 
% -- Se puede usar la imagen binaria resultante como una mascara sobre
% -- la imagen original y multiplicar elemento a elemento,
% -- siendo el resultado una imagen en escala de grises

H = 1/25 * ones(5,5);
I_U_Fmedia = imfilter(255*uint8(I_U), H, 'symmetric');

figure, 
subplot(1,2,1), imshow(I_U_Fmedia), title('Imagen filtrada media 5x5');
subplot(1,2,2), imhist(I_U_Fmedia), title('Histograma');

%% ----- Segmentaci�n de la imagen filtrada 
close all;

%-- Antes de la segmentaci�n se umbraliza la imagen
I_U_Fmedia_Umb = im2bw(I_U_Fmedia, 1/255);
figure, imshow(I_U_Fmedia_Umb), title('Imagen filtrada umbralizada');

% -- Se realiza la segmentaci�n
[Seg_I_U_Umb, Nobjetos_Umb] = bwlabel(I_U_Fmedia_Umb);
imtool(Seg_I_U_Umb, []); % Corchete: ajuste autom�tico del rango din�mico
% -- Visualizaci�n de la imagen en falso color
RGB_segment_Umb = label2rgb(Seg_I_U_Umb); 
imtool(RGB_segment_Umb, []);


%% ----- Identificaci�n de etiqueta Enter
close all;
% -- La tecla Enter es la tecla que m�s pixeles tiene.
% -- podemos elegir la etiqueta manualmente
et_enter = 5; 
for ind_nfila=1:n_filas
    for ind_ncol=1:n_cols
        if I_U_Fmedia_Umb(ind_nfila,ind_ncol)
            numero_et = Seg_I_U_Umb(ind_nfila,ind_ncol);
            if numero_et ~= 5
                I_U_Fmedia_Umb(ind_nfila,ind_ncol) = 0;
            end
        end
    end
end

figure, imshow(I_U_Fmedia_Umb), title('Imagen filtrada bot�n ENTER');

% -- Hay que hacer una operacion punto a punto, usando la imagen
% -- filtrada como m�scara
I_U_Fmedia_Umb_uint8 = uint8(I_U_Fmedia_Umb);
I_uint8 = uint8(I);
I_Enter = I_uint8 .* I_U_Fmedia_Umb_uint8;
figure, imshow(I_Enter), title('Tecla ENTER');
