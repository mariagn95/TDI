function [xyz,x,y,z] = rgb2xyz(rgb)

% Asignamos variables.
rgb = im2double(rgb);
r = rgb(:,:,1);
g = rgb(:,:,2);
b = rgb(:,:,3);

% Calculamos la componente x.
x = 0.4887180*r + 0.3106803*g + 0.2006017*b;

% Calculamos la componente y.
y = 0.1762044*r + 0.8129847*g + 0.0108109*b;

% Calculamos la componente z.
z = 0.0000000*r + 0.0102048*g + 0.9897952*b;

% Resultado final.
xyz(:,:,1) = x;
xyz(:,:,2) = y;
xyz(:,:,3) = z;

