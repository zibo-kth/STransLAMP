function fcr = fcritical(m, D)

%%% this function reture the critical frequency of the panel
parameter_pressure_acoustics

fcr = c0^2/2/pi*(m/D)^(1/2);


end