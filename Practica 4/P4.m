%                                                       María Guadaño Nieto
%
%%%%% -------------------- Práctica 4 -------------------- %%%%%
%                   SEGMENTACIÓN DE IMAGEN (I)
%
%%
%% I. Histograma y umbralización
%%
%% ----- Lectura de la imagen y análisis del histograma
clear all, close all, clc;

I = imread('calculadora.TIF');
imtool(I);
figure, imhist(I), title('Histograma');

%% ----- Umbralización de la imagen
close all;

valor = 230;
umbral = valor/255;
I_U = im2bw(I, umbral);
imshow(I_U);



%%
%% II. Segmentación y caracterización de regiones
%%
%% ----- Segmentación de una imagen binaria
close all;

% -- La etiqueta 0 es el color blanco.
[Seg_I_U, Nobjetos] = bwlabel(I_U);
imtool(Seg_I_U,[])

%% ----- Visualización de la imagen en falso color
RGB_Segment = label2rgb(Seg_I_U);
figure, imshow(RGB_Segment)

%% ----- Analisis de las propiedades de las regiones segmentadas
% -- Este analisis se realiza para eliminar aquéllas que no interesan

% -- La función 'regionprops' permite analizar determinadas propiedades de 
% -- los objetos segmentados.
% -- Esta función toma como uno de los argumentos de entrada la capa de etiquetas
% -- obtenida de la segmentación (variable Seg_I_U), y como otro argumento la 
% -- característica de los objetos/regiones que se desea conocer. Puesto que 
% -- estamos interesados en el tamaño de los objetos consideraremos la propiedad
% -- 'Area', que proporciona el número de píxeles de un objeto.

Props = regionprops(Seg_I_U, 'Area')
% -- 'et' hace referencia al número de etiqueta
% -- Los valores de las siguientes etiquetas los cogemos del props
% -- Props = 61×1 struct array with fields
et1 = 10;
et2 = 61; % Dos valores con poca área

Area_et1 = Props(et1).Area % Valor 1
Area_et2 = Props(et2).Area % Valor 4

%% ----- Cálculo del área de todos los objetos
V_Area = [];
for ind_obj=1:Nobjetos
	V_Area = [V_Area Props(ind_obj).Area];
end


%% ----- % Representación del Área de cada objeto etiquetado
% -- Se realiza para filtrar los objetos con poca área
% -- el comando 'stem' es para representar en una gráfica el tamaño de 
% -- cada objeto
figure, stem(V_Area);
title('Área (nº píxeles) de cada objeto segmentado');

%% ----- Construcción de manera manual (no automática) un array uni-dimensional (vector)
close all;
V_No_Interes = [3, 10, 61];



%% ----- Filtrado de la imagen binaria I_U, lasregiones de no interés
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

% -- Visualización la imagen binaria resultante
figure, imshow(I_U), title('Imagen binaria filtrada');

% -- Se debería tener al menos una región en elinterior de cada tecla y no 
% -- debería haber píxeles de primer plano en el exterior de las teclas.




%%
%% III. Procesado para identificación de la tecla ‘Enter’
%%
%% ----- Procesamiento de la imagen binaria I_U
close all;

% -- Se procesa la imagen binaria I_U para agrupar en una misma región 
% -- los caracteres asociados a la misma tecla, lo que permitiría caracterizar
% -- cada tecla con una región diferente.
% -- Para ello, se realiza un filtrado espacial de media (con una máscara de 
% -- tamaño 5x5 sobre la imagen binaria I_U.


% -- Problema: asociada a la tecla enter hay varios objetos (varios pixeles conexos)
% -- Hay que agrupar los píxles conexos de diferentes objetos que haya en un mismo grupo
% -- Lo que hay que hacer es coger el objeto de mayor área.

% -- Al hacer una media, las letras se van a difuminar,
% -- se van a unir en un nivel de gris intermedio.
% -- Aprovechando que la distancia entre objetos de interes (texto en teclas)
% -- es menor que la distancia que hay entre las teclas,
% -- a 'imfilter' se le mete una imagen uint8 (convertir binaria
% ('logical')).

% -- Elegir umbral con el histograma
% -- VARIABLE: imagen umbralizada con el filtro de media
% -- (tenemos machas de distinto tamaño, coger la mayor) --> hacer lo mismo 
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

%% ----- Segmentación de la imagen filtrada 
close all;

%-- Antes de la segmentación se umbraliza la imagen
I_U_Fmedia_Umb = im2bw(I_U_Fmedia, 1/255);
figure, imshow(I_U_Fmedia_Umb), title('Imagen filtrada umbralizada');

% -- Se realiza la segmentación
[Seg_I_U_Umb, Nobjetos_Umb] = bwlabel(I_U_Fmedia_Umb);
imtool(Seg_I_U_Umb, []); % Corchete: ajuste automático del rango dinámico
% -- Visualización de la imagen en falso color
RGB_segment_Umb = label2rgb(Seg_I_U_Umb); 
imtool(RGB_segment_Umb, []);


%% ----- Identificación de etiqueta Enter
close all;
% -- La tecla Enter es la tecla que más pixeles tiene.
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

figure, imshow(I_U_Fmedia_Umb), title('Imagen filtrada botón ENTER');

% -- Hay que hacer una operacion punto a punto, usando la imagen
% -- filtrada como máscara
I_U_Fmedia_Umb_uint8 = uint8(I_U_Fmedia_Umb);
I_uint8 = uint8(I);
I_Enter = I_uint8 .* I_U_Fmedia_Umb_uint8;
figure, imshow(I_Enter), title('Tecla ENTER');
