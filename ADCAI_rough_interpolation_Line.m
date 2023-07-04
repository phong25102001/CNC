function [dX_rough, dY_rough, t] = ADCAI_rough_interpolation_Line(x_start, y_start, x_end, y_end, Tipo, F)
% [dX_rough, dY_rough, t] = ADCAI_rough_interpolation_Line(x_start, y_start, x_end, y_end, Tipo, F)
% Thực hiện nội suy thô của thuật toán tăng giảm tốc sau nội suy cho đoạn thẳng 
%   Input:  
%           * x_start, y_start: Tọa độ điểm xuất phát của đoạn thẳng (mm, mm)
%           * x_end, y_end: Tọa độ điểm kết thúc của đoạn thẳng (mm, mm)
%           * Tipo: Thời gian bước nội suy (s)
%           * F: Tốc độ ăn dao (mm/s)
%   Output: 
%           * dX_rough, dY_rough: Mảng các đoạn cần di chuyển cho từng bước nội suy (mm, mm)
%           * t: Mảng các thời điểm nội suy (s)

    % tính toán độ dài đoạn thẳng và khởi tạo thời gian
    L = sqrt((x_end-x_start)^2 + (y_end-y_start)^2);
    t(1) = 0;
    
    % tính thời gian nội suy và số điểm nội suy
    T = L/F;
    N = floor(T/Tipo);

    % thực hiện tính toán dX và dY
    for i = 1:N
         
        dX_rough(i) = (x_end-x_start)/N;
        dY_rough(i) = (y_end-y_start)/N;
        
        % tính toán các thời điểm nội suy
        if i < N
            t(i+1) = t(i) + Tipo; 
        end
        
    end


    % bù phần thiếu của đoạn thẳng vào từng bước nội suy
    Srem = L-sqrt(sum(dX_rough)^2+sum(dY_rough)^2);
    dX_rough = dX_rough + Srem*(x_end-x_start)/L;
    dY_rough = dY_rough + Srem*(y_end-y_start)/L;

end