                                                                                                                                             %ve chu U gom 2 duong thang va 1 duong tron
%dt thu nhat tu diem (10;50) den diem (10 20)
%nua duong tron huong xuong duoi co tam (20 20), tu diem (10 20) den diem
%(30 20)
%dt thu hai tu diem (30 20) den diem (30 50)

%%ve duong thang dau tien
xA = 10;
yA = 70;
xB = 10;
yB = 20;
L1 = sqrt((xB - xA)^2 + (yB - yA)^2); %Chieu dai quang duong
A = 20; %Gia toc tang
D = 20; %Gia toc giam
F = 20;
Vmax = 30; %van toc toi da
Vs = 0; %Van toc khoi dong
Ve = 0; %Van toc ket thuc
Tacc = Vmax/A; %Thoi gian tang toc
Tdec = Vmax/D; %Thoi gian giam toc
Tipo = 0.005; %Chu ki noi suy tho
Tdk = 0.001; %Chu ki dieu khien

% Xay dung profile tocdo
Na_line1= floor(Tacc/Tipo);
a1_line1 = (Vmax - Vs)/(Na_line1*Tipo);    %gia toc tang toc
Nd_line1 = floor(Tdec/Tipo);
a3_line1 = (Ve - Vmax)/(Nd_line1*Tipo);    %gia toc giam toc

if (L1 -((Vmax^2 - Vs^2)/(2*a1_line1))-((Ve^2 - Vmax^2)/(2*a3_line1)))/Vmax > 0
    Tconst_line1 = ((L1 -((Vmax*Vmax - Vs*Vs)/(2*a1_line1))-((Ve*Ve - Vmax*Vmax)/(2*a3_line1)))/Vmax); %thoi gian toc do khong doi
    Nc_line1 = floor(Tconst_line1/Tipo);
    V = [0 0];
    for i =1:(Na_line1 + Nd_line1 + Nc_line1 -1)
        if (i <= Na_line1)
            V(i+1) = V(i) + a1_line1*Tipo;
        elseif (Na_line1 < i && i <= (Na_line1+Nc_line1))
            V(i+1) = V(i);
        else
            V(i+1) = V(i) + a3_line1*Tipo;
        end
    end
else
    Vmax = sqrt((2*L1*a1_line1*a3_line1)/(a3_line1 - a1_line1));
    Na_line1 = Vmax/(a1_line1*Tipo);
    Nd_line1 = Vmax/(a3_line1*Tipo);
    Nc_line1 = 0;
    V = [0 1];
    for i = 1:(Na_line1+Nd_line1-1)
        if ( i <= Na_line1)
            V(i+1) = V(i) + a1_line1*Tipo;
        else
            V(i+1) = V(i) + a3_line1*Tipo;
        end
    end
end
N_line1 = Na_line1+Nc_line1+Nd_line1-1;
t1 = [0 1];
for i = 1:N_line1
    t1(i+1) = t1(i)+ Tipo;
end
% noi suy vi tri truc X
X_dodichchuyen_line1 = [0 1];
X_tho_line1 = [xA 1];
deltaX_tho_line1 = [Tipo*V(2)*(xB-xA)/(2*L1) 1]; % dentaX
Xstart = xA;
Xend = xB;
for i = 1:N_line1
    deltaX_tho_line1(i+1) = Tipo*(V(i+1)+V(i))*(xB-xA)/(2*L1);
    X_dodichchuyen_line1(i+1) = X_dodichchuyen_line1(i)+ deltaX_tho_line1(i);
    X_tho_line1(i+1) = X_tho_line1(i) + deltaX_tho_line1(i);
end


% noi suy vi tri truc Y
Y_dodichchuyen_line1 = [0 1];
Y_tho_line1 = [yA 1];
deltaY_tho_line1 = [Tipo*V(2)*(yB-yA)/(2*L1) 1]; % dentaY
Ystart = yA;
Yend = yB;
for i = 1:N_line1
    deltaY_tho_line1(i+1) = (Tipo*(V(i+1)+V(i))/2)*(yB-yA)/L1;
    Y_dodichchuyen_line1(i+1) = Y_dodichchuyen_line1(i) + deltaY_tho_line1(i);
    Y_tho_line1(i+1) = Y_tho_line1(i) + deltaY_tho_line1(i);
end

t2 = [0 1];
for i = 1: (N_line1*5-1)
    t2(i+1) = t2(i)+Tdk;
end

k = Tipo/Tdk;

% figure(1)
% plot(X_tho_line1,Y_tho_line1,'r');
% xlabel('truc x (mm)');
% ylabel('truc y (mm)');
% title('do thi quy dao duong thang dau tien')
% axis([0 20 0 80]);


%%%noi suy nua duong tron
Wstart = 0;
Wend = 0;
xB = 10;                
yA = 20;
Xstart = xB;
Ystart = yB;
Xcenter = 20;
Ycenter = 20;
C = 0;
F = 20;
A = 20;
D = 20;
Tipo = 0.005; %Chu ki noi suy tho
Tdk = 0.001; %Chu ki dieu khien
R = sqrt((Xcenter - Xstart)^2 + (Ycenter - Ystart)^2);    %tinh ban kinh duong tron
Wmax = F/R;
At = A/R;               %gia toc goc tang toc
Dt = D/R;               %gia toc goc giam toc
theta0 = acos((Xstart-Xcenter)/R);      %tinh goc ban dau
theta = 180;                            %goc noi suy
L_circle = 2*R;                                % do dai quang duong
TA = Wmax/At;                           % thoi gian tang toc
TD = Wmax/Dt;                           %thoi gian giam toc
Nac_circle = floor(TA/Tipo);                   %so lan noi suy tang toc
a1_circle = (Wmax - Wstart)/(Nac_circle*Tipo);        %gia toc goc tang toc
Ndc_circle = floor(TD/Tipo);                   %so lan noi suy giam toc
a3_circle = (Wend - Wmax)/(Ndc_circle*Tipo);          %gia toc goc giam toc
%tinh thoi gian toc do khong doi
Tconst_circle = (theta*pi/180 - (Wmax*Wmax-Wend*Wend)/(2*a1_circle)-(Wend*Wend-Wmax*Wmax)/(2*a3_circle))/Wmax;
Ncc_circle = floor(Tconst_circle/Tipo);               %so lan noi suy toc do khong doi
W = [0 1];
N_circle = Nac_circle + Ndc_circle + Ncc_circle;


%tinh van toc
for i = 1:N_circle-1
    if (i <= Nac_circle)
        W(i+1) = W(i) + a1_circle*Tipo;
    elseif (i> Nac_circle) && (i <= (Nac_circle +  Ncc_circle))
        W(i+1) = W(i);
    else
        W(i+1) = W(i) + Tipo*a3_circle;
    end
end
t1 = [0 1];
for i = 1:N_circle-1
    t1(i+1) = t1(i) + Tipo;
end

alpha = [Tipo*W(2)/2 1];
Gocnoisuy = [theta0 1];
deltaX_tho_circle = [0 1];     %do dich chuyen truc x
deltaY_tho_circle = [0 1];     %do dich chuyen truc y  
X_tho_circle = [Xstart 1];
Y_tho_circle = [Ystart 1];
for i = 1:N_circle-1
    alpha(i+1) = Tipo*(W(i) + W(i+1))/2;
    if (C==1)
        Gocnoisuy(i+1) = Gocnoisuy(i) - alpha(i);
    else 
        Gocnoisuy(i+1) = Gocnoisuy(i) + alpha(i);
    end
    deltaX_tho_circle(i+1) = R*cos(Gocnoisuy(i+1)) - R*cos(Gocnoisuy(i));
    deltaY_tho_circle(i+1) = R*sin(Gocnoisuy(i+1)) - R*sin(Gocnoisuy(i));
    X_tho_circle(i+1) = Xcenter + R*cos(Gocnoisuy(i+1));
    Y_tho_circle(i+1) = Ycenter + R*sin(Gocnoisuy(i+1));
end


%%noi suy duong thang thu 2
% Xay dung profile toc do
xC = 30;
xD = 30;
yC = 20;
yD = 70;
L2 = sqrt((xD - xC)^2 + (yD - yC)^2);
Na_line2= floor(Tacc/Tipo);
a1_line2 = (Vmax - Vs)/(Na_line2*Tipo);    %gia toc tang toc
Nd_line2 = floor(Tdec/Tipo);
a3_line2 = (Ve - Vmax)/(Nd_line2*Tipo);    %gia toc giam toc

if (L2 -((Vmax^2 - Vs^2)/(2*a1_line2))-((Ve^2 - Vmax^2)/(2*a3_line2)))/Vmax > 0
    Tconst_line2 = ((L2 -((Vmax*Vmax - Vs*Vs)/(2*a1_line2))-((Ve*Ve - Vmax*Vmax)/(2*a3_line2)))/Vmax); %thoi gian toc do khong doi
    Nc_line2 = floor(Tconst_line2/Tipo);
    V = [0 0];
    for i =1:(Na_line2 + Nd_line2 + Nc_line2 -1)
        if (i <= Na_line2)
            V(i+1) = V(i) + a1_line2*Tipo;
        elseif (Na_line2 < i && i <= (Na_line2+Nc_line2))
            V(i+1) = V(i);
        else
            V(i+1) = V(i) + a3_line2*Tipo;
        end
    end
else
    Vmax = sqrt((2*L2*a1_line2*a3_line2)/(a3_line2 - a1_line2));
    Na_line2 = Vmax/(a1_line2*Tipo);
    Nd_line2 = Vmax/(a3_line2*Tipo);
    Nc_line2 = 0;
    V = [0 1];
    for i = 1:(Na_line2+Nd_line2-1)
        if ( i <= Na_line2)
            V(i+1) = V(i) + a1_line2*Tipo;
        else
            V(i+1) = V(i) + a3_line2*Tipo;
        end
    end
end
N_line2 = Na_line2+Nc_line2+Nd_line2-1;

t1_line2 = [0 1];
for i = 1:N_line2-1
    t1_line2(i+1) = t1_line2(i) + Tipo;
end


% noi suy vi tri truc X
X_dodichchuyen_line2 = [0 1];
X_tho_line2 = [xC 1];
deltaX_tho_line2 = [0 1]; % dentaX
Xstart = xC;
Xend = xD;
for i = 1:N_line2
    deltaX_tho_line2(i+1) = Tipo*(V(i+1)+V(i))*(xD-xC)/(2*L1);
    X_dodichchuyen_line2(i+1) = X_dodichchuyen_line2(i)+ deltaX_tho_line2(i);
    X_tho_line2(i+1) = X_tho_line2(i) + deltaX_tho_line2(i);
end

% noi suy vi tri truc Y
Y_dodichchuyen_line2 = [0 1];
Y_tho_line2 = [yC 1];
deltaY_tho_line2 = [0 1]; % dentaY
Ystart = yC;
Yend = yD;
for i = 1:N_line2
    deltaY_tho_line2(i+1) = (Tipo*(V(i+1)+V(i))/2)*abs(yD-yC)/L2;
    Y_dodichchuyen_line2(i+1) = Y_dodichchuyen_line2(i) + deltaY_tho_line2(i);
    Y_tho_line2(i+1) = Y_tho_line2(i) + deltaY_tho_line2(i);
end


X_tho = [X_tho_line1 X_tho_circle X_tho_line2];
Y_tho = [Y_tho_line1 Y_tho_circle Y_tho_line2];

% figure(3)
% plot(X_tho_line2,Y_tho_line2);
% axis([0 40 0 100])

% figure(4)
% plot(X_tho,Y_tho,'r');
% axis([0 40 0 80]);

N = N_line1 + N_circle + N_line2;
deltaX_tho = [deltaX_tho_line1 deltaX_tho_circle deltaX_tho_line2];
deltaY_tho = [deltaY_tho_line1 deltaY_tho_circle deltaY_tho_line2];

% %tinh noi suy tinh
X2 = [0 0];
Y2 = [0 0];
for i = 1:N-1
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

%%noi suy tinh theo pp trung binh
X_tinh = [X_tho(1) 0];
Y_tinh = [Y_tho(1) 0];
for i = 1:(N*k-1)
    X_tinh(i+1) = X_tinh(i) + bX2(i);
    Y_tinh(i+1) = Y_tinh(i) + bY2(i);
end

figure(5)
plot(X_tinh,Y_tinh,'r');
title('Do thi chu U');
xlabel('truc x (mm)');
ylabel('truc y (mm)');
axis([0 40 0 120]);
% hold on
% plot(out.trucx.signals.values, out.trucy.signals.values,'--b');
% legend('Quy dao dat','Quy dao phan hoi');
% grid on

XY_tinh.time = [];
sum = [X_tinh;Y_tinh]';
XY_tinh.signals.values = sum;
XY_tinh.signals.dimensions = 2;


