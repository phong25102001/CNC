function [xSP, ySP] = calculate_SP(x_start, y_start, delta_x, delta_y)
% [xSP, ySP] = calculate_SP(x_start, y_start, delta_x, delta_y)
% Tính toán giá trị điểm đặt cho từng chu kì nội suy
%   Input:  
%           * x_start, y_start: Tọa độ điểm xuất phát của đoạn thẳng (mm, mm)
%           * delta_x: mảng các giá trị quãng đường di chuyển theo trục x(mm)
%           * delta_y: mảng các giá trị quãng đường di chuyển theo trục y(mm)
%   Output:
%           * x_SP: mảng các giá trị đặt theo trục x(mm)
%           * y_SP: mảng các giá trị đặt theo trục y(mm)
    
    xSP(1) = x_start+delta_x(1);
    ySP(1) = y_start+delta_y(1);
    
    for i = 2:length(delta_x)
        xSP(i) = xSP(i-1) + delta_x(i);
    end

    for i = 2:length(delta_y)
        ySP(i) = ySP(i-1) + delta_y(i);
    end

end

