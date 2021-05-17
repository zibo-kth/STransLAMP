function Ve_STL = fun_stl(tau)
%%% this function return the sound transmission loss for the incident angle
%%% theta = pi/3

% parameter_pressure_acoustics
% Ve_tau = abs(1+Ve_Z*cos(theta)/2/rho0/c0).^(-2);
Ve_STL = -10*log10(tau);

end
