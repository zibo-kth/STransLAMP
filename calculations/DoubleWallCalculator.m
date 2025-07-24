function results = DoubleWallCalculator(params)
    %% Double Wall Sound Transmission Loss Calculator
    % Calculates transmission loss for two parallel flat panels with air gap
    %
    % Input:
    %   params - structure containing:
    %     .panel1 - first panel parameters (material, thickness)
    %     .panel2 - second panel parameters (material, thickness)
    %     .gap_distance - distance between panels [m]
    %     .gap_stiffness - stiffness of air gap [N/m²] (optional)
    %     .freq_range - frequency vector [Hz]
    %     .incident_angle - incident angle [rad] (optional, default: pi/3)
    %
    % Output:
    %   results - structure containing transmission loss and component data
    
    % Load acoustic parameters
    acoustic_params = load_acoustic_parameters();
    
    % Set default values
    if ~isfield(params, 'incident_angle')
        params.incident_angle = pi/3;
    end
    if ~isfield(params, 'gap_stiffness')
        % Default air gap stiffness
        params.gap_stiffness = 5.6e5 * (1 + 1i*0.0);
    end
    
    % Calculate properties for panel 1
    m1 = params.panel1.material.density * params.panel1.thickness;
    D1 = params.panel1.material.youngs_modulus * params.panel1.thickness^3 / ...
         (12 * (1 - params.panel1.material.poisson_ratio^2));
    z1 = impedance_panel(params.freq_range, m1, D1);
    f_critical1 = fcritical(m1, D1);
    
    % Calculate properties for panel 2
    m2 = params.panel2.material.density * params.panel2.thickness;
    D2 = params.panel2.material.youngs_modulus * params.panel2.thickness^3 / ...
         (12 * (1 - params.panel2.material.poisson_ratio^2));
    z2 = impedance_panel(params.freq_range, m2, D2);
    f_critical2 = fcritical(m2, D2);
    
    % Calculate air gap properties
    s = params.gap_stiffness / params.gap_distance;
    za = @(theta) acoustic_params.rho0 * acoustic_params.c0 / cos(theta);
    
    % Calculate double wall resonance frequency
    freq_doublewallres = sqrt(s * (1/m1 + 1/m2)) / (2*pi);
    
    % Calculate double wall impedance
    zd = impedance_doublewall(params.freq_range, s, z1, z2, za);
    
    % Calculate transmission coefficients
    tau_oblique = tauOblique(zd, params.incident_angle);
    tau_diffuse = tauDiffuse(zd, pi/180, 0, 78*pi/180);
    
    % Calculate transmission loss
    stl_oblique = stl(tau_oblique);
    stl_diffuse = stl(tau_diffuse);
    
    % Individual panel transmission loss for comparison
    stl_panel1_oblique = stl(tauOblique(z1, params.incident_angle));
    stl_panel2_oblique = stl(tauOblique(z2, params.incident_angle));
    
    % Package results
    results.frequency = params.freq_range;
    results.transmission_loss_oblique = stl_oblique;
    results.transmission_loss_diffuse = stl_diffuse;
    results.transmission_loss_panel1 = stl_panel1_oblique;
    results.transmission_loss_panel2 = stl_panel2_oblique;
    
    % Component properties
    results.panel1.surface_density = m1;
    results.panel1.bending_stiffness = D1;
    results.panel1.critical_frequency = f_critical1;
    results.panel1.impedance = z1;
    results.panel1.thickness = params.panel1.thickness;
    
    results.panel2.surface_density = m2;
    results.panel2.bending_stiffness = D2;
    results.panel2.critical_frequency = f_critical2;
    results.panel2.impedance = z2;
    results.panel2.thickness = params.panel2.thickness;
    
    results.double_wall.impedance = zd;
    results.double_wall.resonance_frequency = freq_doublewallres;
    results.double_wall.gap_distance = params.gap_distance;
    results.double_wall.gap_stiffness = params.gap_stiffness;
    
    % Input parameters for reference
    results.incident_angle = params.incident_angle;
    results.panel1.material_name = params.panel1.material.name;
    results.panel2.material_name = params.panel2.material.name;
end
