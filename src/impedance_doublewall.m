function z = impedance_doublewall(f, s, z1, z2, za)

parameter_pressure_acoustics

% za = @(theta) rho0*c0/cos(theta);
% d = 40e-3; % distance of two wall
% Stiffness = 5.6e5*(1+1i*0.0); % [N/m^2]
% s = Stiffness/d; % s = c0^2*rho0/d;

z = @(theta) z1(theta) + z2(theta) + 1i.*2.*pi.*f./s.*(z1(theta) + za(theta)).*(z2(theta) + za(theta));

end