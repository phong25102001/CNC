% Test ADCAI Line

clear;
x_start = 0; 
y_start = 0;
x_end = 55;
y_end = 45;
AD = 10; 
Tipo = 0.005;
Tpos = 0.001;
F = 20;

[dX_rough, dY_rough, t] = ADCAI_rough_interpolation_Line(x_start, y_start, x_end, y_end, Tipo, F);

[dX_filt, dY_filt] = ADCAI_digital_filter(dX_rough, dY_rough, AD, Tipo, F);

[fine_delta_x, fine_delta_y, t] = fine_interpolation(dX_filt, dY_filt, Tipo, Tpos, "average");

[xSP, ySP] = calculate_SP(x_start, y_start, fine_delta_x, fine_delta_y);

sim("Driver_Motor_Model_CNC.slx");