function tau = tauOblique(z, theta)
%%% this function reture the transmission coefficient of a panel under the
%%% impedance z for the angle of theta

    parameter_pressure_acoustics
    
    tau = abs(1+z(theta)*cos(theta)/2/zc).^(-2);


end