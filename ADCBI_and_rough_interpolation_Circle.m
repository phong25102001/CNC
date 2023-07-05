function [w_ipo, delta_phi, t, phi_start] = ADCBI_and_rough_interpolation_Circle(x_start, y_start, x_end, y_end, R, direction, A, D, Tipo, F)
% [w_ipo, delta_phi, t, phi_start] = ADCBI_and_rough_interpolation_Circle(x_start, y_start, x_end, y_end, R, direction, A, D, Tipo, F)
% Thực hiện tăng giảm tốc trước nội suy và nội suy thô góc di chuyển đối với cung tròn
%   Input:  
%           * x_start, y_start: Tọa độ điểm xuất phát của cung (mm, mm)
%           * x_end, y_end: Tọa độ điểm kết thúc của cung (mm, mm)
%           * R: Bán kính cung tròn (R > 0 => cung nhỏ; R < 0 => cung lớn) (mm)
%           * direction: hướng đi của cung ("CW" => cùng chiều kim đồng hồ , "CCW" => ngược chiều kim đồng hồ)
%           * A, D: Gia tốc tăng giảm tốc tương ứng (mm/s^2)
%           * Tipo: Thời gian bước nội suy (s)
%           * F: Tốc độ ăn dao (m/s)
%   Output: 
%           * w_ipo: Mảng vận tốc góc đặt từng bước nội suy (rad/s)
%           * delta_phi: Mảng khoảng di chuyển của góc cho từng bước nội suy thô (rad)
%           * t: Mảng các thời điểm nội suy (s)
%           * phi_start: Góc xuất phát của cung tròn nội suy so với trục x+
    
    % mã hóa chiều quay
    dir = 0;
    if direction == "CW"
        dir = 1;
    elseif direction == "CCW"
        dir = -1;
    else
        fprintf("không có direction %s", direction)
    end

    % quy đổi vận tốc gia tốc về đơn vị góc
    beta_A = A/abs(R);
    beta_D = D/abs(R);
    W = F/abs(R);
    
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

    % tìm góc bắt đầu, góc kết thúc và góc cần quét 
     phi_start = atan2(y_start-yC,x_start-xC); % góc xuất phát 
     cAngle = (1-sign(R))*pi+2*asin(0.5*L/R); % góc phải quét
    
    % kiểm tra quỹ đạo normal hay short
    if (W^2/(2*beta_A) + W^2/(2*beta_D) >= cAngle) % short block
        W_comma = sqrt(2*cAngle*beta_A*beta_D/(beta_A+beta_D));
        Ta = W_comma/beta_A;
        Td = W_comma/beta_D;
        Tc = 0;
    else % normal block
        Ta = W/beta_A;
        Td = W/beta_D;
        Tc = cAngle/W - W/(2*beta_A)-W/(2*beta_D);
    end

    % số điểm tăng giảm tốc
    Na = floor(Ta/Tipo+1); % số điểm tăng tốc
    Nd = floor(Td/Tipo); % số điểm giảm tốc
    Nc = floor(Tc/Tipo); % số điểm chạy đều

    % khởi tạo các giá trị ban đầu
    w_ipo(1) = 0;
    delta_phi(1) = 0;
    t(1) = 0;

    % thực hiện tính toán tốc độ và vị trí
    for i = 1:Na+Nd+Nc
         
        if i < Na % giai đoạn tăng tốc
            w_ipo(i+1) = w_ipo(i) + (-dir)*Tipo*beta_A;
            delta_phi(i+1) = Tipo*( w_ipo(i+1) + w_ipo(i) )/2;
    
         elseif Na <= i && i < Nc+Na % giai đoạn chạy đều
            w_ipo(i+1) = w_ipo(i);
            delta_phi(i+1) = w_ipo(i)*Tipo;
    
         elseif (Na+Nc) <= i && i < Na+Nc+Nd % giai đoạn giảm tốc
            w_ipo(i+1) = w_ipo(i) - (-dir)*Tipo*beta_D;
            delta_phi(i+1) = Tipo*( w_ipo(i+1) + w_ipo(i) )/2; 

         end    
        
        if i < Na+Nd+Nc % các thời điểm nội suy
            t(i+1) = t(i) + Tipo; 
        end
        
    end

    % tính toán bù trừ phần thiếu của góc quét
    phi_rem = (-dir)*cAngle-sum(delta_phi);
    delta_phi = delta_phi+phi_rem/(Na+Nc+Nd);

end