% Test Circle

clear;
x_start = 0; 
y_start = 0;
x_end = 40;
y_end = 40;
R = 40;
direction = "CCW";
A = 10; D = 10;
Tipo = 0.005;
Tpos = 0.001;
F = 20;

[w_ipo, delta_phi, t, phi_start] = ADCBI_and_rough_interpolation_Circle(x_start, y_start, x_end, y_end, R, direction, A, D, Tipo, F);

[rough_delta_x, rough_delta_y] = mapping_axis_Circle(R, phi_start, delta_phi);

[fine_delta_x, fine_delta_y] = fine_interpolation(rough_delta_x, rough_delta_y, Tipo, Tpos, "average");

[xSP, ySP] = calculate_SP(x_start, y_start, fine_delta_x, fine_delta_y);

sim("Driver_Motor_Model_CNC.slx");
