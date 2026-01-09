 %ruta="C:\Users\super\OneDrive\upiita\animales\db\Leon\5.jpg";

w1=[1.4888   -2.1587    0.3826   -0.0044   -1.2958    0.6595   -0.8981
    0.0146    4.1854    1.1564    3.1415   -3.3311    1.5878    1.3722
    2.3370  -16.6763   -3.3463    3.1911    0.3874    8.1721    0.9652
   -0.5400   -5.0188   -1.4975   -3.1850    3.9454   -1.9890   -1.6178
   -0.3622    2.3264   -1.9421    7.2978    0.1126    2.0187   -2.6212
    2.8195   -0.8279   -1.2141   -1.9998   -2.7153   -4.1399    4.6044
    3.9507    1.6249   -2.8251   -4.6105   -0.1231    2.8745    0.4331
   -1.9063    4.1817   -1.2105   -9.0702    6.7897   -1.0268   -0.9377
    1.1670    2.7256    6.5179    3.6821   -4.1761    3.9151   -2.4885
    0.6214   -0.8444   -4.1525    1.8962   -0.5172    0.4787    1.7310
    ];
w21=[3.4026   -0.0328    2.3677
   -6.3540    3.6342    0.5462
   11.4627    4.6041  -12.8068
    4.3077   -3.9227   -1.5781
   -1.3058   -7.5467    6.1096
   -1.0294   -7.5940    7.0074
   -0.8115    4.7496   -7.9349
  -11.0356    8.8942   -7.2314
   -6.6447   -5.3518    5.7123
   -4.1354   -1.4777    5.8302
  ];
w2=w21';
b1=[-1.9930
    1.1349
   -3.9340
   -1.8173
   -2.6297
    1.2495
   -2.6019
   -3.6000
    0.7698
   -0.3533];

b2=[-4.2913
    2.4110
   -1.3064
    ];
mu=[0.2024
    0.0610
    2.9413
    0.6831
    0.0959
   15.3537
    0.5281];
sigma=[0.3181
    0.0762
    0.0718
    0.1397
    0.0737
    8.4366
    0.2386
    ];

I = imread(ruta);
Igray = rgb2gray(I);
Ibin = imbinarize(Igray);

Ihsv = rgb2hsv(I);
pixelsHSV = reshape(Ihsv(repmat(Ibin,[1 1 3])),[],3);

Hmean = mean(pixelsHSV(:,1));
Smean = mean(pixelsHSV(:,2));
Vmean = mean(pixelsHSV(:,3));

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
clase