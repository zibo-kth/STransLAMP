function k = wn(f)
% Calculate wavenumber for given frequency array
% Load acoustic parameters
acoustic_params = load_acoustic_parameters();
c0 = acoustic_params.c0;

% Calculate wavenumber directly from frequency
omega_vals = 2*pi*f;
k = omega_vals / c0;

end