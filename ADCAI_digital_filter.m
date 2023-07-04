function [dX_filt, dY_filt, t] = ADCAI_digital_filter(dX_rough, dY_rough, AD, Tipo, F)
% [dX_filt, dY_filt, t] = ADCAI_digital_filter(dX_rough, dY_rough, AD, Tipo, F)
% Bộ lọc số tăng giảm tốc sau nội suy cho đoạn thẳng và cung tròn
%   Input:  
%           * dX_rough, dY_rough: Các đoạn thẳng nhỏ theo trục cho từng bước nội suy (mm, mm)
%           * AD: Gia tốc tăng/giảm tốc (mm/s^2)
%           * Tipo: Thời gian bước nội suy (s)
%           * F: Tốc độ ăn dao (mm/s)
%   Output: 
%           * dX_filt, dY_filt: Đoạn thẳng từng bước nội suy sau lọc cho trục X, Y tương ứng (mm, mm)
%           * t: Mảng các thời điểm nội suy (s)

    Tad = F/AD; % tính toán thời gian tăng giảm tốc
    m = round(Tad/Tipo); % tính số điểm tăng giảm tốc 

    % khởi tạo giá trị 
    dX_filt(1) = (1/m)*(dX_rough(1));
    dY_filt(1) = (1/m)*(dY_rough(1));
    t(1) = 0;

    % thực hiện tính toán bộ lọc
    for k = 2:(length(dX_rough) + m)

        if (k > m) && (k <= length(dX_rough)) % Khoảng có giá trị của dX_rough

            dX_filt(k) = (1/m)*(dX_rough(k)-dX_rough(k-m)) + dX_filt(k-1);
            dY_filt(k) = (1/m)*(dY_rough(k)-dY_rough(k-m)) + dY_filt(k-1);

        elseif k <= m % thêm các giá trị 0 ban đầu cho dX_rough nếu k <= m để lọc

            dX_filt(k) = (1/m)*(dX_rough(k)-0) + dX_filt(k-1);
            dY_filt(k) = (1/m)*(dY_rough(k)-0) + dY_filt(k-1);

        else % thêm các giá trị 0 cuối cho dX_rough nếu k > length(dX_rough)+m để lọc

            dX_filt(k) = (1/m)*(0-dX_rough(k-m)) + dX_filt(k-1);
            dY_filt(k) = (1/m)*(0-dY_rough(k-m)) + dY_filt(k-1);

        end

        t(k) = t(k-1) + Tipo; % tính toán lại các thời điểm nội suy vì đã thêm các điểm nội suy sau khi lọc

    end     

    
end