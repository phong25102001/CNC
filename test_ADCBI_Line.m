% Test ADCBI Line

clear;
x_start = 0; 
y_start = 0;
x_end = 55;
y_end = 45;
A = 10; D = 10;
Tipo = 0.005;
Tpos = 0.001;
F = 20;

[vXY, S, t] = ADCBI_and_rough_interpolation_Line(x_start, y_start, x_end, y_end, A, D, Tipo, F);

figure(1);
stairs(t, vXY);
title("Biên dạng vận tốc ADCBI đường thẳng"); xlabel("t(s)"); ylabel("vXY(mm/s)");

figure(2);
bar(t, S);
title("Các giá trị quãng đường đặt từng bước nội suy"); xlabel("t(s)"); ylabel("S(mm)");



[rough_delta_x, rough_delta_y] = ADCBI_mapping_axis_Line(x_start, y_start, x_end, y_end, S);

figure(3);
subplot(2,1,1);
bar(t, rough_delta_x);
title("Hình chiếu đoạn di chuyển trên trục x"); xlabel("t(s)"); ylabel("delta_x(mm)");

subplot(2,1,2);
bar(t, rough_delta_y);
title("Hình chiếu đoạn di chuyển trên trục y"); xlabel("t(s)"); ylabel("delta_y(mm)");



[fine_delta_x, fine_delta_y, t] = fine_interpolation(rough_delta_x, rough_delta_y, Tipo, Tpos, "average");

figure(4);
subplot(2,1,1);
bar(t, fine_delta_x);
title("Đoạn di chuyển trên trục x sau nội suy tinh"); xlabel("t(s)"); ylabel("delta_x(mm)");

subplot(2,1,2);
bar(t, fine_delta_y);
title("Đoạn di chuyển trên trục y sau nội suy tinh"); xlabel("t(s)"); ylabel("delta_y(mm)");



[xSP, ySP] = calculate_SP(x_start, y_start, fine_delta_x, fine_delta_y);
figure(5);
subplot(2,1,1);
stairs(t, xSP);
title("vị trí đặt cho trục x"); xlabel("t(s)"); ylabel("xSP(mm)");

subplot(2,1,2);
stairs(t, ySP);
title("Vị trí đặt cho trục y"); xlabel("t(s)"); ylabel("ySP(mm)");



sim("Driver_Motor_Model_CNC.slx");
