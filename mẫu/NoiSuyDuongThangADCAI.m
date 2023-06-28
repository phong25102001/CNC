xA = 20; yA = 30; % diem dau
xB = 50; yB = 90; % diem cuoi
X0 = xA; Y0 = yA;
L = sqrt((yB-yA)^2+(xB-xA)^2);
A = 20; % gia toc tang toc cho phep
D = 20; % gia toc giam toc cho phep
Vmax = 30; % van toc lon nhat cho phep
Tipo = 0.005; % chu ki noi suy
Tdk = 0.001; % chu ki dieu khien
Tacc = Vmax/A;
Tdec = Vmax/D;
BLU = 0.02;
T = L/Vmax; 
n = floor(T/Tipo); %so chu ki noi suy
n1 = floor(Tacc/Tipo);%so chu ki bo loc so
PulseX = (xB-xA)/BLU/n;%quang duong di chuyen trong thoi gian noi suy
PulseY = (yB-yA)/BLU/n;
deltaX_tho =[0 0];
deltaY_tho =[0 0];
for i = 1:n
    deltaX_tho(i)= PulseX*BLU; % do dich chuyen truc X
    deltaY_tho(i)= PulseY*BLU; % do dich chuyen truc Y
end
% bo loc
for i = 1:n1
    h(i)= 1/n1;
end
% Tinh do dich chuyen tren moi truc
delta_X1=conv(deltaX_tho,h); %tinh tich chap
delta_Y1=conv(deltaY_tho,h);
X_dodichchuyen =[0 1];
Y_dodichchuyen =[0 1];
X_tho = [xA 1];
Y_tho = [yA 1];
N = (n+n1)-1;
for i= 1:N
    X_dodichchuyen(i+1)= X_dodichchuyen(i)+ delta_X1(i);
    Y_dodichchuyen(i+1)= Y_dodichchuyen(i)+ delta_Y1(i);
    X_tho(i+1) = X_tho(i) + delta_X1(i);
    Y_tho(i+1) = Y_tho(i) + delta_Y1(i);
end

% Ve do thi
figure(1)
subplot(1,2,1);
bar(deltaX_tho);
axis([0 500 0 0.07]);
title('Delta X - truoc bo loc');
grid on;
xlabel('So chu ki noi suy');
ylabel('Do dich chuyen');
subplot(1,2,2);
bar(delta_X1);
axis([0 800 0 0.07]);
title('Delta X sau khi qua bo loc');
grid on;
xlabel('So chu ki noi suy');
ylabel('Do dich chuyen');

figure(2)
subplot(1,2,1);
bar(deltaY_tho);
axis([0 500 0 0.14]);
title('Delta Y - truoc bo loc');
grid on;
xlabel('So chu ki noi suy');
ylabel('Do dich chuyen');
subplot(1,2,2);
bar(delta_Y1);
axis([0 800 0 0.14]);
title('Delta Y sau khi qua bo loc');
grid on;
xlabel('So chu ki noi suy');
ylabel('Do dich chuyen');

figure(3)
plot(X_tho,Y_tho, 'r');
hold on;
title('quy dao duong thang sau khi noi suy tho');
xlabel('trucx (mm)');
ylabel('trucy (mm)');
axis([(min(xA,xB)-10) (max(xA,xB)+10) (min(yA,yB)-10) (max(yA,yB)+10)]);
plot(xA,yA,'b o',xB,yB,'b o');
hold on
grid on;


t2 = [0 1];
for i = 1: (N*5-1)
    t2(i+1) = t2(i)+Tdk;
end
k = Tipo/Tdk;

%noi suy tinh
%do dich chuyen X,Y
X2 = [0 0];
Y2 = [0 0];
for i= 1:N
    for j = 1:k
        X2(i+1,j) = delta_X1(i)/k; % gia tri do dich chuyen tuyen tinh
        Y2(i+1,j) = delta_Y1(i)/k;
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

figure(4)
subplot(1,2,1);
bar(t2,CX);
xlabel('Time(s)');
ylabel('delta x(mm)');
title('Delta x theo noi suy tuyen tinh');
axis([0.30 0.32 0 0.004]);
subplot(1,2,2);
bar(t2,CY);
xlabel('Time(s)');
ylabel('delta y(mm)');
title('Delta y theo noi suy tuyen tinh');
axis([0.30 0.32 0 0.008]);

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

figure(5)
subplot(1,2,1);
bar(t2,bX2);
title('Delta x theo noi suy trung binh');
xlabel('thoi gian (s)')
ylabel('delta x (mm)')
axis([0.30 0.32 0 0.004]);
subplot(1,2,2)
bar(t2,bY2)
title('Delta y theo noi suy trung binh');
xlabel('thoi gian (s)')
ylabel('delta y (mm)')
axis([0.30 0.32 0 0.008]);

%%noi suy tinh theo pp trung binh
X_tinh = [xA 1];
Y_tinh = [yA 1];
for i = 1:(N*k-1)
    X_tinh(i+1) = X_tinh(i) + bX2(i);
    Y_tinh(i+1) = Y_tinh(i) + bY2(i);
end

figure(6)
plot(X_tinh,Y_tinh,'r');
xlabel('truc x');
ylabel('truc  y');
axis([0 60 0 100]);
title(' Quy dao duong thang sau khi noi suy tinh');
