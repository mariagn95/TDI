%                                                       Mar�a Guada�o Nieto
%
%%%%% -------------------- Pr�ctica 5 -------------------- %%%%%
%                   SEGMENTACI�N DE IMAGEN (II)
%
%%
%% I. An�lisis visual de la imagen
%%
%% ----- Lectura de la imagen 
clear all, close all, clc;

I = imread('cormoran_rgb.jpg');
figure,imshow(I),title('Imagen original')

%% ----- Convertir la imagen a escala de grises y analisis de su histograma
I_gris = rgb2gray(I);
figure,
subplot(1,2,1),imshow(I_gris),title('Imagen escala de grises')
subplot(1,2,2),imhist(I_gris),title('Histograma')

%% ----- Segmentaci�n
I_bw = im2bw(I_gris, 200/255); %160 y 210 son los umbrales (histograma)
figure, imshow(I_bw),title('Imagen binaria')

% -- No se puede segmentar en binaria

% -- los puntos rojos son los centroides que tiene que estar en el centro de
% -- una nube de puntos. 
% -- En esta foto ocurre porque el rango dinamicos es mas o menos de 150.
% -- El algoritmo k-medias se basa en la distancia. 
% -- Los puntos rojos que no esten en la nube de puntos tienen que estar en
% -- el centro de una nube.
% -- Por ejemplo en este caso lo moveriamos en el eje x. Entonces normalizamos 
% -- (estandarizamos): a= a-mean(a)/std(a)
% -- lo hacemos con la a y con la b.

% -- std: desviaci�n tipica la dispersion de valores entorno a la media

% -- Y luego segmentamos

% -- Como lo mejoramos: nos vamos a la imagen original (grises) cogemos
% -- ventanas de 7x7 , vamos desplazando la ventana y sacamos tres tipos la
% -- entropia, el rango dinamico y la desviacion tipica.
% -- Las utilizamos como descriptores de textura. 

% -- Elegimos entropia y desviacion tipica y le aplicamos el algoritmo k-medias
% -- Obtenemos sobresegmentacion �Por qu�? porque los descriptores de textura
% -- no son adecuados. 
% -- Nos quedamos con color salia mejor y a�adimos una de textura. 
% -- Seleccionamos un descriptor tipico homogeneo, en este caso es
% -- mejor la entropia porque es mas homogena y lo que quiero es segmentar los
% -- tres objetos
% -- Combinamos caracteristicas de color filtradas y de textura



%%
%% II. Caracter�sticas RGB y algoritmo k-medias
%%
%% ----- Segmentaci�n de la imagen original I
% -- Para realizar la segmentaci�n se consideran como caracter�sticas
% -- los niveles de intensidad de las componentes R, G y B.
close all;

% -- Extracci�n de cada componente de color de la imagen I.
I_R = I(:,:,1);
I_G = I(:,:,2);
I_B = I(:,:,3);

figure,
subplot(1,3,1),imshow(I_R),title('Imagen R')
subplot(1,3,2),imshow(I_G),title('Imagen G')
subplot(1,3,3),imshow(I_B),title('Imagen B')

%% ----- Conversi�n de cada componente en un vector columna
% -- Para realizar la conversi�n se utiliza el comando 'reshape'
% -- Componente R
[nrows,ncols,ndim] = size(I_R);
I_R_res = reshape(I_R,nrows*ncols,1);
% -- Componente G
[nrows,ncols,ndim] = size(I_G);
I_G_res = reshape(I_G,nrows*ncols,1);
% -- Componente B
[nrows,ncols,ndim] = size(I_B);
I_B_res = reshape(I_B,nrows*ncols,1);


%% ----- Representaci�n el scatter plot de los datos
% -- Para ello se utiliza la funci�n 'plot3'
% -- 'plot3': Traza puntos como marcadores sin l�neas
figure, plot3(I_R_res,I_G_res,I_B_res,'.' );

%-- Para representarlo en tres dimensiones con label le damos nombre a cada
%-- componente
xlabel('R'),ylabel('G'),zlabel('B');

%% ----- Aplicaci�n del algoritmo de agrupamiento k-medias
% -- K=3 porque hay 3 objetos.
% -- Utilizaremos para ello la funci�n 'kmeans'
ngrupos = 3;

% -- Creamos nueva estructura de datos(Nueva mtx)
rgb_res= double([I_R_res, I_G_res, I_B_res]);

% -- Matlab se queda con la mejor ejecucion de cluster center(ptos rojos)
% -- Aplicamos la funcion kmeans con el valor de k=3, con 10 inicializacion

% -- Las entradas a la funci�n kmeans son:
% -- (1) conjunto de ejemplos/observaciones:matriz rgb_res, donde
% -- cada ejemplo es una fila y cada columna representa una caracter�stica

% -- (2)medida de similitud: cuadrado de la distancia Eucl�dea en nuestro caso,
% -- indicado a trav�s del par�metro 'distance'

% -- (3) n�mero de inicializaciones:utilice el valor 10 en esta pr�ctica, 
% -- indicado con el par�metro 'Replicates'

% -- El algoritmo kmeans devuelve la posici�n de los centroides (variable cluster_center)
% -- y una etiqueta identificativa del cluster al que pertenece cada punto de entrada 
% -- (variable cluster_idx).


% -- NOTA IMPORTANTE
% -- la matriz de ejemplos/observaciones debe ser de tipo double; cada fila de
% -- la matriz es una observaci�n (p�xel de la imagen, en este caso) y cada 
% -- columna es una caracter�stica.

% -- Las salidas de la funci�n son: 
% -- (1) identificador del cluster al que pertenece cada punto(variable cluster_idx),
% -- y (2) centroide de cada cluster (variable cluster_center).


[cluster_idx cluster_center] = kmeans(rgb_res, ngrupos, 'distance','sqEuclidean','Replicates',10);
pixel_labels_rgb=reshape(cluster_idx,nrows,ncols);

% -- cluster idx es un identificador(vector) que contiene las etiquetas
% -- asociadas a cada pixel

% -- cluster idx: numero de pixel que tiene la imagen solo tenemos 3 columnas
% -- son las etiquetas: la que mas pixeles tiene corresponde al mar
figure, hist(cluster_idx);
title('numero de pixel por imagen')


%% ----- Observar el resultado del algoritmo k-medias
figure, plot3(I_R_res, I_G_res, I_B_res, '.'); hold on;
xlabel('R'),ylabel('G'),zlabel('B');
% -- Estamos pintando los centros rojos
plot3(cluster_center(:,1),cluster_center(:,2),cluster_center(:,3),'sr','MarkerSize',20,'MarkerEdgeColor','r');

% -- Necesitamos una capa de etiquetas, que est�n en cluster_idx. Esto es un
% -- vector columna, que necesitamos para pasar a formato imagen y as� poder
% -- segmentar.

% -- La capa de segmentacion es poner el vector en la capa de tres dimensiones
% -- y visualizarlo con colores. Pasamos la capa de etiquetas a colores
% -- aleatorios
figure, imshow(pixel_labels_rgb, []), title('Segmentacion - RGB sin normalizaci�n')
I_segm = label2rgb(pixel_labels_rgb);
figure, imshow(I_segm)
title('Etiquetas colores aleatorios asociados a esas etiquetas')


%%
%% III. Caracter�sticas crom�ticas ab
%%
%% ----- Transformaci�n de la imagen original (espacio RGB) al espacio Lab
close all;

% -- Cambio al espacio lac y considero unicamente el espacio ab
[lab_imL, l_L, a_L, b_L] = rgb2lab(I);
a_res = reshape(a_L,nrows*ncols,1);
b_res = reshape(b_L,nrows*ncols,1);

figure, plot(a_res, b_res,'.')
xlabel('a'), ylabel('b')



%% ----- Representaci�n del scatter plot correspondiente 
ngrupos_lab = 3;
lab_res = double([a_res b_res]);
[cluster_idx, cluster_center] = kmeans(lab_res,ngrupos_lab,'distance','sqEuclidean','Replicates',10);
plot(cluster_center(:,1), cluster_center(:,2),'sr');




%%
%% IV. Caracter�sticas de textura
%%
%% ----- Lectura de la imagen y an�lisis del histograma











%%
%% V. Utilizaci�n de caracter�sticas de distinta naturaleza
%%
%% ----- Lectura de la imagen y an�lisis del histograma










