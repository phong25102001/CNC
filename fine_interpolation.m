function [fine_deltaX, fine_deltaY, t] = fine_interpolation(rough_deltaX,rough_deltaY, Tipo, Tpos, method)
% [fine_deltaX, fine_deltaY, t] = fine_interpolation(rough_deltaX,rough_deltaY, Tipo, Tpos, method)
% Thực hiện nội suy tinh 
%   Input:  
%           * rough_deltaX: mảng các quãng đường di chuyển trên trục X sau khi nội suy thô
%           * rough_deltaY: mảng các quãng đường di chuyển trên trục Y sau khi nội suy thô
%           * Tipo: chu kỳ nội suy
%           * Tpos: chu kỳ điều khiển vị trí
%           * method: "linear" hoặc "average" là cách thức chia điểm nội suy tinh
%   Output:
%           * fine_deltaX: mảng các giá trị khoảng di chuyển trên trục X sau nội suy tinh
%           * fine_deltaY: mảng các giá trị khoảng di chuyển trên trục Y sau nội suy tinh
%           * t: mảng các giá trị thời gian đặt cho fine_deltaX và finedeltaY

    N = Tipo/Tpos;
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

        [aX, aY, t] = fine_interpolation(rough_deltaX, rough_deltaY, Tipo, Tpos, "linear");

        endCalculate = length(aX);

        aX( endCalculate : endCalculate + ceil(N/2) ) = 0; % thêm các giá trị cuối vào mảng aX, aY để đáp ứng đủ thêm ceil(N/2) giá trị
        aY( endCalculate : endCalculate + ceil(N/2) ) = 0;

        for j = abs(ceil(-N/2)) + 1 : endCalculate % tính toán dựa trên công thức nội suy tinh trung bình
            fine_deltaX(j) = 0.5*( mean( aX( j+ceil(-N/2+1) : j+ceil(N/2) ) ) + mean( aX( j+ceil(-N/2) : j+ceil(N/2-1) ) ) );
            fine_deltaY(j) = 0.5*( mean( aY( j+ceil(-N/2+1) : j+ceil(N/2) ) ) + mean( aY( j+ceil(-N/2) : j+ceil(N/2-1) ) ) );
        end

    else
    
        fprintf("Không có method %s", method);

    end

end

