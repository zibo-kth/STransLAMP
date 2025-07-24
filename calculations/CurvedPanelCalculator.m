function results = CurvedPanelCalculator(params)
    %% Curved Panel Sound Transmission Loss Calculator
    % Calculates transmission loss for a single curved panel (cylindrical shell)
    %
    % Input:
    %   params - structure containing:
    %     .material - material properties structure
    %     .thickness - panel thickness [m]
    %     .radius - radius of curvature [m]
    %     .freq_range - frequency vector [Hz]
    %     .incident_angle - incident angle [rad] (optional, default: pi/3)
    %
    % Output:
    %   results - structure containing transmission loss and panel properties
    
    % Load acoustic parameters
    acoustic_params = load_acoustic_parameters();
    
    % Set default incident angle if not provided
    if ~isfield(params, 'incident_angle')
        params.incident_angle = pi/3; % 60 degrees
    end
    
    % Calculate panel properties
    surface_density = params.material.density * params.thickness;
    bending_stiffness = params.material.youngs_modulus * params.thickness^3 / ...
                       (12 * (1 - params.material.poisson_ratio^2));
    
    % Calculate critical frequency (flat panel reference)
    critical_freq = fcritical(surface_density, bending_stiffness);
    
    % Calculate ring frequency for curved panel
    ring_freq = fring(params.material.youngs_modulus_real, ...
                     params.material.poisson_ratio, ...
                     params.material.density, ...
                     params.radius);
    
    % Calculate flat panel impedance (for comparison)
    panel_impedance_flat = impedance_panel(params.freq_range, surface_density, bending_stiffness);
    
    % Calculate curved panel (shell) impedance
    panel_impedance_curved = impedance_shell(params.freq_range, ...
                                           params.material.youngs_modulus_real, ...
                                           params.material.poisson_ratio, ...
                                           params.material.density, ...
                                           params.radius, ...
                                           surface_density, ...
                                           bending_stiffness);
    
    % Calculate transmission coefficients for flat panel (reference)
    tau_flat_oblique = tauOblique(panel_impedance_flat, params.incident_angle);
    tau_flat_diffuse = tauDiffuse(panel_impedance_flat, pi/180, 0, 78*pi/180);
    
    % Calculate transmission coefficients for curved panel
    tau_curved_oblique = tauOblique(panel_impedance_curved, params.incident_angle);
    tau_curved_diffuse = tauDiffuse(panel_impedance_curved, pi/180, 0, 78*pi/180);
    
    % Calculate transmission loss
    stl_flat_oblique = stl(tau_flat_oblique);
    stl_flat_diffuse = stl(tau_flat_diffuse);
    stl_curved_oblique = stl(tau_curved_oblique);
    stl_curved_diffuse = stl(tau_curved_diffuse);
    
    % Package results
    results.frequency = params.freq_range;
    
    % Curved panel results (primary)
    results.transmission_loss_oblique = stl_curved_oblique;
    results.transmission_loss_diffuse = stl_curved_diffuse;
    results.impedance = panel_impedance_curved;
    
    % Flat panel results (for comparison)
    results.flat_panel.transmission_loss_oblique = stl_flat_oblique;
    results.flat_panel.transmission_loss_diffuse = stl_flat_diffuse;
    results.flat_panel.impedance = panel_impedance_flat;
    
    % Panel properties
    results.critical_frequency = critical_freq;
    results.ring_frequency = ring_freq;
    results.surface_density = surface_density;
    results.bending_stiffness = bending_stiffness;
    results.radius = params.radius;
    results.incident_angle = params.incident_angle;
    
    % Material information for reference
    results.material_name = params.material.name;
    results.thickness = params.thickness;
end
