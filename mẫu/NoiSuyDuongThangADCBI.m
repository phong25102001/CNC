xA = 20; yA = 30; %Toa do diem A
xB = 50; yB = 90; %Toa do diem B
x0 = xA; y0 = yA;
L = sqrt((xB - xA)^2 + (yB - yA)^2); %Chieu dai quang duong
A = 20; %Gia toc tang
D = 20; %Gia toc giam
Vmax = 30; %van toc toi da
Vs = 0; %Van toc khoi dong
Ve = 0; %Van toc ket thuc
Tacc = Vmax/A; %Thoi gian tang toc
Tdec = Vmax/D; %Thoi gian giam toc
Tipo = 0.005; %Chu ki noi suy tho
Tdk = 0.001; %Chu ki dieu khien

% Xay dung profile tocdo
Na= floor(Tacc/Tipo);
a1 = (Vmax - Vs)/(Na*Tipo);     %gia toc tang toc
Nd = floor(Tdec/Tipo);
a3 = (Ve - Vmax)/(Nd*Tipo);     %gia toc giam toc

if (L -((Vmax^2 - Vs^2)/(2*a1))-((Ve^2 - Vmax^2)/(2*a3)))/Vmax > 0
    Tconst = ((L -((Vmax*Vmax - Vs*Vs)/(2*a1))-((Ve*Ve - Vmax*Vmax)/(2*a3)))/Vmax); %thoi gian toc do khong doi
    Nc = floor(Tconst/Tipo);
    V = [0 0];
    for i =1:(Na + Nd + Nc-1)
        if (i <= Na)
            V(i+1) = V(i) + a1*Tipo;
        elseif (Na < i && i <= (Na+Nc))
            V(i+1) = V(i);
        else
            V(i+1) = V(i) + a3*Tipo;
        end
    end
else
    Vmax = sqrt((2*L*a1*a3)/(a3 - a1));
    Na = Vmax/(a1*Tipo);
    Nd = Vmax/(a3*Tipo);
    Nc = 0;
    V = [0 1];
    for i = 1:(Na+Nd-1)
        if ( i <= Na)
            V(i+1) = V(i) + a1*Tipo;
        else
            V(i+1) = V(i) + a3*Tipo;
        end
    end
end
N = Na+Nc+Nd-1;
t1 = [0 1];
for i = 1:N
    t1(i+1) = t1(i)+ Tipo;
end

% noi suy vi tri truc X
X_dodichchuyen = [0 1];
X_tho = [xA 1];
deltaX = [Tipo*V(2)*(xB-xA)/(2*L) 1]; % dentaX
Xstart = xA;
Xend = xB;
for i = 1:N
    deltaX(i+1) = Tipo*(V(i+1)+V(i))*(xB-xA)/(2*L);
    X_dodichchuyen(i+1) = X_dodichchuyen(i)+ deltaX(i);
    X_tho(i+1) = X_tho(i) + deltaX(i);
end

% noi suy vi tri truc Y
Y_dodichchuyen = [0 1];
Y_tho = [yA 1];
deltaY = [Tipo*V(2)*(yB-yA)/(2*L) 1]; % dentaY
Ystart = yA;
Yend = yB;
for i = 1:N
    deltaY(i+1) = (Tipo*(V(i+1)+V(i))/2)*(yB-yA)/L;
    Y_dodichchuyen(i+1) = Y_dodichchuyen(i) + deltaY(i);
    Y_tho(i+1) = Y_tho(i) + deltaY(i);
end

% thoi gian
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
        X2(i+1,j) = deltaX(i)/k; % gia tri do dich chuyen tuyen tinh
        Y2(i+1,j) = deltaY(i)/k;
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

figure(1);
stairs(t1,V,'linewidth',2);
title('Do thi van toc');
grid on;
xlabel('thoi gian (s)');
ylabel('Van toc (m/s^2)');
legend('van toc');

figure(2)
subplot(1,2,1);
plot(t1,X_dodichchuyen);
title('Tong do dich chuyen theo truc x');
xlabel('thoi gian(s)');
ylabel('quang duong(mm)');
grid on;
subplot(1,2,2)
plot(t1,Y_dodichchuyen); % stairs
title('Tong do dich chuyen theo truc y');
xlabel('thoi gian(s)');
ylabel('quang duong(mm)');
grid on;

figure(3)
plot(X_tho,Y_tho, 'r');
hold on;
title('quy dao duong thang');
xlabel('trucx (mm)');
ylabel('trucy (mm)');
axis([(min(xA,xB)-10) (max(xA,xB)+10) (min(yA,yB)-10) (max(yA,yB)+10)]);
plot(xA,yA,'b o',xB,yB,'b o');
hold on

% % do thi tho
figure(4)
bar(t1, deltaX, 0.4);
xlabel('Time(s)');
ylabel('dentaX(mm)');
title('do dich chuyen truc X theo noi suy tho');
% axis([0.30 0.32 0 0.016]);

figure(5)
bar(t1, deltaY, 0.4);
xlabel('Time(s)');
ylabel('dentaY(mm)');
title('do dich chuyen truc Y theo noi suy tho');
% axis([0.30 0.32 0 0.03]);

figure(6)
bar(t2,CX);
xlabel('Time(s)');
ylabel('delta x(mm)');
title('do dich chuyen truc x theo noi suy tinh tuyen tinh');
axis([0.30 0.32 0 0.004]);

figure(7)
bar(t2,CY);
xlabel('Time(s)');
ylabel('delta y(mm)');
title('do dich chuyen truc y theo noi suy tinh tuyen tinh');
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

figure(9)
bar(t2,bX2);
title('do dich chuyen truc x theo phuong phap trung binh');
xlabel('thoi gian (s)')
ylabel('delta x (mm)')
axis([0.30 0.32 0 0.004]);

figure(10)
bar(t2,bY2)
title('do dich chuyen truc y theo phuong phap trung binh');
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

figure(11)
plot(X_tinh,Y_tinh,'r');
xlabel('truc x (mm)');
ylabel('truc  y (mm)');
title('do thi quy dao sau khi noi suy tinh');
axis([0 60 0 100]);
hold on
% plot(out.trucx.signals.values, out.trucy.signals.values,'--b');
% legend('Quy dao dat','Quy dao phan hoi');
% grid on

figure(12)
stairs(X_tinh,Y_tinh,'b-');
hold on
stairs(X_tho,Y_tho,'r-');
title(' Quy dao dat theo noi suy tho va noi suy tinh trung binh');
xlabel('truc x (mm)');
ylabel('truc y (mm)');

figure(13)
subplot(1,2,1);
plot(t2,X_tinh);
title('Luong dat dau vao truc x');
xlabel(' Thoi gian (s)');
ylabel(' Vi tri (mm)');
subplot(1,2,2);
plot(t2,Y_tinh);
title('Luong dat dau vao truc y');
xlabel(' Thoi gian (s)');
ylabel(' Vi tri (mm)');

figure(14)
stairs(X_tho,Y_tho,'r-');
hold on
stairs(X_tinh,Y_tinh,'b-');
title(' so sanh noi suy tho va noi suy tinh');
xlabel('truc x (mm)');
ylabel('truc y (mm)');
legend('Noi suy tho','Noi suy tinh');
grid on

XY_tinh.time = [];
sum = [X_tinh;Y_tinh]';
XY_tinh.signals.values = sum;
XY_tinh.signals.dimensions = 2;
