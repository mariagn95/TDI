%                                                       María Guadaño Nieto
%
%%%%% -------------------- Práctica 3 -------------------- %%%%%
%       FILTRADO DE IMÁGENES EN EL DOMINIO SECUENCIAL
%
%%
%% I. Representación de la imagen en el dominio transformado 
%%
clear all, close all, clc

%-- La función 'fft2' para llevar a cabo la FFT (Transformada Rápida de Fourier, 
%-- o Fast Fourier Transform) bidimensional.

%-- La función 'fftshift' desplaza la componente de frecuencia cero al centro del espectro
X = imread('triangulo.bmp');
X_FFT = fftshift(fft2(double(X),size(X,1),size(X,2)));

figure;
subplot(1,2,1),imshow(X), title('Imagen original')
subplot(1,2,2),imshow(X_FFT), title('FFT')

%-- Magnitud y fase
FFT_modulo = abs(X_FFT);
FFT_fase = angle(X_FFT);

figure;
subplot(2,2,1), imshow(FFT_modulo, []), title('Módulo FFT')
subplot(2,2,2), imshow(FFT_fase, []), title('Fase FFT')
subplot(2,2,3), mesh(FFT_modulo)
subplot(2,2,4), mesh(FFT_fase)


%% ----- obtenención del valor asociado a la componente continua
close all;

%-- Valor máximo que tiene el módulo de la FFT
C_FFT = max(FFT_modulo(:));

%-- Componente continua = valor medio
VM_C_FFT = mean(FFT_modulo(:));





%%
%% II. Propiedades de la Transformada de Fourier
%%
clear all, close all, clc

%% ----- Leer la imagen 'triangulodesp.bmp' en la variable X y representar módulo y fase de su FFT
X = imread('triangulodesp.bmp');
X_FFT = fftshift(fft2(double(X),256,256));

%-- Magnitud y fase
FFT_modulo = abs(X_FFT);
FFT_fase = angle(X_FFT);

figure;
subplot(2,3,1), imshow(X), title('Imagen original: Trinagulo desplazado')
subplot(2,3,2), imshow(FFT_modulo, []), title('Módulo FFT')
subplot(2,3,3), imshow(FFT_fase, []), title('Fase FFT')
subplot(2,3,4), imshow(X_FFT), title('FFT de la imagen original')
subplot(2,3,5), mesh(FFT_modulo)
subplot(2,3,6), mesh(FFT_fase)

%% ----- Leer la imagen 'triangulozoom.bmp' en la variable X y representar módulo y fase de su FFT
X = imread('triangulozoom.bmp');
X_FFT = fftshift(fft2(double(X),256,256));

%-- Magnitud y fase
FFT_modulo = abs(X_FFT);
FFT_fase = angle(X_FFT);

figure;
subplot(2,3,1), imshow(X), title('Imagen original: Triangulo zoom')
subplot(2,3,2), imshow(FFT_modulo, []), title('Módulo FFT')
subplot(2,3,3), imshow(FFT_fase, []), title('Fase FFT')
subplot(2,3,4), imshow(X_FFT), title('FFT de la imagen original')
subplot(2,3,5), mesh(FFT_modulo)
subplot(2,3,6), mesh(FFT_fase)

%% ----- Leer la imagen 'triangulogirado.bmp' en la variable X y representar módulo y fase de su FFT
X = imread('triangulogirado.bmp');
X_FFT = fftshift(fft2(double(X),256,256));

%-- Magnitud y fase
FFT_modulo = abs(X_FFT);
FFT_fase = angle(X_FFT);

figure;
subplot(2,3,1), imshow(X), title('Imagen original: Triangulo girado')
subplot(2,3,2), imshow(FFT_modulo, []), title('Módulo FFT')
subplot(2,3,3), imshow(FFT_fase, []), title('Fase FFT')
subplot(2,3,4), imshow(X_FFT), title('FFT de la imagen original')
subplot(2,3,5), mesh(FFT_modulo)
subplot(2,3,6), mesh(FFT_fase)









%%
%% III. Filtrado Paso Bajo en el dominio frecuencial
%%
clear all, close all, clc

%% ----- FILTRO PASO BAJO
%% ----- Filtro ideal

X = imread('triangulo.bmp');
F = fft2(double(X));
figure,
subplot(2,3,2),imshow(X), title('Imagen orifinal: Triangulo')
subplot(2,3,5),imshow(F), title('FFT')


% -- Filtro ideal de 10
H_Ideal_10 = lpfilter('ideal', 256, 256, 10);
Filtrada_freq_Ideal_10 = H_Ideal_10.*F;
Filtrada_espacio_Ideal_10 = real(ifft2(Filtrada_freq_Ideal_10));
% -- Modulo y fase
FFT_10_modulo = abs(Filtrada_freq_Ideal_10);
FFT_10_fase = angle(Filtrada_freq_Ideal_10);

figure,
subplot(2,2,1), imshow(Filtrada_espacio_Ideal_10, []), title('Filtro ideal 10')
subplot(2,2,2), mesh(Filtrada_espacio_Ideal_10)
subplot(2,2,3), mesh(FFT_10_modulo), title('Modulo de la FFT')
subplot(2,2,4), mesh(FFT_10_fase), title('Fase de la FFT')

% -- Filtro ideal de 30
H_Ideal_30 = lpfilter('ideal', 256, 256, 30);
Filtrada_freq_Ideal_30 = H_Ideal_30.*F;
Filtrada_espacio_Ideal_30 = real(ifft2(Filtrada_freq_Ideal_30));
% -- Modulo y fase
FFT_30_modulo = abs(Filtrada_freq_Ideal_30);
FFT_30_fase = angle(Filtrada_freq_Ideal_30);

figure,
subplot(2,2,1), imshow(Filtrada_espacio_Ideal_30, []), title('Filtro ideal 30')
subplot(2,2,2), mesh(Filtrada_espacio_Ideal_30)
subplot(2,2,3), mesh(FFT_30_modulo), title('Modulo de la FFT')
subplot(2,2,4), mesh(FFT_30_fase), title('Fase de la FFT')

% -- Filtro ideal de 50
H_Ideal_50 = lpfilter('ideal', 256, 256, 50);
Filtrada_freq_Ideal_50 = H_Ideal_30.*F;
Filtrada_espacio_Ideal_50 = real(ifft2(Filtrada_freq_Ideal_50));
% -- Modulo y fase
FFT_50_modulo = abs(Filtrada_freq_Ideal_50);
FFT_50_fase = angle(Filtrada_freq_Ideal_50);

figure,
subplot(2,2,1), imshow(Filtrada_espacio_Ideal_50, []), title('Filtro ideal 50')
subplot(2,2,2), mesh(Filtrada_espacio_Ideal_50)
subplot(2,2,3), mesh(FFT_50_modulo), title('Modulo de la FFT')
subplot(2,2,4), mesh(FFT_50_fase), title('Fase de la FFT')


%-- Filtros
figure,
subplot(2,3,1), imshow(Filtrada_espacio_Ideal_10, []), title('Filtro ideal 10')
subplot(2,3,2), imshow(Filtrada_espacio_Ideal_30, []), title('Filtro ideal 30')
subplot(2,3,3), imshow(Filtrada_espacio_Ideal_50, []), title('Filtro ideal 50')
subplot(2,3,4), mesh(Filtrada_espacio_Ideal_10)
subplot(2,3,5), mesh(Filtrada_espacio_Ideal_30)
subplot(2,3,6), mesh(Filtrada_espacio_Ideal_50)


%-- Comparativa de filtros
figure,
subplot(3,3,1), imshow(Filtrada_espacio_Ideal_10, []), title('Filtro ideal 10')
subplot(3,3,2), mesh(FFT_10_modulo), title('Modulo de la FFT - F.Ideal 10')
subplot(3,3,3), mesh(FFT_10_fase), title('Fase de la FFT - F.Ideal 10')
subplot(3,3,4), imshow(Filtrada_espacio_Ideal_30, []), title('Filtro ideal 30')
subplot(3,3,5), mesh(FFT_30_modulo), title('Modulo de la FFT - F.Ideal 30')
subplot(3,3,6), mesh(FFT_30_fase), title('Fase de la FFT - F.Ideal 30')
subplot(3,3,7), imshow(Filtrada_espacio_Ideal_50, []), title('Filtro ideal 50')
subplot(3,3,8), mesh(FFT_50_modulo), title('Modulo de la FFT - F.Ideal 50')
subplot(3,3,9), mesh(FFT_50_fase), title('Fase de la FFT - F.Ideal 50')

%% ----- Filtro Gaussiano

X = imread('triangulo.bmp');
F = fft2(double(X));
figure,
subplot(2,3,2),imshow(X), title('Imagen orifinal: Triangulo')
subplot(2,3,5),imshow(F), title('Módulo FFT de la imagen original')

% -- Filtro gaussiano de 10
H_Gaussian_10 = lpfilter('gaussian', 256, 256, 10);
Filtrada_freq_Gaussian_10 = H_Gaussian_10.*F;
Filtrada_espacio_Gaussian_10 = real(ifft2(Filtrada_freq_Gaussian_10));
% -- Modulo y fase
FFT_10_modulo = abs(Filtrada_freq_Gaussian_10);
FFT_10_fase = angle(Filtrada_freq_Gaussian_10);

figure,
subplot(2,2,1), imshow(Filtrada_espacio_Gaussian_10, []), title('Filtro gaussino 10')
subplot(2,2,2), mesh(Filtrada_espacio_Gaussian_10)
subplot(2,2,3), mesh(FFT_10_modulo), title('Modulo de la FFT')
subplot(2,2,4), mesh(FFT_10_fase), title('Fase de la FFT')

% -- Filtro gaussiano de 30
H_Gaussian_30 = lpfilter('gaussian', 256, 256, 30);
Filtrada_freq_Gaussian_30 = H_Gaussian_30.*F;
Filtrada_espacio_Gaussian_30 = real(ifft2(Filtrada_freq_Gaussian_30));
% -- Modulo y fase
FFT_30_modulo = abs(Filtrada_freq_Gaussian_30);
FFT_30_fase = angle(Filtrada_freq_Gaussian_30);

figure,
subplot(2,2,1), imshow(Filtrada_espacio_Gaussian_30, []), title('Filtro gaussino 30')
subplot(2,2,2), mesh(Filtrada_espacio_Gaussian_30)
subplot(2,2,3), mesh(FFT_30_modulo), title('Modulo de la FFT')
subplot(2,2,4), mesh(FFT_30_fase), title('Fase de la FFT')

% -- Filtro gaussiano de 50
H_Gaussian_50 = lpfilter('gaussian', 256, 256, 50);
Filtrada_freq_Gaussian_50 = H_Gaussian_50.*F;
Filtrada_espacio_Gaussian_50 = real(ifft2(Filtrada_freq_Gaussian_50));
% -- Modulo y fase
FFT_50_modulo = abs(Filtrada_freq_Gaussian_50);
FFT_50_fase = angle(Filtrada_freq_Gaussian_50);

figure,
subplot(2,2,1), imshow(Filtrada_espacio_Gaussian_50, []), title('Filtro gaussino 50')
subplot(2,2,2), mesh(Filtrada_espacio_Gaussian_50)
subplot(2,2,3), mesh(FFT_50_modulo), title('Modulo de la FFT')
subplot(2,2,4), mesh(FFT_50_fase), title('Fase de la FFT')

% -- Filtros
figure,
subplot(2,3,1), imshow(Filtrada_espacio_Gaussian_10, []), title('Filtro Gaussiano 10')
subplot(2,3,2), imshow(Filtrada_espacio_Gaussian_30, []), title('Filtro Gaussiano 30')
subplot(2,3,3), imshow(Filtrada_espacio_Gaussian_50, []), title('Filtro Gaussiano 50')
subplot(2,3,4), mesh(Filtrada_espacio_Gaussian_10)
subplot(2,3,5), mesh(Filtrada_espacio_Gaussian_30)
subplot(2,3,6), mesh(Filtrada_espacio_Gaussian_50)

% ----- Comparativa de filtros
figure,
subplot(3,3,1), imshow(Filtrada_espacio_Gaussian_10, []), title('Filtro Gaussiano 10')
subplot(3,3,2), mesh(FFT_10_modulo), title('Modulo de la FFT - F.Gaussiano 10')
subplot(3,3,3), mesh(FFT_10_fase), title('Fase de la FFT - F.Gaussiano 10')
subplot(3,3,4), imshow(Filtrada_espacio_Gaussian_30, []), title('Filtro Gaussiano 30')
subplot(3,3,5), mesh(FFT_30_modulo), title('Modulo de la FFT - F.Gaussiano 30')
subplot(3,3,6), mesh(FFT_30_fase), title('Fase de la FFT - F.Gaussiano 30')
subplot(3,3,7), imshow(Filtrada_espacio_Gaussian_50, []), title('Filtro Gaussiano 50')
subplot(3,3,8), mesh(FFT_50_modulo), title('Modulo de la FFT - F.Gaussiano 50')
subplot(3,3,9), mesh(FFT_50_fase), title('Fase de la FFT - F.Gaussiano 50')



%%
%% IV. Filtrado Paso Alto en el dominio frecuencial
%%
clear all, close all, clc

%% ----- FILTRO PASO ALTO
%% ----- Filtro ideal

X = imread('triangulo.bmp');
F = fft2(double(X));

% -- Filtro ideal de 100
H_Ideal_100 = lpfilter('ideal', 256, 256, 100);
Filtrada_freq_Ideal_100 = (1 - H_Ideal_100).*F;
FPA_Ideal = real(ifft2(Filtrada_freq_Ideal_100));
% -- Modulo y fase
FFT_I_modulo = abs(Filtrada_freq_Ideal_100);
FFT_I_fase = angle(Filtrada_freq_Ideal_100);

figure,
subplot(2,3,1), imshow(FPA_Ideal, []), title('Filtro Paso alto ideal 100')
subplot(2,3,2), imshow(FFT_I_modulo, []), title('Modulo de la FFT')
subplot(2,3,3), imshow(FFT_I_fase, []), title('Fase de la FFT')
subplot(2,3,4), mesh(FPA_Ideal)
subplot(2,3,5), mesh(FFT_I_modulo)
subplot(2,3,6), mesh(FFT_I_fase)

% -- Filtro ideal sin lpfilter

%% ----- Filtro Gaussiano

X = imread('triangulo.bmp');
F = fft2(double(X));

% -- Filtro gaussiano de 100
H_Gaussian_100 = lpfilter('gaussian', 256, 256, 100);
Filtrada_freq_Gaussian_100 = (1 - H_Gaussian_100).*F;
FPA_Gaussian = real(ifft2(Filtrada_freq_Gaussian_100));
% -- Modulo y fase
FFT_G_modulo = abs(Filtrada_freq_Gaussian_100);
FFT_G_fase = angle(Filtrada_freq_Gaussian_100);

figure,
subplot(2,3,1), imshow(FPA_Gaussian, []), title('Filtro Paso alto gaussiano 100')
subplot(2,3,2), imshow(FFT_G_modulo, []), title('Modulo de la FFT')
subplot(2,3,3), imshow(FFT_G_fase, []), title('Fase de la FFT')
subplot(2,3,4), mesh(FPA_Gaussian)
subplot(2,3,5), mesh(FFT_G_modulo)
subplot(2,3,6), mesh(FFT_G_fase)

% ----- Filtros
figure,
subplot(2,2,1), imshow(FPA_Ideal, []), title('Filtro Paso alto ideal 100')
subplot(2,2,2), mesh(FPA_Ideal)
subplot(2,2,3), imshow(FPA_Gaussian, []), title('Filtro Paso alto gaussiano 100')
subplot(2,2,4), mesh(FPA_Gaussian)

% ----- Comparativa de filtros
figure,
subplot(2,3,1), imshow(FPA_Ideal, []), title('Filtro Paso alto ideal 100')
subplot(2,3,2), mesh(FFT_I_modulo), title('Modulo de la FFT - FPA.Ideal 100')
subplot(2,3,3), mesh(FFT_I_fase), title('Fase de la FFT - FPA.Ideal 100')
subplot(2,3,4), imshow(FPA_Gaussian, []), title('Filtro Paso alto gaussiano 100')
subplot(2,3,5), mesh(FFT_G_modulo), title('Modulo de la FFT - FPA.Gaussiano 100')
subplot(2,3,6), mesh(FFT_G_fase), title('Fase de la FFT - FPA.Gaussiano 100')
