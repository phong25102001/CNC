% Test ADCBI Circle

clear;
x_start = 0; 
y_start = 0;
x_end = 20;
y_end = 50;
R = 40;
direction = "CCW";
A = 10; D = 10;
Tipo = 0.005;
Tpos = 0.001;
F = 20;

[w_ipo, delta_phi, t, phi_start] = ADCBI_and_rough_interpolation_Circle(x_start, y_start, x_end, y_end, R, direction, A, D, Tipo, F);
figure(1);
stairs(t, w_ipo);
ylim([0, max(w_ipo)+0.1]);
title("Biên dạng vận tốc góc ADCBI đường tròn"); xlabel("t(s)"); ylabel("w _ ipo(rad/s)");

figure(2);
bar(t, delta_phi);
title("Các giá trị khoảng góc từng bước nội suy"); xlabel("t(s)"); ylabel("delta _ phi(rad)");



[rough_delta_x, rough_delta_y] = ADCBI_mapping_axis_Circle(R, phi_start, delta_phi);
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
