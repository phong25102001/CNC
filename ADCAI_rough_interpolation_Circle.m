function [dX_rough, dY_rough, t] = ADCAI_rough_interpolation_Circle(x_start, y_start, x_end, y_end, R, direction, Tipo, BLU)
% [dX_rough, dY_rough, t] = ADCAI_rough_interpolation_Circle(x_start, y_start, x_end, y_end, R, direction, Tipo, BLU)
% Thực hiện nội suy thô của thuật toán tăng giảm tốc sau nội suy cho cung tròn
%   Input:  
%           * x_start, y_start: Tọa độ điểm xuất phát của cung tròn (mm, mm)
%           * x_end, y_end: Tọa độ điểm kết thúc của cung tròn (mm, mm)
%           * direction: Chiều quay cung tròn ("CCW" => ngược chiều kim đồng hồ, "CW" => quay thuận chiều kim đồng hồ)
%           * R: Bán kính cung nội suy (R > 0 => cung bé; R < 0 => cung lớn) (mm)
%           * Tipo: Thời gian bước nội suy (s)
%           * F: Tốc độ ăn dao (mm/s)
%   Output: 
%           * dX_rough, dY_rough: Mảng các đoạn dịch chuyển cho từng bước nội suy (mm, mm)
%           * t: Mảng các thời điểm nội suy (s)

    
    % mã hóa chiều quay
    dir = 0;
    if direction == "CW"
        dir = 1;
    elseif direction == "CCW"
        dir = -1;
    else
        fprintf("Không có chiều quay %s", direction)
        return;
    end

    % tìm trung điểm của điểm đầu và điểm cuối
    xM = (x_end+x_start)/2;
    yM = (y_end+y_start)/2;

    % tìm độ dài đoạn thẳng nối điểm đầu và điểm cuối độ dài bán kính cung
    L = sqrt((x_end-x_start)^2+(y_end-y_start)^2);
    h = sqrt(R^2-(L/2)^2);
   
    % tìm vector pháp tuyến của đường thẳng nối điểm đầu và điểm cuối
    xeMC = (y_end-y_start)/L;
    yeMC = (x_start-x_end)/L;

    % tìm tọa độ tâm của cung tròn
    xC = xM + dir*sign(R)*xeMC*h;
    yC = yM + dir*sign(R)*yeMC*h;

    cAngle = (1-sign(R))*pi+2*asin(0.5*L/R); % góc phải quét
    
    % tinh toán góc quét từng bước nội suy và số điểm nội suy 
    alpha = sqrt(8*BLU/abs(R)); % thuật toán Taylor
    N = floor(cAngle/alpha)+1;
    alpha = -dir*cAngle/N;

    % tính cos(alpha) và sin(alpha) theo thuật toán Taylor
    cos_alpha = 1-0.5*alpha^2;
    sin_alpha = alpha;

    % dịch chuyển trục tọa độ về tâm cung tròn và khởi tạo giá trị đầu
    X(1) = x_start - xC;
    Y(1) = y_start - yC;
    t(1) = 0;

    % thực hiện tính toán nội suy
    for i = 1:N

        % tính toán các đoạn dịch chuyển từng bước nội suy
        dX_rough(i) = (cos_alpha-1)*X(i) - sin_alpha*Y(i);
        dY_rough(i) = (cos_alpha-1)*Y(i) + sin_alpha*X(i);
        
        % tính các tọa độ theo tâm cung tròn để thực hiện bước nội suy tiếp theo
        X(i+1) = X(i) + dX_rough(i);
        Y(i+1) = Y(i) + dY_rough(i);

        % tính toán các thời điểm nội suy
        if i < N
            t(i+1) = t(i) + Tipo; 
        end
    end

end