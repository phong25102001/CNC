function [delta_x, delta_y] = mapping_axis_Line(x_start, y_start, x_end, y_end, S)
% [delta_x, delta_y] = mapping_axis_Line(x_start, y_start, x_end, y_end, S)
% Chiếu chuyển động lên các trục x và y 
%   Input:  
%           * x_start, y_start: Tọa độ điểm xuất phát của đoạn thẳng (mm, mm)
%           * x_end, y_end: Tọa độ điểm kết thúc của đoạn thẳng (mm, mm)
%           * S: mảng các giá trị đặt của quãng đường cần di chuyển trên L(mm)
%   Output: 
%           * delta_x: mảng các giá trị quãng đường di chuyển theo trục x(mm)
%           * delta_y: mảng các giá trị quãng đường di chuyển theo trục y(mm)

    L = sqrt((x_end-x_start)^2 + (y_end-y_start)^2);
    delta_x = S*(x_end-x_start)/L;
    delta_y = S*(y_end-y_start)/L;
end

