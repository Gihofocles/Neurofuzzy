clc; clear, close all;

A = readmatrix('C:\Users\HP\Downloads\TransistorHu.txt');
B = readmatrix('C:\Users\HP\Downloads\IcHu.txt');
C = readmatrix('C:\Users\HP\Downloads\ResistorHu.txt');
D = readmatrix('C:\Users\HP\Downloads\CapacitorHu.txt');

A = A(3:5,:);
C1 = C(3:5,:);
D1 = D(3:5,:);


P = [A   C1   D1];

P = normalize(P, 2);


% transistor = 0
% resistor   = 1
% capacitor  = 2
TA = zeros(1, size(A,2));      % transistor
TC = ones(1, size(C1,2));      % resistor
TD = 2*ones(1, size(D1,2));    % capacitor

T = [TA TC TD];


epochs = 500e3;
alpha  = 0.05;

R = 3;
s1 = 20;
s2 = 1;

w1 = rand(s1, R) - 0.5;
b1 = rand(s1, 1) - 0.5;

w2 = rand(s2, s1) - 0.5;
b2 = rand(s2, 1) - 0.5;

for ep = 1:epochs
    E = 0;
    for j = 1:size(P,2)

        p = P(:,j);
        t = T(j);
        a1 = logsig(w1*p + b1);
        a2 = w2*a1 + b2;
        e = t - a2;
        E = E + e^2;
        s2n = -2*e;
        D1 = a1 .* (1 - a1);
        s1n = (w2' * s2n) .* D1;
        w2 = w2 - alpha * s2n * a1';
        b2 = b2 - alpha * s2n;

        w1 = w1 - alpha * s1n * p';
        b1 = b1 - alpha * s1n;
    end

    if mod(ep,1000)==0
         fprintf("Epoch %d - E: %.6f\n", ep, E);
        
    end
    if (E/size(P,2)) < 1e-4
        fprintf("Entrenamiento detenido por MSE bajo.\n");
        break
    end
end

%testing
n=50
fprintf("\n--- PRUEBAS ---\n");
test = P(:,n);
a1 = logsig(w1*test + b1);
a2 = w2*a1 + b2;
fprintf("Transistor → %.2f\n", a2);

test = P(:, size(A,2)+n);
a1 = logsig(w1*test + b1);
a2 = w2*a1 + b2;
fprintf("Resistor   → %.2f\n", a2);

test = P(:, size(A,2)+size(C1,2)+n);
a1 = logsig(w1*test + b1);
a2 = w2*a1 + b2;
fprintf("Capacitor  → %.2f\n", a2);



scatter3(C(1,:),C(2,:),C(3,:));hold on;
scatter3(A(1,:),A(2,:),A(3,:),'filled');
scatter3(D(1,:),D(2,:),D(3,:),'filled');
scatter3(C(1,:),C(2,:),C(3,:),'filled');


% w1 =
% 
%     0.1636   -2.1946   -2.2798
%     2.4651    1.0648    2.3169
%     0.3342   -2.2294   -2.0971
%  -466.7841  -80.0252 -151.2400
%     0.1996   -2.2022   -2.2414
%    -2.7725   -1.5342   -5.5530
%     5.1083    6.5219    7.0409
%   -44.3915   38.2280   -1.1147
%     0.5686   -2.2737   -1.8460
%   -47.6786   14.6641   -7.1610
%    15.5659  -58.9255   -9.4071
%    -5.5286   -0.2478   -8.0229
%     3.6176    3.5042    4.8176
%    -0.0743   -2.1654   -2.5588
%   -22.1157   12.9075  -14.6119
%    -0.1012    0.9561   -6.1700
%     1.0183   -2.3580   -1.3781
%   -13.8736    4.2911  -14.3425
%   -29.7729   39.8462   -8.2026
%  -222.4327  -60.8572  -52.6912

% w2 =
% 
%   Columns 1 through 19
% 
%     3.6142   -1.7587    3.5864   -2.6146    3.6103    3.9463   -1.5251   -8.0246    3.5271    0.7002   -8.5950    4.0409    2.7426    2.8122   -0.8219    0.0981    3.2948    4.4270    8.0515
% 
%   Column 20
% 
%     2.5319

% b1 =
% 
%    -8.2129
%    -2.4093
%    -8.1610
%  -320.9197
%    -8.2024
%    -9.3951
%   -10.3457
%   -30.2055
%    -8.0884
%   -21.6634
%   -37.9463
%   -10.1029
%    -6.0553
%    -8.0701
%    -2.6999
%    -7.0657
%    -7.9456
%    -8.5873
%   -17.8860
%  -175.9061
% 
% b2 =
% 
%     2.1236