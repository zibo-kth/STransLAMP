

rho0 = 1.2;
c0 = 343;
zc = rho0*c0; % characteristic impedance
% theta = pi/3; % incident angle

f = [20:1:10000]';
omega = 2*pi*f;
k = omega./c0;
% Ve_k_trace = k.*sin(theta);