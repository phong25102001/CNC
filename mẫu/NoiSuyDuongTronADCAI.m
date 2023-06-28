xC = 0; yC = 0;
BLU = 0.05;
Xcenter = 20; Ycenter = 0;
Xstart = xC; Ystart = yC;
Tacc = 1; Tdec = 1;
Tipo = 0.005; % chu ki noi suy
Tdk = 0.001; % chu ki dieu khien
C = 0; % C = 1 noi suy nguoc chieu kim dong ho
% C = 0 noi suy thuan chieu kim dong ho
theta = pi; %goc noi suy
R = sqrt((Xstart-Xcenter)^2+(Ystart - Ycenter)^2); % ban kinh noi suy

if (yC-Ycenter) >=0
    theta0 = acos((Xstart-Xcenter)/R); % goc ban dau
else
    theta0 = 2*pi - acos((Xstart-Xcenter)/R);
end
alpha = BLU*2/(theta*R);
n = floor(theta/alpha)+1;
alpha = theta/n;
deltaX_tho = [0 1];
deltaY_tho = [0 1];
for i = 1:n
    if (C == 1)
        deltaX_tho(i) = R*cos(theta0 + alpha*i) - R*cos(theta0 + alpha*(i-1));

        deltaY_tho(i) = R*sin(theta0 + alpha*i) - R*sin(theta0 + alpha*(i-1));

    else
        deltaX_tho(i) = R*cos(theta0 - alpha*i) - R*cos(theta0 - alpha*(i-1));

        deltaY_tho(i) = R*sin(theta0 - alpha*i) - R*sin(theta0 - alpha*(i-1));

    end
end
n1 = floor(Tacc/Tipo);
for i= 1:n1
    h(i)= 1/n1;
end
delta_x1=conv(deltaX_tho,h);
delta_y1=conv(deltaY_tho,h);
X_dodichchuyen = [0 1];
Y_dodichchuyen = [0 1];
X_tho = [xC 1];
Y_tho = [yC 1];
N = n+n1-1;
for i= 1:N
    X_dodichchuyen(i+1)= X_dodichchuyen(i)+ delta_x1(i);
    Y_dodichchuyen(i+1)= Y_dodichchuyen(i)+ delta_y1(i);
    X_tho(i+1) = X_tho(i) + delta_x1(i);    
    Y_tho(i+1) = Y_tho(i) + delta_y1(i);
end

% Ve do thi
figure(1)
subplot(1,2,1);
bar(deltaX_tho);
title('Delta X - truoc bo loc');
grid on;
xlabel('So chu ki noi suy');
ylabel('Do dich chuyen');
subplot(1,2,2);
bar(delta_x1);
title('Delta X sau khi qua bo loc');
grid on;
xlabel('So chu ki noi suy');
ylabel('Do dich chuyen');

figure(2)
subplot(1,2,1);
bar(deltaY_tho);
title('Delta Y - truoc bo loc');
grid on;
xlabel('So chu ki noi suy');
ylabel('Do dich chuyen');
subplot(1,2,2);
bar(delta_y1);
title('Delta Y sau khi qua bo loc');
grid on;
xlabel('So chu ki noi suy');
ylabel('Do dich chuyen');

figure(3)
plot(X_tho,Y_tho,'r');
hold on;
title('quy dao duong tron');
xlabel('trucx (mm)');
ylabel('trucy (mm)');
plot(xC,yC,'b o',Xcenter,Ycenter,'b *');
hold on
% plot(trucx.signals.values, trucy.signals.values,'--b');
%stairs(trucx.signals.values, trucy.signals.values,'--b');
grid on;

% Noi suy tinh
k = Tipo/Tdk;
t2 = [0 1];
for i = 1:(N*5-1)
    t2(i+1) = t2(i) + Tdk;
end


% %tinh noi suy tinh
X2 = [0 0];
Y2 = [0 0];
for i = 1:N-1
    for j =1:k
        X2(i+1,j) = delta_x1(i)/k;    %o day X2 va Y2 dang la ma tran nhieu hang nhieu cot
        Y2(i+1,j) = delta_y1(i)/k;    %nen ko ve do thi voi t2 duoc
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
xlabel('thoi gian (s)');
ylabel('delta x (mm)');
title('Delta x theo phuong phap tuyen tinh');
axis([1 1.02 0 0.002]);
subplot(1,2,2);
bar(t2,CY);
xlabel('thoi gian (s)');
ylabel('delta y (mm)');
title('Delta y theo phuong phap tuyen tinh');
axis([0.5 0.52 0 0.004]);

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
title('Delta x theo phuong phap trung binh');
xlabel('thoi gian (s)')
ylabel('delta x (mm)')
axis([1 1.02 0 0.002]);
subplot(1,2,2);
bar(t2,bY2)
title('Delta y theo phuong phap trung binh');
xlabel('thoi gian (s)')
ylabel('delta y (mm)')
axis([0.5 0.52 0 0.004]);
    
%%noi suy tinh theo pp trung binh
X_tinh = [0 X_tho(1)];
Y_tinh = [0 Y_tho(1)];
for i = 1:(N*k-1)
    X_tinh(i+1) = X_tinh(i) + bX2(i);
    Y_tinh(i+1) = Y_tinh(i) + bY2(i);
end

figure(6)
plot(X_tinh,Y_tinh,'r');
xlabel('truc x (mm)');
ylabel('truc y (mm)');
title(' quy dao duong tron sau khi noi suy tinh');

figure(7)
stairs(X_tho,Y_tho,'r-');
hold on
stairs(X_tinh,Y_tinh,'b-');
title(' so sanh noi suy tho va noi suy tinh');
xlabel('truc x (mm)');
ylabel('truc y (mm)');


