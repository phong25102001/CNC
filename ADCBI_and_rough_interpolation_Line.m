function [vXY, S, t] = ADCBI_and_rough_interpolation_Line(x_start, y_start, x_end, y_end, A, D, Tipo, F)
% [vXY, S, t] = ADCBI_and_rough_interpolation_Line(x_start, y_start, x_end, y_end, A, D, Tipo, F)
% Thực hiện tăng giảm tốc trước nội suy và nội suy thô đoạn di chuyển đối với đoạn thẳng
%   Input:  
%           * x_start, y_start: Tọa độ điểm xuất phát của đoạn thẳng (mm, mm)
%           * x_end, y_end: Tọa độ điểm kết thúc của đoạn thẳng (mm, mm)
%           * A, D: Gia tốc tăng giảm tốc tương ứng (mm/s^2, mm/s^2)
%           * Tipo: Thời gian bước nội suy (s)
%           * F: Tốc độ ăn dao (mm/s)
%   Output: 
%           * vXY: Mảng vận tốc đặt từng bước nội suy (mm/s)
%           * S: Mảng các đoạn di chuyển cho từng bước nội suy (mm)
%           * t: Mảng các thời điểm nội suy (s)

    % tính toán độ dài đoạn thẳng và khởi tạo các giá trị đầu
    L = sqrt((x_end-x_start)^2 + (y_end-y_start)^2);
    vXY(1) = 0;
    t(1) = 0;
    S(1) = 0;
    
    % kiểm tra quỹ đạo normal hay short
    if (F^2/(2*A) + F^2/(2*D) >= L) % short block
        F_comma = sqrt(2*L*A*D/(A+D));
        Ta = F_comma/A;
        Td = F_comma/D;
        Tc = 0;
    else % normal block
        Ta = F/A;
        Td = F/D;
        Tc = L/F - F/(2*A)-F/(2*D);
    end

    % số điểm tăng giảm tốc
    Na = floor(Ta/Tipo+1); % số điểm tăng tốc
    Nd = floor(Td/Tipo); % số điểm giảm tốc
    Nc = floor(Tc/Tipo); % số điểm chạy đều

    % thực hiện tính toán tốc độ
    for i = 1:Na+Nd+Nc
         
        if i < Na % giai đoạn tăng tốc
            vXY(i+1) = vXY(i) + Tipo*A;
            S(i+1) = Tipo*(vXY(i+1)+vXY(i))/2;
    
         elseif Na <= i && i < Nc+Na % giai đoạn chạy đều
            vXY(i+1) = vXY(i);
            S(i+1) = vXY(i)*Tipo;
    
         elseif (Na+Nc) <= i && i < Na+Nc+Nd % giai đoạn giảm tốc
            vXY(i+1) = vXY(i)-Tipo*D;
            S(i+1) = Tipo*(vXY(i+1)+vXY(i))/2; 

        end    


        % tính toán các thời điểm nội suy
        if i < Na+Nd+Nc
            t(i+1) = t(i) + Tipo; 
        end
        
    end

    % Bù phần thiếu của đoạn thẳng cho từng bước nội suy
    Srem = L-sum(S);
    S = S+Srem/(Na+Nc+Nd);

end