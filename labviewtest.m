w1=[0.1921   -0.2446   -0.2456
    0.0275   -0.0660    0.2880
   -0.3377    0.1991   -0.2565
   -0.3813    0.3909    0.4293
   -0.0317    0.6015   -0.0983
    0.4597    0.0472   -0.3034
   -0.1501   -0.3612   -0.2489
   -0.0266   -0.2407    0.1561
   -0.2753   -0.2425   -0.0267
    0.2516    0.3407   -0.1483];
w2=[-0.1288    0.6289    0.2791    0.4340   -0.8690    0.3831   -0.0390   -0.7522   -0.1631   -0.0230];
b1=[0.3312
   -0.0063
    0.0497
    0.4172
   -0.0336
    0.2572
    0.2540
    0.0212
    0.0679
   -0.4241
];
b2= 0.6086;

I = imread(ruta);
Igray = rgb2gray(I);
Ibin = imbinarize(Igray);
pixels = reshape(I(repmat(~Ibin,[1 1 3])), [], 3);
colorDom = mean(double(pixels));
colorFeat = mean(colorDom);
area = sum(Ibin(:));
areaNorm = area / numel(Ibin);
per = sum(bwperim(Ibin),'all');
perNorm = per / sqrt(area);
circularidad = 4*pi*area / (per^2);
Pt_test = [colorFeat; areaNorm; circularidad];
a1 = logsig(w1 * Pt_test + b1);
a2 = w2 * a1 + b2;
if a2 < 0.7
    R=1;
elseif a2 >= 0.7 && a2 < 1.5
    R=2;
else
    R=3;
end