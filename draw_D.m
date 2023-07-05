x_start = 0; 
y_start = 0;
x_1 = 0;
y_1 = -80;
x_end = 0; 
y_end = 0;
R = 50;
direction = "CCW";
A = 10; D = 10;
Tipo = 0.005;
Tpos = 0.001;
F = 20;

%đường thẳng (0-0) -> (0,-80)

[vXY1, S1] = ADCBI_and_rough_interpolation_Line(x_start, y_start, x_1, y_1, A, D, Tipo, F);

[rough_delta_x1, rough_delta_y1] = ADCBI_mapping_axis_Line(x_start, y_start, x_1, y_1, S1);

[fine_delta_x1, fine_delta_y1, t1] = fine_interpolation(rough_delta_x1, rough_delta_y1, Tipo, Tpos, "average");

[xSP1, ySP1] = calculate_SP(x_start, y_start, fine_delta_x1, fine_delta_y1);


%cung tròn (0,-80) -> (0,0)

[w_ipo, delta_phi, t3, phi_start] = ADCBI_and_rough_interpolation_Circle(x_1, y_1, x_end, y_end, R, direction, A, D, Tipo, F);

[rough_delta_x3, rough_delta_y3] = ADCBI_mapping_axis_Circle(R, phi_start, delta_phi);

[fine_delta_x3, fine_delta_y3, t2_temp] = fine_interpolation(rough_delta_x3, rough_delta_y3, Tipo, Tpos, "average");

[xSP3, ySP3] = calculate_SP(x_1, y_1, fine_delta_x3, fine_delta_y3);

%ghép mảng
t2 = t1(end) + t2_temp;
xSP = [xSP1,xSP3];
ySP = [ySP1,ySP3];
t = [t1 t2];
sim("Driver_Motor_Model_CNC.slx");