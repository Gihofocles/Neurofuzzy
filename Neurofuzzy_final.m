clear; clc, close all;


carpetas(1) = "C:\Users\super\OneDrive\upiita\animales\Pantera";
carpetas(2) = "C:\Users\super\OneDrive\upiita\animales\Osos";
carpetas(3) = "C:\Users\super\OneDrive\upiita\animales\Leon";
% carpeta_out = fullfile(carpeta, 'filtradas');
% if ~exist(carpeta_out, 'dir')
%     mkdir(carpeta_out);
% end
for i=1:3
    carpeta=carpetas(i);
    for k=1:20;
        ruta=carpeta + "\" + num2str(k) + ".jpg";
        I = imread(ruta);
        Igray = rgb2gray(I);
        Ibin=imbinarize(Igray);
        pixels = reshape(I(repmat(~Ibin,[1 1 3])), [], 3);
        colorDom = mean(double(pixels));
        Iu(:,k)=mean(colorDom);
        area = sum(Ibin(:));
        areaNorm = area / numel(Ibin);
        Au(:,k)=areaNorm;
        per = sum(bwperim(Ibin),'all');
        perNorm = per / sqrt(area);
        Pu(:,k)=perNorm;
        circularidad = 4*pi*area / (per^2);
        Cu(:,k)=circularidad;
    end
    It(i,:)=Iu;  
    At(i,:)=Au;
    Ct(i,:)=Cu;
    Pt(i,:)=Pu;
end
Colores=It';
Areas=At';
Perimetros=Pt';
Circularidades = Ct';

figure;
% subplot(4,1,1);
% plot(Perimetros);
% title("Perimetros")
% legend("Panteras","Osos","Leones")
subplot(3,1,1);
plot(Colores)
title("Color representativo")
legend("Panteras","Osos","Leones")
subplot(3,1,2);
plot(Areas)
title("Areas")
legend("Panteras","Osos","Leones")
subplot(3,1,3);
plot(Circularidades)
title("Circularidad")
legend("Panteras","Osos","Leones")