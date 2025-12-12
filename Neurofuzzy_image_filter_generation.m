clear; clc, close all;

carpeta = 'C:\Users\super\Downloads\Nueva carpeta (8)\archive\IC';

carpeta_out = fullfile(carpeta, 'filtradas');
if ~exist(carpeta_out, 'dir')
    mkdir(carpeta_out);
end

for k = 1:392
    nombre="filt_"+k+".jpg";
    ruta_img = fullfile(carpeta + "\"+k+".jpg");
    I = imread(ruta_img);
    I=imadjust(I,[.5 .5 0; 1 1 1],[]);
    Igray = rgb2gray(I);
    Ibin=imbinarize(Igray);
    se = strel("line",5,4);
    Ibin=imdilate(~Ibin,se);
    Ibin=~Ibin;
    imwrite(Ibin, fullfile(carpeta_out, nombre));

end