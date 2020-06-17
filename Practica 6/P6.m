%                                                       María Guadaño Nieto
%
%%%%% -------------------- Práctica 6 -------------------- %%%%%
%                       MORFOLOGÍA BINARIA
%
%%
%% I. Transformación del espacio de representación
%%
%% ----- Lectura de la imagen e identificación manualmente los 7 chips de mayor tamaño
clear all, close all, clc;

I = imread('Board_Recorte.tif');
figure,imshow(I),title('Imagen original')


%% ----- Visualización cada componente (R, G, B)
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
figure,
subplot(1,3,1), imshow(R), title('Componente R');
subplot(1,3,2), imshow(G), title('Componenete G');
subplot(1,3,3), imshow(B), title('Componente B');




%% ----- Transformación al espacio de representación HSI
[H,S,I] = rgb2hsi(I);

% -- Visualización de las componentes de la imagen transformada
figure,
subplot(1,3,1), imshow(H), title('H');
subplot(1,3,2), imshow(S), title('S');
subplot(1,3,3), imshow(I), title('I');

%% ----- Histograma de H
figure, imhist(H),title('Histograma de H');
%% ----- Histograma de S
figure, imhist(S),title('Histograma de S');
%% ----- Histograma de I
figure, imhist(I),title('Histograma de I');
%% ----- Elección de una componente
% -- Nos quedamos conla saturación para segmentar
% -- Tiene valores entre [0,1]
Componente = S;
figure, imhist(Componente),title('Histograma de la Componente S');




%%
%% II. Umbralización y filtrado
%%
%% ----- Observación dle histograma para la elección del valor del umbral
close all;

Umbral = graythresh(Componente);

% -- Umbralizamos con dicho valor, obtenemos una imagen binaria
Componente_U = im2bw(Componente,Umbral);
I_bin = uint8(255*Componente_U);

figure, 
subplot(1,2,1), imshow(Componente), title('Saturacion');
subplot(1,2,2), imshow(I_bin), title('Binaria escalada');

%% ----- Filtrado con un Filtro de Mediana
% -- Para homogeneizar el inteior del chip pero no modificandolo,
% -- podemos utilizar un filtro de mediana
I_filt = medfilt2(I_bin,[5 5]);
figure, imshow(I_filt), title('Imagen Umbralizada y filtrada con Filtro de Mediana 5x5');



%%
%% III. Aplicación de operadores morfológicos
%%
%% ----- Definición de un elemento estructurante (EE)
close all;
% -- Para definir el elemento se utiliza la instrucción 'strel'
% -- Se genera un EE cuadrado de lado 35 píxeles
EE_cuadrado = strel('square', 35); 

%% ----- Erosión
I_erosion = imerode(I_filt, EE_cuadrado); 
figure, imshow(I_erosion), title('Erosión')
%% ----- Dilatación
I_dilat = imdilate(I_filt, EE_cuadrado); 
figure, imshow(I_dilat), title('Dilatación')
%% ----- Apertura
I_apert = imopen(I_filt, EE_cuadrado); 
figure, imshow(I_apert), title('Apertura')
%% ----- Cierre
I_cierre = imclose(I_filt, EE_cuadrado); 
figure, imshow(I_cierre), title('Cierre') % Nos quedamos con esta imagen

%% ----- Imagen resultante
Im_Res_Morf =I_cierre; 
figure, imshow(Im_Res_Morf), title('Imagen resultante (Imagen cierre)')

%% ----- Negativo de la imagen resultante
Im_Res_Morf = 255 - I_cierre; 
figure, imshow(Im_Res_Morf), title('Negativo de la Imagen resultante')

%%
%% IV. Segmentación y caracterización de objetos
%%
%% ----- Segmentación de una imagen binaria
close all;
% -- Para realizar la segmentación binaria se utiliza la función 'bwlabel'
% -- Esta función se utiliza para indicar la vecindad considerada
IM_Seg = bwlabel(Im_Res_Morf); % Vecindad a 8

%% ----- Segmentación de la imagen ‘Im_Res_Morf’
% -- Capa de segmentación
RGB_Segment = label2rgb(IM_Seg);
figure, imshow(RGB_Segment), title('Imagen RGB segmentada')

%% ----- Obtención del número de objetos
Num_objetos = max(IM_Seg(:))
imtool(IM_Seg,[])


%% ----- Determinación del número de chips de forma cuadrada o rectangular
% -- Para realizar este apartado se utiliza la funcion 'regionprops'
Props = regionprops(IM_Seg, 'Eccentricity');
j = 1;
z = 1;
for i = 1:Num_objetos
    Props_Res(i) = Props(i).Eccentricity;
    if Props_Res(i) < 0.5
        Props_Cuad(j) = Props(i).Eccentricity;
        j = j + 1;
    elseif Props_Res(i) > 0.5
        Props_Rect(z) = Props(i).Eccentricity;
        z = z + 1;
    end
end

%% ----- Extracción de los contornos
% -- Para la obtener los contornos (finos) de los chips utilizando
% -- únicamente un elemento estructurante
% -- Mirar la variable props y buscar en Matlab los valores
EE = strel('square', 5);

% -- Obtencion de los contornos finos. Delimitación de los chips
% -- Contornos : exterior, (Ver video)
% 1 definir el EE (Forma y tamaño)
% 2 Aplicamos dilatación con EE
% 3 Aplicamos erosión con EE
% 4 imtool(Gradiente)
% --> Definición de la Frontera
% -- Segmento erosionado
I_Seg_erode = imerode(IM_Seg, EE); 
% -- Segmento dilatado
I_Seg_dilat = imdilate(IM_Seg, EE); 

% -- Calculo del Gradiente
I_contornos = I_Seg_dilat - I_Seg_erode;

figure, 
subplot(1,3,1), imshow(I_Seg_erode);
subplot(1,3,2), imshow(I_Seg_dilat);
subplot(1,3,3), imshow(I_contornos);





