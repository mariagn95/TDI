% -- Practica 5: Segmentacion de Imagen (II)
% Como son tres objetos K=3

%% I Analisis visual de la imagen
close all;
clear all;

I = imread('cormoran_rgb.jpg')
figure, imshow(I);
I_gray = rgb2gray(I);
I_bw = im2bw(I_gray, 200/255) %160 y 210 son los umbrales (histograma)
figure,
subplot(2,3,1);
imshow(I_gray);
title('Imagen a escala de grises')
subplot(2,3,2)
imhist(I_gray), axis('auto');
title('Histograma de la I_gray')
subplot(2,3,3)
imshow(I_bw);
title('Imagen binaria')




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

%-- std: desviación tipica la dispersion de valores entorno a la media

% -- Y luego segmentamos

% -- Como lo mejoramos: nos vamos a la imagen original (grises) cogemos
% -- ventanas de 7x7 , vamos desplazando la ventana y sacamos tres tipos la
% -- entropia, el rango dinamico y la desviacion tipica.
% -- Las utilizamos como descriptores de textura. 

% -- Elegimos entropia y desviacion tipica y le aplicamos el algoritmo k-medias
% -- Obtenemos sobresegmentacion ¿Por qué? porque los descriptores de textura
% -- no son adecuados. 
% -- Nos quedamos con color salia mejor y añadimos una de textura. 
% -- Seleccionamos un descriptor tipico homogeneo, en este caso es
% -- mejor la entropia porque es mas homogena y lo que quiero es segmentar los
% -- tres objetos
% -- Combinamos caracteristicas de color filtradas y de textura

%% II Caracteristicas RGB y algoritmo k-medias
close all;
%-- Extracción de las tres componentes RGB
I_R = I(:,:,1);
I_G = I(:,:,2);
I_B = I(:,:,3);

figure,
subplot(2,3,1);
imshow(I_R);
title('Imagen R')
subplot(2,3,2)
imshow(I_G);
title('Imagen G')
subplot(2,3,3)
imshow(I_B);
title('Imagen B')

% le damos otra forma a la estructura de datos (reshape)
%Redimensionamos la componente extraida con el tamaño real de la foto
[nrows,ncols,ndim] = size(I);
I_R_res = reshape(I_R,nrows*ncols,1);
I_G_res = reshape(I_G,nrows*ncols,1);
I_B_res = reshape(I_B,nrows*ncols,1);

%Para representarlo en tres dimensiones con label le damos nombre a cada
%componente

figure, plot3(I_R_res,I_G_res,I_B_res,'.b' );
xlabel('R'),ylabel('G'),zlabel('B');

%Aplicamos el algoritmo k-medias con k=3

ngrupos = 3;
%Creamos nueva estructura de datos(Nueva mtx)
rgb_res= double([I_R_res, I_G_res, I_B_res]);
 %Matlab se queda con la mejor ejecucion de cluster center(ptos rojos)
 %Aplicamos la funcion kmeans con el valor de k=3, con 10 inicializacion
[cluster_idx cluster_center] = kmeans(rgb_res, ngrupos, 'distance','sqEuclidean','Replicates',10);
pixel_labels_rgb=reshape(cluster_idx,nrows,ncols);

%cluster idx es un identificador(vector) que contiene las etiquetas
%asociadas a cada pixel
%cluster idx: numero de pixel que tiene la imagen solo tenemos 3 columnas
%son las etiquetas: la que mas pixeles tiene corresponde al mar
figure, hist(cluster_idx);
title('numero de pixel por imagen')
figure, plot3(I_R_res, I_G_res, I_B_res, '.b');
xlabel('R'),ylabel('G'),zlabel('B');
hold on
%Estamos pintando los centros rojos
plot3(cluster_center(:,1),cluster_center(:,2),cluster_center(:,3),'sr','MarkerSize',20,'MarkerEdgeColor','r');

%La capa de segmentacion es poner el vector en la capa de tres dimensiones
%y visualizarlo con colores. Pasamos la capa de etiquetas a colores
%aleatorios
figure, imshow(pixel_labels_rgb, []), title('Segmentacion - RGB sin normalización')
I_segm = label2rgb(pixel_labels_rgb);
figure, imshow(I_segm)
title('Etiquetas colores aleatorios asociados a esas etiquetas')

%% III Caracteristicas cromaticas a b
%Cambio al espacio lac y considero unicamente el espacio ab
[lab_imL,l_L,a_L,b_L]= rgb2lab(I);
a_res=reshape(a_L,nrows*ncols,1);
b_res=reshape(b_L,nrows*ncols,1);

%Estamos representando las coordenadas x-y
figure,
subplot(2,2,1)
mesh(a_L)
subplot(2,2,2)
mesh(b_L)

%No me quiero quedar con la componente L porque no tiene croma
%me quedo con el reshape de la componente a y b y contruyo una mtx
ab_res=[a_res b_res];
[cluster_idx cluster_center] = kmeans(ab_res,ngrupos,'distance','sqEuclidean','Replicates',10);

%Como tenemos tres centroides la matriz va a ser 3x2 
figure, plot(a_res,b_res,'.');
xlabel('a'), ylabel('b')
hold on
plot(cluster_center(:,1), cluster_center(:,2),'sr');

%Normalizamos las variables
pixel_labels_ab=reshape(cluster_idx,nrows,ncols)
I_segm=label2rgb(pixel_labels_ab);
figure, imshow(I_segm),title('Segm ab')
%normalizamos las dos componentes para que tengan media 0 y std 1
ab_res = [a_res b_res];
ndim = size(ab_res,2);
ab_norm = ab_res;
for ind_dim=1:ndim
    datos = ab_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ab_norm(:,ind_dim)=datos_norm;
end

[cluster_idx_norm cluster_center]=kmeans(ab_norm,ngrupos,'distance','sqEuclidean','Replicates',10);
pixel_labels_ab_norm=reshape(cluster_idx_norm,nrows,ncols);

I_segm=label2rgb(pixel_labels_ab_norm);
figure, imshow(I_segm), title('Segm ab norm');
figure, plot(ab_norm(:,1), ab_norm(:,2),'.');
xlabel('a-norms'), ylabel('b-norms')
hold on
plot(cluster_center(:,1), cluster_center(:,2),'sr');

%% IV Caracteristicas de textura
%Si aumentamos el tamaño del filtro al final deja de ser local
E= entropyfilt(I_gray, ones(7,7));
%A mayor entropia mas inhomogenea es la imagen en cuanto a caracteristicas
%de textura
S=stdfilt(I_gray,ones(7,7));
R=rangefilt(I_gray,ones(7,7));

imtool(E,[]),title('Entropia');
imtool(S,[]),title('Desviación estandar');
imtool(R,[]),title('Rango dinamico');

%Escogemos dos componentes, normalizamos el rango y hacemos k-medias
E_res=reshape(E,nrows*ncols,1);
S_res=reshape(S,nrows*ncols,1);
ES_res=[E_res S_res]

ndin=size(ES_res,2);
ES_norm= ES_res;

for ind_dim=1:ndim
    datos = ES_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ES_norm(:,ind_dim)=datos_norm;
end

[cluster_idx cluster_center]=kmeans(ES_norm,ngrupos,'distance','sqEuclidean','Replicates',10);

pixel_labels_ES_norm=reshape(cluster_idx_norm,nrows,ncols);

I_segm=label2rgb(pixel_labels_ES_norm);
figure, imshow(I_segm), title('Segm ES norm');
figure, plot(ab_norm(:,1), ab_norm(:,2),'.');
xlabel('E-norms'), ylabel('S-norms')
hold on
plot(cluster_center(:,1), cluster_center(:,2),'sr');

%% Hacemos la combinacion de ab y E (por ejemplo)
[cluster_idx_norm cluster_center]=kmeans([ab_norm ES_norm(:,1)],ngrupos,'distance','sqEuclidean','Replicates',10);
pixel_labels_abE_norm=reshape(cluster_idx_norm,nrows,ncols);

figure, plot3(ab_norm(:,1), ab_norm(:,2),ES_norm(:,1),'.');
xlabel('a-norms'), ylabel('b-norms'), zlabel('ES-norms'), 
hold on
plot3(cluster_center(:,1), cluster_center(:,2),cluster_center(:,3),'sr','MarkerSize',20,'MarkerEdgeColor','r');
xlabel('a'), ylabel('b'), zlabel('E')

I_segm= label2rgb(pixel_labels_abE_norm);
figure, imshow(I_segm), title('segm abE NORM');

%% Hacemos filtro paso alto y filtro paso bajo
%Objetivo: Quitar los puntos que salen aparte que no pertencen al cormoran
%Hacemos filtro paso bajo y filtro paso alto de la componente a y b

mascara = 1/49*ones(7,7);
a_mean= imfilter(a_L,mascara,'symmetric');
b_mean= imfilter(b_L,mascara,'symmetric');

a_mean_res= reshape(a_mean,nrows*ncols,1);
b_mean_res= reshape(b_mean,nrows*ncols,1);

ab_mean_res=[a_mean_res b_mean_res];
ndim= size(ab_mean_res,2);
ab_mean_norm=ab_mean_res;

for ind_dim=1:ndim
    datos = ab_mean_res(:,ind_dim);
    datos_norm = (datos-mean(datos))/std(datos);
    ab_mean_norm(:,ind_dim)=datos_norm;
end

[cluster_idx_norm cluster_center]=kmeans([ab_mean_norm ES_norm(:,1)],ngrupos,'distance','sqEuclidean','Replicates',10);
pixel_labels_abE_mean_norm=reshape(cluster_idx_norm,nrows,ncols);

figure, plot3(ab_mean_norm(:,1), ab_mean_norm(:,2),ES_norm(:,1),'.');
xlabel('a-norms'), ylabel('b-norms'), zlabel('ES-norms'), 
hold on
plot3(cluster_center(:,1), cluster_center(:,2),cluster_center(:,3),'sr','MarkerSize',20,'MarkerEdgeColor','r');
xlabel('a'), ylabel('b'), zlabel('E')

I_segm= label2rgb(pixel_labels_abE_mean_norm);
figure, imshow(I_segm), title('segm abE NORM + E, todo norm');




















