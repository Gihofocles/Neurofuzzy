clear;clc;close all

carpetas(1) = "C:\Users\super\OneDrive\upiita\animales\Pantera";
carpetas(2) = "C:\Users\super\OneDrive\upiita\animales\Osos";
carpetas(3) = "C:\Users\super\OneDrive\upiita\animales\Leon";

for i = 1:3
    carpeta = carpetas(i);
    for k = 1:24
        ruta = carpeta + "\" + num2str(k) + ".jpg";
        I = imread(ruta);
        Igray = rgb2gray(I);
        Ibin = imbinarize(Igray);
        Ihsv = rgb2hsv(I);
        pixelsHSV = reshape(Ihsv(repmat(Ibin,[1 1 3])),[],3);
        Hmean = mean(pixelsHSV(:,1))*3;
        Smean = mean(pixelsHSV(:,2))*3;
        Vmean = mean(pixelsHSV(:,3))*3;
        Iu(:,k) = [Hmean; Smean; Vmean];
        area = sum(Ibin(:));
        Au(:,k) = area / numel(Ibin);
        per = sum(bwperim(Ibin),'all');
        Pu(:,k) = per / sqrt(area);
        Cu(:,k) = 4*pi*area/(per^2);
        stats = regionprops(Ibin,'Area','Eccentricity');
        [~,idx] = max([stats.Area]);
        Ec(:,k) = stats(idx).Eccentricity;
    end
    It{i} = Iu;
    At{i} = Au;
    Ct{i} = Cu;
    Pt{i} = Pu;
    Et{i} = Ec;
end

P_pantera = [It{1}; At{1}; Ct{1}; Pt{1}; Et{1}];
P_osos    = [It{2}; At{2}; Ct{2}; Pt{2}; Et{2}];
P_leon    = [It{3}; At{3}; Ct{3}; Pt{3}; Et{3}];

P = [P_pantera P_osos P_leon];

mu = mean(P,2);
sigma = std(P,0,2) + 1e-6;
P = (P - mu) ./ sigma;

T_pantera = repmat([1;0;0],1,size(P_pantera,2));
T_osos    = repmat([0;1;0],1,size(P_osos,2));
T_leon    = repmat([0;0;1],1,size(P_leon,2));
T = [T_pantera T_osos T_leon];

rep = 3;
P = repmat(P,1,rep);
T = repmat(T,1,rep);

R = size(P,1);
s1 = 10;
s2 = 3;

w1 = rand(s1,R) - 0.5;
b1 = rand(s1,1) - 0.5;
w2 = rand(s2,s1) - 0.5;
b2 = rand(s2,1) - 0.5;

epochs = 2e3;
alpha = .05;

for ep = 1:epochs
    err = 0;
    for j = 1:size(P,2)
        p = P(:,j);
        t = T(:,j);
        a1 = logsig(w1*p + b1);
        a2 = logsig(w2*a1 + b2);
        e = t - a2;
        err = err + sum(e.^2);
        s2n = -2 * e .* a2 .* (1 - a2);
        s1n = (w2' * s2n) .* a1 .* (1 - a1);
        w2 = w2 - alpha * s2n * a1';
        b2 = b2 - alpha * s2n;
        w1 = w1 - alpha * s1n * p';
        b1 = b1 - alpha * s1n;
    end
    [ep/1000 err]
end

ruta_test = "C:\Users\super\OneDrive\upiita\animales\db\prueba\2.jpg";

I = imread(ruta_test);
Igray = rgb2gray(I);
Ibin = imbinarize(Igray);
Ihsv = rgb2hsv(I);
pixelsHSV = reshape(Ihsv(repmat(Ibin,[1 1 3])),[],3);
Hmean = mean(pixelsHSV(:,1))*3;
Smean = mean(pixelsHSV(:,2))*3;
Vmean = mean(pixelsHSV(:,3))*3;
area = sum(Ibin(:));
areaNorm = area / numel(Ibin);
per = sum(bwperim(Ibin),'all');
perNorm = per / sqrt(area);
circularidad = 4*pi*area/(per^2);
stats = regionprops(Ibin,'Area','Eccentricity');
[~,idx] = max([stats.Area]);
ecc = stats(idx).Eccentricity;

Pt_test = [Hmean; Smean; Vmean; areaNorm; circularidad; perNorm; ecc];
Pt_test = (Pt_test - mu) ./ sigma;

a1 = logsig(w1*Pt_test + b1);
a2 = logsig(w2*a1 + b2);
[~,clase] = max(a2);

if clase == 1
    disp("pantera")
elseif clase == 2
    disp("oso")
elseif clase == 3
    disp("leon")
end
a2
