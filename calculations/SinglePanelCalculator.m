function results = SinglePanelCalculator(params)
    %% Single Panel Sound Transmission Loss Calculator
    % Calculates transmission loss for a single flat panel
    %
    % Input:
    %   params - structure containing:
    %     .material - material properties structure
    %     .thickness - panel thickness [m]
    %     .freq_range - frequency vector [Hz]
    %     .incident_angle - incident angle [rad] (optional, default: pi/3)
    %
    % Output:
    %   results - structure containing:
    %     .frequency - frequency vector [Hz]
    %     .transmission_loss - transmission loss [dB]
    %     .impedance - panel impedance
    %     .critical_frequency - critical frequency [Hz]
    %     .surface_density - surface density [kg/m²]
    %     .bending_stiffness - bending stiffness [N⋅m]
    
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
    
    % Calculate critical frequency
    critical_freq = fcritical(surface_density, bending_stiffness);
    
    % Calculate panel impedance
    panel_impedance = impedance_panel(params.freq_range, surface_density, bending_stiffness);
    
    % Calculate transmission coefficient for oblique incidence
    tau_oblique = tauOblique(panel_impedance, params.incident_angle);
    
    % Calculate transmission coefficient for diffuse field
    tau_diffuse = tauDiffuse(panel_impedance, pi/180, 0, 78*pi/180);
    
    % Calculate transmission loss
    stl_oblique = stl(tau_oblique);
    stl_diffuse = stl(tau_diffuse);
    
    % Package results
    results.frequency = params.freq_range;
    results.transmission_loss_oblique = stl_oblique;
    results.transmission_loss_diffuse = stl_diffuse;
    results.impedance = panel_impedance;
    results.critical_frequency = critical_freq;
    results.surface_density = surface_density;
    results.bending_stiffness = bending_stiffness;
    results.incident_angle = params.incident_angle;
    
    % Add material information for reference
    results.material_name = params.material.name;
    results.thickness = params.thickness;
end
