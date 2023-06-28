Tipo = 0.005;           % chu ky noi suy tho
Tdk = 0.001;            %chu ky noi suy tinh
F = 20;                 %van toc dai toi da
A = 20;                 %gia toc tang toc
D = 20;                 %gia toc giam toc
Wstart = 0;
Wend = 0;
xA = 30;                
yA = 0;
Xstart = 0;
Ystart = 0;
Xcenter = 15;
Ycenter = 0;
C = 1; %thuan chieu kim dong ho  = 1; nguoc chieu kim dong ho = 0;
R = sqrt((Xcenter - Xstart)^2 + (Ycenter - Ystart)^2);    %tinh ban kinh duong tron
Wmax = F/R;
At = A/R;               %gia toc goc tang toc
Dt = D/R;               %gia toc goc giam toc
theta0 = acos((Xstart-Xcenter)/R);      %tinh goc ban dau
theta = 180;                            %goc noi suy
L = 2*R;                                % do dai quang duong
TA = Wmax/At;                           % thoi gian tang toc
TD = Wmax/Dt;                           %thoi gian giam toc
Nac = floor(TA/Tipo);                   %so lan noi suy tang toc
a1 = (Wmax - Wstart)/(Nac*Tipo);        %gia toc goc tang toc
Ndc = floor(TD/Tipo);                   %so lan noi suy giam toc
a3 = (Wend - Wmax)/(Ndc*Tipo);          %gia toc goc giam toc
%tinh thoi gian toc do khong doi
Tconst = (theta*pi/180 - (Wmax*Wmax-Wend*Wend)/(2*a1)-(Wend*Wend-Wmax*Wmax)/(2*a3))/Wmax;
Ncc = floor(Tconst/Tipo);               %so lan noi suy toc do khong doi
W = [0 1];
N = Nac + Ndc + Ncc;

%tinh van toc
for i = 1:N-1
    if (i <= Nac)
        W(i+1) = W(i) + a1*Tipo;
    elseif (i> Nac) && (i <= (Nac +  Ncc))
        W(i+1) = W(i);
    else
        W(i+1) = W(i) + Tipo*a3;
    end
end
t1 = [0 1];
for i = 1:N-1
    t1(i+1) = t1(i) + Tipo;
end

% ve do thi van toc
figure(1)
plot(t1,W);
title('Do thi van toc theo thoi gian');
xlabel('thoi gian (s)');
ylabel('van toc goc (rad/s)');
grid on

alpha = [Tipo*W(2)/2 1];
Gocnoisuy = [theta0 1];
X_tho = [Xstart 1];
Y_tho = [Ystart 1];
for i = 1:N-1
    alpha(i+1) = Tipo*(W(i) + W(i+1))/2; %%sua doan nay
    if (C==1)
        Gocnoisuy(i+1) = Gocnoisuy(i) - alpha(i);
    else 
        Gocnoisuy(i+1) = Gocnoisuy(i) + alpha(i);
    end
end
deltaX_tho = [R*cos(Gocnoisuy(2)) - R*cos(Gocnoisuy(1)) 1];     %do dich chuyen truc x
deltaY_tho = [R*sin(Gocnoisuy(2)) - R*sin(Gocnoisuy(1)) 1];     %do dich chuyen truc y  
for i = 1:N-1
    deltaX_tho(i+1) = R*cos(Gocnoisuy(i+1)) - R*cos(Gocnoisuy(i));
    deltaY_tho(i+1) = R*sin(Gocnoisuy(i+1)) - R*sin(Gocnoisuy(i));
    X_tho(i+1) = Xcenter + R*cos(Gocnoisuy(i+1));
    Y_tho(i+1) = Ycenter + R*sin(Gocnoisuy(i+1));
end

figure(2)
plot(t1,Gocnoisuy/pi*180);
title('do thay doi goc noi suy');
xlabel('thoi gian');
ylabel('goc noi suy');
grid on

figure(3)
plot(X_tho,Y_tho,'r');
hold on
title('quy dao duong tron');
xlabel('truc x (mm)');
ylabel('truc y (mm)');

figure(4)
subplot(1,2,1);
bar(t1,deltaX_tho);
title('Do dich chuyen truc x');
xlabel('thoi gian');
ylabel('delta x (mm)');
subplot(1,2,2);
bar(t1,deltaY_tho);
title('Do dich chuyen truc y');
xlabel('thoi gian');
ylabel('delta y (mm)');

figure(6)
bar(t1,deltaX_tho,0.4);
xlabel('thoi gian (s)');
ylabel('delta x (mm)');
title('do dich chuyen truc x sau khi noi suy tho');
axis([1 1.02 0 0.1]);

figure(7)
bar(t1,deltaY_tho,0.4);
xlabel('thoi gian (s)');
ylabel('delta y (mm)');
title('do dich chuyen truc y sau khi noi suy tho');
axis([0.5 0.52 0 0.06]);

% Noi suy tinh
k = Tipo/Tdk;
t2 = [0 1];
for i = 1:(N*5-1)
    t2(i+1) = t2(i) + Tdk;
end


% %tinh noi suy tinh
X2 = [0 0];
Y2 = [0 0];
deltaX_tho = [X_tho(2) - X_tho(1) 1];
deltaY_tho = [Y_tho(2) - Y_tho(1) 1];
for i = 1:N-1
    deltaX_tho(i) = X_tho(i+1) - X_tho(i);
    deltaY_tho(i) = Y_tho(i+1) - Y_tho(i);
    for j =1:k
        X2(i+1,j) = deltaX_tho(i)/k;    %o day X2 va Y2 dang la ma tran nhieu hang nhieu cot
        Y2(i+1,j) = deltaY_tho(i)/k;    %nen ko ve do thi voi t2 duoc
    end
end

% %gia tri noi suy sau tuyen tinh
CX = zeros(1,N*k);
CY = zeros(1,N*k);
for i=1:N
    for j = 1:k
        j1 = (i-1)*k + j;           %muc dich la muon chuyen ma tran nhieu hang thanh ma tran 1 hang
        CX(j1) = CX(j1) + X2(i,j);  % voi j1 tang dan tu 1,2,3,4,5,6,7,...
        CY(j1) = CY(j1) + Y2(i,j);
    end
end

figure(8)
bar(t2,CX);
xlabel('thoi gian (s)');
ylabel('delta x (mm)');
title('do dich chuyen truc x theo phuong phap tuyen tinh');
axis([1 1.02 0 0.02]);

figure(9)
bar(t2,CY);
xlabel('thoi gian (s)');
ylabel('delta y (mm)');
title('do dich chuyen truc y theo phuong phap tuyen tinh');
axis([0.5 0.52 0 0.012]);

%%Phuong phap trung binh
%% truc x
bX = [0 0];
bX1 = [0 0];
bX2 = [0 0];
bX(1) = (CX(1) + CX(2) + CX(3))/k;
bX(2) = (CX(1) + CX(2) + CX(3) + CX(4))/k;
for i = 3:N*k - 2
    bX(i) = (CX(i+2) + CX(i+1) + CX(i) + CX(i-1) + CX(i-2))/k;
end
bX(N*k-1) =  (CX(N*k) + CX(N*k-1) + CX(N*k-2) + CX(N*k-3))/k;
bX(N*k) =  (CX(N*k) + CX(N*k-1) + CX(N*k-2))/k;

bX1(1) = (CX(1) + CX(2) + CX(3) + CX(4))/k;
for i=2:N*k-3
    bX1(i) = (CX(i+3) + CX(i+2) + CX(i+1) + CX(i) + CX(i-1))/k;
end
bX1(N*k-2) = (CX(N*k) + CX(N*k-1) + CX(N*k-2) + CX(N*k-3))/k;
bX1(N*k-1) = (CX(N*k) + CX(N*k-1) + CX(N*k-2))/k;
bX1(N*k) = (CX(N*k) + CX(N*k-1))/k;

for i=1:N*k
    bX2(i) = (bX(i) + bX1(i))/2;
end

%%truc y
bY = [0 0];
bY1 = [0 0];
bY2 = [0 0];
bY(1) = (CY(1) + CY(2) + CY(3))/k;
bY(2) = (CY(1) + CY(2) + CY(3) + CY(4))/k;
for i = 3:N*k - 2
    bY(i) = (CY(i+2) + CY(i+1) + CY(i) + CY(i-1) + CY(i-2))/k;
end
bY(N*k-1) =  (CY(N*k) + CY(N*k-1) + CY(N*k-2) + CY(N*k-3))/k;
bY(N*k) =  (CY(N*k) + CY(N*k-1) + CY(N*k-2))/k;

bY1(1) = (CY(1) + CY(2) + CY(3) + CY(4))/k;
for i=2:N*k-3
    bY1(i) = (CY(i+3) + CY(i+2) + CY(i+1) + CY(i) + CY(i-1))/k;
end
bY1(N*k-2) = (CY(N*k) + CY(N*k-1) + CY(N*k-2) + CY(N*k-3))/k;
bY1(N*k-1) = (CY(N*k) + CY(N*k-1) + CY(N*k-2))/k;
bY1(N*k) = (CY(N*k) + CY(N*k-1))/k;

for i=1:N*k
    bY2(i) = (bY(i) + bY1(i))/2;
end

figure(10)
bar(t2,bX2);
title('do dich chuyen truc x theo phuong phap trung binh');
xlabel('thoi gian (s)')
ylabel('delta x (mm)')
axis([1 1.02 0 0.02]);

figure(11)
bar(t2,bY2)
title('do dich chuyen truc y theo phuong phap trung binh');
xlabel('thoi gian (s)')
ylabel('delta y (mm)')
axis([0.5 0.52 0 0.012]);
    
%%noi suy tinh theo pp trung binh
X_tinh = [0 X_tho(1)];
Y_tinh = [0 Y_tho(1)];
for i = 1:(N*k-1)
    X_tinh(i+1) = X_tinh(i) + bX2(i);
    Y_tinh(i+1) = Y_tinh(i) + bY2(i);
end

figure(12)
plot(X_tinh,Y_tinh,'r');
xlabel('truc x (mm)');
ylabel('truc y (mm)');
title(' quy dao duong tron sau khi noi suy tinh');
% hold on
% plot(out.trucx.signals.values, out.trucy.signals.values,'--b');
% legend('Quy dao dat','Quy dao phan hoi');
% grid on

figure(13)
stairs(X_tho,Y_tho,'r-');
hold on
stairs(X_tinh,Y_tinh,'b-');
title(' so sanh noi suy tho va noi suy tinh');
xlabel('truc x (mm)');
ylabel('truc y (mm)');
legend('Noi suy tho','Noi suy tinh');
grid on

figure(14)
subplot(1,2,1);
plot(t2,X_tinh);
title('quy dao dat truc x');
xlabel('thoi gian (s)');
ylabel('vi tri (mm)');
subplot(1,2,2);
plot(t2,Y_tinh);
title('quy dao dat truc y');
xlabel('thoi gian (s)');
ylabel('vi tri (mm)');

XY_tinh.time = [];
sum = [X_tinh;Y_tinh]';
XY_tinh.signals.values = sum;
XY_tinh.signals.dimensions = 2;

% XY_tho.time = [];
% sum1 = [X_tho;Y_tho]';
% XY_tho.signals.values = sum1;
% XY_tho.signals.dimensions = 2;

