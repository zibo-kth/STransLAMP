function kappa = kappa(f, m, D)
%%%% input: m: surface density, D bending stiffness, 
%%%% this function reture the bending wavenumber of a panel

%     parameter_pressure_acoustics

    kappa = (omega(f).^2.*m./D).^(1/4);

end