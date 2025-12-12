clear; clc, close all;

carpeta = 'C:\Users\HP\Downloads\Nueva carpeta (8)\archive\Capacitor\filtradas';

for k = 1:100
    nombre="filt_"+k+".jpg";
    ruta_img = fullfile(carpeta + "\filt_"+k+".jpg");
    I = imread(ruta_img);
    edges = edge(I, 'Canny');
    CC = bwconncomp(edges);
    numPixels = cellfun(@numel, CC.PixelIdxList);
    [~, idx] = max(numPixels);
    mainBorder = false(size(edges)); 
    mainBorder(CC.PixelIdxList{idx}) = true;
    IM=mainBorder;
    BW = double(IM);
    [y, x] = find(BW);
    m00 = length(x);
    m10 = sum(x);
    m01 = sum(y);
    
    xc = m10 / m00;
    yc = m01 / m00;

    mu20 = sum( (x - xc).^2 );
    mu02 = sum( (y - yc).^2 );
    mu11 = sum( (x - xc).*(y - yc) );
    
    mu30 = sum( (x - xc).^3 );
    mu03 = sum( (y - yc).^3 );
    mu12 = sum( (x - xc).*(y - yc).^2 );
    mu21 = sum( (x - xc).^2.*(y - yc) );

    eta20 = mu20 / m00^2;
    eta02 = mu02 / m00^2;
    eta11 = mu11 / m00^2;
    
    eta30 = mu30 / m00^(2.5);
    eta03 = mu03 / m00^(2.5);
    eta12 = mu12 / m00^(2.5);
    eta21 = mu21 / m00^(2.5);

    Hu = zeros(7,1);
    Hu(1) = eta20 + eta02;
    Hu(2) = (eta20 - eta02)^2 + 4*eta11^2;
    Hu(3) = (eta30 - 3*eta12)^2 + (3*eta21 - eta03)^2;
    Hu(4) = (eta30 + eta12)^2 + (eta21 + eta03)^2;
    Hu(5) = (eta30 - 3*eta12)*(eta30 + eta12)*( (eta30 + eta12)^2 - 3*(eta21 + eta03)^2 ) ...
         + (3*eta21 - eta03)*(eta21 + eta03)*( 3*(eta30 + eta12)^2 - (eta21 + eta03)^2 );
    Hu(6) = (eta20 - eta02)*( (eta30 + eta12)^2 - (eta21 + eta03)^2 ) ...
       + 4*eta11*(eta30 + eta12)*(eta21 + eta03);
    Hu(7) = (3*eta21 - eta03)*(eta30 + eta12)*( (eta30 + eta12)^2 - 3*(eta21 + eta03)^2 ) ...
         - (eta30 - 3*eta12)*(eta21 + eta03)*( 3*(eta30 + eta12)^2 - (eta21 + eta03)^2 );
    Huu(:,k)=Hu;
end
writematrix(Huu, 'C:\Users\HP\Downloads\CapacitorHu.txt');