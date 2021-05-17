function fri = fring(E0, nu, rho, R)

%%% this function reture the ring frequency of the panel
parameter_pressure_acoustics

fri = sqrt(E0/rho/(1-nu^2))/(2*pi*R);


end