% Test ADCAI Circle

clear;
x_start = 0; 
y_start = 0;
x_end = 40;
y_end = 40;
R = -40;
direction = "CW";
AD = 10;
Tipo = 0.005;
Tpos = 0.001;
F = 10;
BLU = 0.0001;

[dX_rough, dY_rough, t] = ADCAI_rough_interpolation_Circle(x_start, y_start, x_end, y_end, R, direction, Tipo, BLU);
figure(1);
subplot(2,1,1);
bar(t, dX_rough);
title("Hình chiếu đoạn di chuyển trên trục x sau nội suy thô"); xlabel("t(s)"); ylabel("delta_x(mm)");

subplot(2,1,2);
bar(t, dY_rough);
title("Hình chiếu đoạn di chuyển trên trục y sau nội suy thô"); xlabel("t(s)"); ylabel("delta_y(mm)");


[dX_filt, dY_filt, t] = ADCAI_digital_filter(dX_rough, dY_rough, AD, Tipo, F);
figure(2);
subplot(2,1,1);
bar(t, dX_filt);
title("Hình chiếu đoạn di chuyển trên trục x sau lọc"); xlabel("t(s)"); ylabel("delta_x(mm)");

subplot(2,1,2);
bar(t, dY_filt);
title("Hình chiếu đoạn di chuyển trên trục y sau lọc"); xlabel("t(s)"); ylabel("delta_y(mm)");


[fine_delta_x, fine_delta_y, t] = fine_interpolation(dX_filt, dY_filt, Tipo, Tpos, "average");
figure(3);
subplot(2,1,1);
bar(t, fine_delta_x);
title("Hình chiếu đoạn di chuyển trên trục x sau nội suy tinh"); xlabel("t(s)"); ylabel("delta_x(mm)");

subplot(2,1,2);
bar(t, fine_delta_y);
title("Hình chiếu đoạn di chuyển trên trục y sau nội suy tinh"); xlabel("t(s)"); ylabel("delta_y(mm)");


[xSP, ySP] = calculate_SP(x_start, y_start, fine_delta_x, fine_delta_y);
figure(4);
subplot(2,1,1);
stairs(t, xSP);
title("Vị trí đặt cho trục x ADCAI"); xlabel("t(s)"); ylabel("xSP(mm)");
 
subplot(2,1,2);
stairs(t, ySP);
title("Vị trí đặt cho trục y ADCAI"); xlabel("t(s)"); ylabel("ySP(mm)");

sim("Driver_Motor_Model_CNC.slx");
