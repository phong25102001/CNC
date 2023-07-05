x_start = 0; 
y_start = 0;
x_1 = 0;
y_1 = -60;
x_2 = 80; 
y_2 = -60;
x_end = 80;
y_end = 0;
A = 10; D = 10;
Tipo = 0.005;
Tpos = 0.001;
F = 20;
R = 40;
direction = "CCW";

%đường thẳng (0,0) -> (0,-60)

[vXY1, S1] = ADCBI_and_rough_interpolation_Line(x_start, y_start, x_1, y_1, A, D, Tipo, F);

[rough_delta_x1, rough_delta_y1] = ADCBI_mapping_axis_Line(x_start, y_start, x_1, y_1, S1);

[fine_delta_x1, fine_delta_y1, t1] = fine_interpolation(rough_delta_x1, rough_delta_y1, Tipo, Tpos, "average");

[xSP1, ySP1] = calculate_SP(x_start, y_start, fine_delta_x1, fine_delta_y1);



%cung tròn (0,-60) -> (80,-60)

[vXY2, S2] = ADCBI_and_rough_interpolation_Line(x_2, y_2, x_end, y_end, A, D, Tipo, F);

[rough_delta_x2, rough_delta_y2] = ADCBI_mapping_axis_Line(x_2, y_2, x_end, y_end, S2);

[fine_delta_x2, fine_delta_y2, t2_temp] = fine_interpolation(rough_delta_x2, rough_delta_y2, Tipo, Tpos, "average");

[xSP2, ySP2] = calculate_SP(x_2, y_2, fine_delta_x2, fine_delta_y2);


%đường thẳng (80,-60) -> (80,0)

[w_ipo, delta_phi, t3, phi_start] = ADCBI_and_rough_interpolation_Circle(x_1, y_1, x_2, y_2, R, direction, A, D, Tipo, F);

[rough_delta_x3, rough_delta_y3] = ADCBI_mapping_axis_Circle(R, phi_start, delta_phi);

[fine_delta_x3, fine_delta_y3, t3_temp] = fine_interpolation(rough_delta_x3, rough_delta_y3, Tipo, Tpos, "average");

[xSP3, ySP3] = calculate_SP(x_1, y_1, fine_delta_x3, fine_delta_y3);


% ghép mảng
t3 = t1(end) + t3_temp;
t2 = t3(end) + t2_temp;
xSP = [xSP1,xSP3,xSP2];
ySP = [ySP1,ySP3,ySP2];
t = [t1,t3,t2];
sim("Driver_Motor_Model_CNC.slx");