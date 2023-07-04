function [delta_x, delta_y] = ADCBI_mapping_axis_Circle(R, phi_start, delta_phi)
% [delta_x, delta_y] = ADCBI_mapping_axis_Circle(R, phi_start, delta_phi)
% Chiếu chuyển động tròn lên các trục x và y 
%   Input:  
%           * R: Bán kính cung tròn (mm) 
%           * phi_start: Góc bắt đầu của cung tròn nội suy (rad)
%           * delta_phi: Mảng các góc di chuyển trong từng bước nội suy (rad)
%   Output: 
%           * delta_x, delta_y: Mảng các giá trị quãng đường di chuyển theo trục x, y theo từng bước nội suy (mm, mm)

    % thực hiện tính toán các giá trị quãng đường cho từng bước nội suy
    for i = 1:length(delta_phi)-1
        delta_x(i) = abs(R)*( cos( phi_start + sum(delta_phi(1:i+1) ) ) - cos( phi_start + sum(delta_phi(1:i)) ) );
        delta_y(i) = abs(R)*( sin( phi_start + sum(delta_phi(1:i+1) ) ) - sin( phi_start + sum(delta_phi(1:i)) ) );
    end

    % thêm các giá trị cuối để cùng số điểm nội suy với mảng thời điểm nội suy
    delta_x(length(delta_phi)) = 0;
    delta_y(length(delta_phi)) = 0;

end

