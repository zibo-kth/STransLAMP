function acoustic_params = load_acoustic_parameters()
    %% Load Acoustic Parameters
    % Returns standard acoustic parameters for air at room temperature
    %
    % Output:
    %   acoustic_params - structure containing:
    %     .rho0 - air density [kg/m³]
    %     .c0 - speed of sound in air [m/s]
    %     .zc - characteristic impedance of air [Pa⋅s/m]
    %     .frequency - default frequency vector [Hz]
    %     .omega - angular frequency vector [rad/s]
    %     .k - wavenumber vector [1/m]
    
    % Standard air properties at 20°C, 1 atm
    acoustic_params.rho0 = 1.2;        % kg/m³
    acoustic_params.c0 = 343;          % m/s
    acoustic_params.zc = acoustic_params.rho0 * acoustic_params.c0;  % Pa⋅s/m
    
    % Default frequency range
    acoustic_params.frequency = (20:1:10000)';  % Hz
    acoustic_params.omega = 2 * pi * acoustic_params.frequency;  % rad/s
    acoustic_params.k = acoustic_params.omega / acoustic_params.c0;  % 1/m
end
