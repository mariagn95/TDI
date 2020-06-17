%                                                       Mar�a Guada�o Nieto
%
%%%%% -------------------- Pr�ctica 6 -------------------- %%%%%
%                       MORFOLOG�A BINARIA
%
%%
%% I. Transformaci�n del espacio de representaci�n
%%
%% ----- Lectura de la imagen e identificaci�n manualmente los 7 chips de mayor tama�o
clear all, close all, clc;

I = imread('Board_Recorte.tif');
figure,imshow(I),title('Imagen original')


%% ----- Visualizaci�n cada componente (R, G, B)
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
figure,
subplot(1,3,1), imshow(R), title('Componente R');
subplot(1,3,2), imshow(G), title('Componenete G');
subplot(1,3,3), imshow(B), title('Componente B');




%% ----- Transformaci�n al espacio de representaci�n HSI
[H,S,I] = rgb2hsi(I);

% -- Visualizaci�n de las componentes de la imagen transformada
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
%% ----- Elecci�n de una componente
% -- Nos quedamos conla saturaci�n para segmentar
% -- Tiene valores entre [0,1]
Componente = S;
figure, imhist(Componente),title('Histograma de la Componente S');




%%
%% II. Umbralizaci�n y filtrado
%%
%% ----- Observaci�n dle histograma para la elecci�n del valor del umbral
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
%% III. Aplicaci�n de operadores morfol�gicos
%%
%% ----- Definici�n de un elemento estructurante (EE)
close all;
% -- Para definir el elemento se utiliza la instrucci�n 'strel'
% -- Se genera un EE cuadrado de lado 35 p�xeles
EE_cuadrado = strel('square', 35); 

%% ----- Erosi�n
I_erosion = imerode(I_filt, EE_cuadrado); 
figure, imshow(I_erosion), title('Erosi�n')
%% ----- Dilataci�n
I_dilat = imdilate(I_filt, EE_cuadrado); 
figure, imshow(I_dilat), title('Dilataci�n')
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
%% IV. Segmentaci�n y caracterizaci�n de objetos
%%
%% ----- Segmentaci�n de una imagen binaria
close all;
% -- Para realizar la segmentaci�n binaria se utiliza la funci�n 'bwlabel'
% -- Esta funci�n se utiliza para indicar la vecindad considerada
IM_Seg = bwlabel(Im_Res_Morf); % Vecindad a 8

%% ----- Segmentaci�n de la imagen �Im_Res_Morf�
% -- Capa de segmentaci�n
RGB_Segment = label2rgb(IM_Seg);
figure, imshow(RGB_Segment), title('Imagen RGB segmentada')

%% ----- Obtenci�n del n�mero de objetos
Num_objetos = max(IM_Seg(:))
imtool(IM_Seg,[])


%% ----- Determinaci�n del n�mero de chips de forma cuadrada o rectangular
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

%% ----- Extracci�n de los contornos
% -- Para la obtener los contornos (finos) de los chips utilizando
% -- �nicamente un elemento estructurante
% -- Mirar la variable props y buscar en Matlab los valores
EE = strel('square', 5);

% -- Obtencion de los contornos finos. Delimitaci�n de los chips
% -- Contornos : exterior, (Ver video)
% 1 definir el EE (Forma y tama�o)
% 2 Aplicamos dilataci�n con EE
% 3 Aplicamos erosi�n con EE
% 4 imtool(Gradiente)
% --> Definici�n de la Frontera
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





