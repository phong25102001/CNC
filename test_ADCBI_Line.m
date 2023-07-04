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

[rough_delta_x, rough_delta_y] = ADCBI_mapping_axis_Line(x_start, y_start, x_end, y_end, S);

[fine_delta_x, fine_delta_y, t] = fine_interpolation(rough_delta_x, rough_delta_y, Tipo, Tpos, "average");

[xSP, ySP] = calculate_SP(x_start, y_start, fine_delta_x, fine_delta_y);

sim("Driver_Motor_Model_CNC.slx");
