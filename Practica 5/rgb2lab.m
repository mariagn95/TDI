function [lab,l,a,b] = rgb2lab(rgb)

% Asignamos variables.
rgb = im2double(rgb);
r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);

% Realizamos la transformación a CIE XYZ.
[xyz,x,y,z] = rgb2xyz(rgb);

% Inicializamos las variables
l = zeros(size(r));
a = zeros(size(g));
b = zeros(size(b));

% Definimos los valores triestímulos de referencia.
x0 = 0.4887180 + 0.3106803 + 0.2006017;
y0 = 0.1762044 + 0.8129847 + 0.0108109;
z0 = 0.0000000 + 0.0102048 + 0.9897952;

% Normalizamos los valores triestimulos.
xn = x/x0;
yn = y/y0;
zn = z/z0;

% Calculamos los sectores.
id1 = (xn > (6/29)^3);
id2 = (xn <= (6/29)^3);
id3 = (xn > (6/29)^3) & (yn > (6/29)^3);
id4 = (xn > (6/29)^3) & (yn <= (6/29)^3);
id5 = (xn <= (6/29)^3) & (yn > (6/29)^3);
id6 = (xn <= (6/29)^3) & (yn <= (6/29)^3);
id7 = (yn > (6/29)^3) & (zn > (6/29)^3);
id8 = (yn > (6/29)^3) & (zn <= (6/29)^3);
id9 = (yn <= (6/29)^3) & (zn > (6/29)^3);
id10 = (yn <= (6/29)^3) & (zn <= (6/29)^3);

% Definimos constantes.
t0a = (1/3)*((29/6)^2);
t0b = 4/29;

% Calculamos la componente l.
l(id1) = 116*(yn(id1).^(1/3))-16;
l(id2) = 116*(t0a*yn(id2)+t0b)-16;

% Calculamos la componente a.
a(id3) = 500*(xn(id3).^(1/3)-yn(id3).^(1/3));
a(id4) = 500*(xn(id4).^(1/3)-(t0a*yn(id4)+t0b));
a(id5) = 500*((t0a*xn(id5)+t0b)-yn(id5).^(1/3));
a(id6) = 500*((t0a*xn(id6)+t0b)-(t0a*yn(id6)+t0b));

% Calculamos la componente b.
b(id7) = 200*(yn(id7).^(1/3)-zn(id7).^(1/3));
b(id8) = 200*(yn(id8).^(1/3)-(t0a*zn(id8)+t0b));
b(id9) = 200*((t0a*yn(id9)+t0b)-zn(id9).^(1/3));
b(id10) = 200*((t0a*yn(id10)+t0b)-(t0a*zn(id10)+t0b));

% Resultado final.
lab(:,:,1) = l;
lab(:,:,2) = a;
lab(:,:,3) = b;
