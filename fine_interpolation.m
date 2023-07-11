function [fine_deltaX, fine_deltaY, t] = fine_interpolation(rough_deltaX,rough_deltaY, Tipo, Tpos, method)
% [fine_deltaX, fine_deltaY, t] = fine_interpolation(rough_deltaX, rough_deltaY, Tipo, Tpos, method)
% Thực hiện nội suy tinh 
%   Input:  
%           * rough_deltaX, rough_deltaY: Mảng các quãng đường di chuyển trên trục X, Y sau khi nội suy thô (mm, mm)
%           * Tipo: Chu kỳ nội suy (s)
%           * Tpos: Chu kỳ điều khiển vị trí (s)
%           * method: "linear" hoặc "average" là phương thức tính toán điểm  nội suy tinh
%   Output:
%           * fine_deltaX, fine_deltaY: Mảng các giá trị khoảng di chuyển trên trục X, Y sau nội suy tinh (mm, mm)
%           * t: Mảng các giá trị thời điểm nội suy tinh cho fine_deltaX và finedeltaY (s, s)

    % tính toán số điểm nội suy tinh cho từng bước nội suy thô và khởi tạo thời gian gốc
    N = floor(Tipo/Tpos);
    t(1) = 0;
    

    if method == "linear" % triển khai thuật toán nội suy tinh tuyến tính
        
        for j = 1:length(rough_deltaX)
            for i = 1:N

                fine_deltaX( i-1 + N*(j-1) + 1) = rough_deltaX(j)/N;
                fine_deltaY( i-1 + N*(j-1) + 1 ) = rough_deltaY(j)/N;

                if (i-1 + N*(j-1) + 2 <= N-1 + N*(length(rough_deltaX)-1) + 1) % giới hạn vùng tăng t
                    t( i-1 + N*(j-1) + 2) = t( i-1 + N*(j-1) + 1 ) + Tpos;
                end

            end
        end

    elseif method == "average" % triển khai thuật toán nội suy tinh trung bình

        [aX, aY, t] = fine_interpolation(rough_deltaX, rough_deltaY, Tipo, Tpos, "linear"); % thực hiện nội suy tuyến tính trước

        endCalculate = length(aX);


        % thêm các giá trị cuối vào mảng aX, aY để đáp ứng đủ thêm ceil(N/2) giá trị
        aX( endCalculate : endCalculate + ceil(N/2) ) = 0; 
        aY( endCalculate : endCalculate + ceil(N/2) ) = 0;

        % tính toán dựa trên công thức nội suy tinh trung bình
        for j = abs(ceil(-N/2)) + 1 : endCalculate 
            fine_deltaX(j) = 0.5*( mean( aX( j+ceil(-N/2+1) : j+ceil(N/2) ) ) + mean( aX( j+ceil(-N/2) : j+ceil(N/2-1) ) ) );
            fine_deltaY(j) = 0.5*( mean( aY( j+ceil(-N/2+1) : j+ceil(N/2) ) ) + mean( aY( j+ceil(-N/2) : j+ceil(N/2-1) ) ) );
        end

    else
    
        fprintf("Không có method %s", method);

    end

end

