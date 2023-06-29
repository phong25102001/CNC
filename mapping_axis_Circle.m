function [delta_x, delta_y] = mapping_axis_Circle(R, phi_start, phi)
% [delta_x, delta_y] = mapping_axis_Circle(R, phi_start, phi)
% Chiếu chuyển động lên các trục x và y 
%   Input:  
%           * R: Bán kính cung tròn
%           * phi: Mảng các góc đặt cho cung tròn
%   Output: 
%           * delta_x: mảng các giá trị quãng đường di chuyển theo trục x(mm)
%           * delta_y: mảng các giá trị quãng đường di chuyển theo trục y(mm)

    for i = 1:length(phi)-1
        delta_x(i) = abs(R)*( cos( phi_start + sum(phi(1:i+1) ) ) - cos( phi_start + sum(phi(1:i)) ) );
        delta_y(i) = abs(R)*( sin( phi_start + sum(phi(1:i+1) ) ) - sin( phi_start + sum(phi(1:i)) ) );
    end

    delta_x(length(phi)) = 0;
    delta_y(length(phi)) = 0;

end

