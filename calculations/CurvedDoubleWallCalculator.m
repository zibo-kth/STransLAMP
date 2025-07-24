function results = CurvedDoubleWallCalculator(params)
    %% Curved Double Wall Sound Transmission Loss Calculator
    % Calculates transmission loss for two parallel curved panels with air gap
    %
    % Input:
    %   params - structure containing:
    %     .panel1 - first curved panel parameters (material, thickness, radius)
    %     .panel2 - second curved panel parameters (material, thickness, radius)
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
    
    % Calculate properties for curved panel 1
    m1 = params.panel1.material.density * params.panel1.thickness;
    D1 = params.panel1.material.youngs_modulus * params.panel1.thickness^3 / ...
         (12 * (1 - params.panel1.material.poisson_ratio^2));
    
    % Flat panel impedance (reference)
    z1_flat = impedance_panel(params.freq_range, m1, D1);
    
    % Curved panel impedance
    z1_curved = impedance_shell(params.freq_range, ...
                               params.panel1.material.youngs_modulus_real, ...
                               params.panel1.material.poisson_ratio, ...
                               params.panel1.material.density, ...
                               params.panel1.radius, ...
                               m1, D1);
    
    f_critical1 = fcritical(m1, D1);
    f_ring1 = fring(params.panel1.material.youngs_modulus_real, ...
                   params.panel1.material.poisson_ratio, ...
                   params.panel1.material.density, ...
                   params.panel1.radius);
    
    % Calculate properties for curved panel 2
    m2 = params.panel2.material.density * params.panel2.thickness;
    D2 = params.panel2.material.youngs_modulus * params.panel2.thickness^3 / ...
         (12 * (1 - params.panel2.material.poisson_ratio^2));
    
    % Flat panel impedance (reference)
    z2_flat = impedance_panel(params.freq_range, m2, D2);
    
    % Curved panel impedance
    z2_curved = impedance_shell(params.freq_range, ...
                               params.panel2.material.youngs_modulus_real, ...
                               params.panel2.material.poisson_ratio, ...
                               params.panel2.material.density, ...
                               params.panel2.radius, ...
                               m2, D2);
    
    f_critical2 = fcritical(m2, D2);
    f_ring2 = fring(params.panel2.material.youngs_modulus_real, ...
                   params.panel2.material.poisson_ratio, ...
                   params.panel2.material.density, ...
                   params.panel2.radius);
    
    % Calculate air gap properties
    s = params.gap_stiffness / params.gap_distance;
    za = @(theta) acoustic_params.rho0 * acoustic_params.c0 / cos(theta);
    
    % Calculate double wall resonance frequency
    freq_doublewallres = sqrt(s * (1/m1 + 1/m2)) / (2*pi);
    
    % Calculate double wall impedances
    zd_flat = impedance_doublewall(params.freq_range, s, z1_flat, z2_flat, za);
    zd_curved = impedance_doublewall(params.freq_range, s, z1_curved, z2_curved, za);
    
    % Calculate transmission coefficients for flat double wall (reference)
    tau_flat_oblique = tauOblique(zd_flat, params.incident_angle);
    tau_flat_diffuse = tauDiffuse(zd_flat, pi/180, 0, 78*pi/180);
    
    % Calculate transmission coefficients for curved double wall
    tau_curved_oblique = tauOblique(zd_curved, params.incident_angle);
    tau_curved_diffuse = tauDiffuse(zd_curved, pi/180, 0, 78*pi/180);
    
    % Calculate transmission loss
    stl_flat_oblique = stl(tau_flat_oblique);
    stl_flat_diffuse = stl(tau_flat_diffuse);
    stl_curved_oblique = stl(tau_curved_oblique);
    stl_curved_diffuse = stl(tau_curved_diffuse);
    
    % Individual curved panel transmission loss
    stl_panel1_oblique = stl(tauOblique(z1_curved, params.incident_angle));
    stl_panel2_oblique = stl(tauOblique(z2_curved, params.incident_angle));
    
    % Package results
    results.frequency = params.freq_range;
    
    % Primary results (curved double wall)
    results.transmission_loss_oblique = stl_curved_oblique;
    results.transmission_loss_diffuse = stl_curved_diffuse;
    results.transmission_loss_panel1 = stl_panel1_oblique;
    results.transmission_loss_panel2 = stl_panel2_oblique;
    
    % Flat double wall results (for comparison)
    results.flat_double_wall.transmission_loss_oblique = stl_flat_oblique;
    results.flat_double_wall.transmission_loss_diffuse = stl_flat_diffuse;
    results.flat_double_wall.impedance = zd_flat;
    
    % Panel 1 properties
    results.panel1.surface_density = m1;
    results.panel1.bending_stiffness = D1;
    results.panel1.critical_frequency = f_critical1;
    results.panel1.ring_frequency = f_ring1;
    results.panel1.impedance_flat = z1_flat;
    results.panel1.impedance_curved = z1_curved;
    results.panel1.radius = params.panel1.radius;
    results.panel1.thickness = params.panel1.thickness;
    
    % Panel 2 properties
    results.panel2.surface_density = m2;
    results.panel2.bending_stiffness = D2;
    results.panel2.critical_frequency = f_critical2;
    results.panel2.ring_frequency = f_ring2;
    results.panel2.impedance_flat = z2_flat;
    results.panel2.impedance_curved = z2_curved;
    results.panel2.radius = params.panel2.radius;
    results.panel2.thickness = params.panel2.thickness;
    
    % Double wall properties
    results.double_wall.impedance = zd_curved;
    results.double_wall.resonance_frequency = freq_doublewallres;
    results.double_wall.gap_distance = params.gap_distance;
    results.double_wall.gap_stiffness = params.gap_stiffness;
    
    % Input parameters for reference
    results.incident_angle = params.incident_angle;
    results.panel1.material_name = params.panel1.material.name;
    results.panel2.material_name = params.panel2.material.name;
end
