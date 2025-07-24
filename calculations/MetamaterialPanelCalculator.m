function results = MetamaterialPanelCalculator(params)
    %% Metamaterial Panel Sound Transmission Loss Calculator
    % Uses user-specified host-dependent impedance formulations
    %
    % Input:
    %   params - structure containing:
    %     .host_type - 'single_panel', 'double_wall', 'curved_panel', 'curved_double_wall'
    %     .resonators - resonator parameters (resonance_frequency, mass_ratio)
    %     .freq_range - frequency vector [Hz]
    %     .incident_angle - incident angle [rad] (optional, default: pi/3)
    %     ... (other parameters depend on host_type)
    %
    % Output:
    %   results - structure containing transmission loss and component data
    
    % Load acoustic parameters
    acoustic_params = load_acoustic_parameters();
    rho0 = acoustic_params.rho0;
    c0 = acoustic_params.c0;
    
    % Set default values
    if ~isfield(params, 'incident_angle')
        params.incident_angle = pi/3;
    end
    
    theta = params.incident_angle;
    Ve_freq = params.freq_range(:);  % Ensure column vector
    Ve_omega = 2*pi*Ve_freq;
    
    % Resonator parameters
    delta = params.resonators.mass_ratio;
    f_res0 = params.resonators.resonance_frequency * (1 + 1i*0.08);  % Add damping as per user example
    
    % Calculate host-specific impedance and metamaterial effect
    switch params.host_type
        case 'single_panel'
            [Ve_STL_host, Ve_STL_meta, host_results] = calculate_single_panel_metamaterial(params, Ve_freq, Ve_omega, theta, delta, f_res0, rho0, c0);
            
        case 'curved_panel'
            [Ve_STL_host, Ve_STL_meta, host_results] = calculate_curved_panel_metamaterial(params, Ve_freq, Ve_omega, theta, delta, f_res0, rho0, c0);
            
        case 'double_wall'
            [Ve_STL_host, Ve_STL_meta, host_results] = calculate_double_wall_metamaterial(params, Ve_freq, Ve_omega, theta, delta, f_res0, rho0, c0);
            
        case 'curved_double_wall'
            [Ve_STL_host, Ve_STL_meta, host_results] = calculate_curved_double_wall_metamaterial(params, Ve_freq, Ve_omega, theta, delta, f_res0, rho0, c0);
            
        otherwise
            error('Unknown host panel type: %s', params.host_type);
    end
    
    % Package results using host-specific calculations
    results.frequency = Ve_freq;
    results.transmission_loss_oblique = Ve_STL_meta;  % Metamaterial STL
    results.transmission_loss_diffuse = Ve_STL_meta;  % Same for now (oblique only implemented)
    
    % Host panel results (for comparison)
    results.base_panel.transmission_loss_oblique = Ve_STL_host;
    results.base_panel.transmission_loss_diffuse = Ve_STL_host;
    
    % Copy host-specific results
    if exist('host_results', 'var')
        results.host_results = host_results;
    end
    
    % Metamaterial properties
    results.resonators.resonance_frequency = params.resonators.resonance_frequency;
    results.resonators.mass_ratio = delta;
    results.resonators.complex_resonance = f_res0;
    
    % Performance improvement
    results.improvement.max_improvement_oblique = max(Ve_STL_meta - Ve_STL_host);
    results.improvement.avg_improvement_oblique = mean(Ve_STL_meta - Ve_STL_host);
    
    % Host type
    results.host_type = params.host_type;
    results.incident_angle = theta;
end

function [Ve_STL_host, Ve_STL_meta, host_results] = calculate_single_panel_metamaterial(params, Ve_freq, Ve_omega, theta, delta, f_res0, rho0, c0)
    %% Single panel metamaterial calculation
    
    % Panel properties
    m = params.material.density * params.thickness;
    D = params.material.youngs_modulus * params.thickness^3 / (12 * (1 - params.material.poisson_ratio^2));
    f_critical = fcritical(m, D);
    
    % Host impedance (single panel)
    Ve_Z = 1i .* Ve_omega .* m .* (1 - (Ve_freq./f_critical).^2 .* sin(theta)^4);
    
    % Resonator equivalent impedance
    Ve_Z_eq = 1i .* Ve_omega .* m .* delta .* (1 ./ (1 - Ve_freq.^2 ./ f_res0^2));
    
    % Combined metamaterial impedance
    Ve_Z_eff = Ve_Z + Ve_Z_eq;
    
    % Transmission coefficients and STL
    Ve_tau_host = abs(1 + Ve_Z .* cos(theta) ./ (2 * rho0 * c0)).^(-2);
    Ve_tau_meta = abs(1 + Ve_Z_eff .* cos(theta) ./ (2 * rho0 * c0)).^(-2);
    
    Ve_STL_host = -10 * log10(Ve_tau_host);
    Ve_STL_meta = -10 * log10(Ve_tau_meta);
    
    % Host results for reference
    host_results.material_name = params.material.name;
    host_results.thickness = params.thickness;
    host_results.critical_frequency = f_critical;
end

function [Ve_STL_host, Ve_STL_meta, host_results] = calculate_curved_panel_metamaterial(params, Ve_freq, Ve_omega, theta, delta, f_res0, rho0, c0)
    %% Curved panel metamaterial calculation using user's exact formulation
    
    % Panel properties
    m = params.material.density * params.thickness;
    D = params.material.youngs_modulus * params.thickness^3 / (12 * (1 - params.material.poisson_ratio^2));
    f_critical = fcritical(m, D);
    f_ring = fring(params.material.youngs_modulus, params.material.poisson_ratio, params.material.density, params.radius);
    
    % Host impedance (curved panel) - user's exact formula
    Ve_Z = 1i .* Ve_omega .* m .* (1 - (Ve_freq./f_critical).^2 .* sin(theta)^4 - (f_ring./Ve_freq).^2);
    
    % Resonator equivalent impedance
    Ve_Z_eq = 1i .* Ve_omega .* m .* delta .* (1 ./ (1 - Ve_freq.^2 ./ f_res0^2));
    
    % Combined metamaterial impedance
    Ve_Z_eff = Ve_Z + Ve_Z_eq;
    
    % Transmission coefficients and STL - user's exact formulation
    Ve_tau = abs(1 + Ve_Z .* cos(theta) ./ (2 * rho0 * c0)).^(-2);
    Ve_tau_simplified_meta = abs(1 + Ve_Z_eff .* cos(theta) ./ (2 * rho0 * c0)).^(-2);
    
    Ve_STL_host = -10 * log10(Ve_tau);  % Ve_STL_curved
    Ve_STL_meta = -10 * log10(Ve_tau_simplified_meta);  % Ve_STL_Koval_simplified_meta
    
    % Host results for reference
    host_results.material_name = params.material.name;
    host_results.thickness = params.thickness;
    host_results.radius = params.radius;
    host_results.critical_frequency = f_critical;
    host_results.ring_frequency = f_ring;
end

function [Ve_STL_host, Ve_STL_meta, host_results] = calculate_double_wall_metamaterial(params, Ve_freq, Ve_omega, theta, delta, f_res0, rho0, c0)
    %% Double wall metamaterial calculation using user's exact formulation
    
    % Panel properties
    m1 = params.panel1.material.density * params.panel1.thickness;
    m2 = params.panel2.material.density * params.panel2.thickness;
    D1 = params.panel1.material.youngs_modulus * params.panel1.thickness^3 / (12 * (1 - params.panel1.material.poisson_ratio^2));
    D2 = params.panel2.material.youngs_modulus * params.panel2.thickness^3 / (12 * (1 - params.panel2.material.poisson_ratio^2));
    
    f_critical1 = fcritical(m1, D1);
    f_critical2 = fcritical(m2, D2);
    
    % Use combined mass for resonator calculation
    m = m1 + m2;
    
    % Host panel impedances (single panels)
    Ve_Z = 1i .* Ve_omega .* m1 .* (1 - (Ve_freq./f_critical1).^2 .* sin(theta)^4);
    
    % Resonator equivalent impedance
    Ve_Z_eq = 1i .* Ve_omega .* m .* delta .* (1 ./ (1 - Ve_freq.^2 ./ f_res0^2));
    
    % Panel impedances for double wall - user's exact formulation
    Ve_Z1 = Ve_Z + Ve_Z_eq;  % Panel 1 with metamaterial
    Ve_Z2 = Ve_Z;            % Panel 2 without metamaterial
    
    % Double wall parameters
    Zc = rho0 * c0 / cos(theta);
    d = params.gap_distance;
    Stiffness = 5.6e5 * (1 + 1i*0.0);  % [N/m^3] - user's value
    s = Stiffness / d;
    
    % Double wall impedances - user's exact formulation
    Ve_Z_doublewall = (Ve_Z1 + Ve_Z2 + 1i .* Ve_omega ./ s .* (Ve_Z1 + Zc) .* (Ve_Z2 + Zc));
    Ve_Z_doublewall_host = (Ve_Z + Ve_Z + 1i .* Ve_omega ./ s .* (Ve_Z + Zc) .* (Ve_Z + Zc));
    
    % Transmission coefficients - user's exact formulation
    Ve_coefficient = 1 + 1 ./ (2 * Zc) .* Ve_Z_doublewall;
    Ve_coefficient_host = 1 + 1 ./ (2 * Zc) .* Ve_Z_doublewall_host;
    
    Ve_tau = abs(Ve_coefficient).^(-2);
    Ve_tau_host = abs(Ve_coefficient_host).^(-2);
    
    Ve_STL_meta = 10 * log10(1 ./ Ve_tau);
    Ve_STL_host = 10 * log10(1 ./ Ve_tau_host);
    
    % Host results for reference
    host_results.panel1.material_name = params.panel1.material.name;
    host_results.panel2.material_name = params.panel2.material.name;
    host_results.panel1.thickness = params.panel1.thickness;
    host_results.panel2.thickness = params.panel2.thickness;
    host_results.gap_distance = params.gap_distance;
    host_results.resonance_frequency = sqrt(s * (1/m1 + 1/m2)) / (2*pi);
end

function [Ve_STL_host, Ve_STL_meta, host_results] = calculate_curved_double_wall_metamaterial(params, Ve_freq, Ve_omega, theta, delta, f_res0, rho0, c0)
    %% Curved double wall metamaterial calculation
    % Combines curved panel and double wall formulations
    
    % Panel properties
    m1 = params.panel1.material.density * params.panel1.thickness;
    m2 = params.panel2.material.density * params.panel2.thickness;
    D1 = params.panel1.material.youngs_modulus * params.panel1.thickness^3 / (12 * (1 - params.panel1.material.poisson_ratio^2));
    D2 = params.panel2.material.youngs_modulus * params.panel2.thickness^3 / (12 * (1 - params.panel2.material.poisson_ratio^2));
    
    f_critical1 = fcritical(m1, D1);
    f_critical2 = fcritical(m2, D2);
    f_ring1 = fring(params.panel1.material.youngs_modulus, params.panel1.material.poisson_ratio, params.panel1.material.density, params.panel1.radius);
    f_ring2 = fring(params.panel2.material.youngs_modulus, params.panel2.material.poisson_ratio, params.panel2.material.density, params.panel2.radius);
    
    % Use combined mass for resonator calculation
    m = m1 + m2;
    
    % Host curved panel impedance
    Ve_Z1_curved = 1i .* Ve_omega .* m1 .* (1 - (Ve_freq./f_critical1).^2 .* sin(theta)^4 - (f_ring1./Ve_freq).^2);
    Ve_Z2_curved = 1i .* Ve_omega .* m2 .* (1 - (Ve_freq./f_critical2).^2 .* sin(theta)^4 - (f_ring2./Ve_freq).^2);
    
    % Resonator equivalent impedance
    Ve_Z_eq = 1i .* Ve_omega .* m .* delta .* (1 ./ (1 - Ve_freq.^2 ./ f_res0^2));
    
    % Panel impedances for curved double wall
    Ve_Z1 = Ve_Z1_curved + Ve_Z_eq;  % Panel 1 with metamaterial
    Ve_Z2 = Ve_Z2_curved;            % Panel 2 without metamaterial
    
    % Double wall parameters
    Zc = rho0 * c0 / cos(theta);
    d = params.gap_distance;
    Stiffness = 5.6e5 * (1 + 1i*0.0);
    s = Stiffness / d;
    
    % Curved double wall impedances
    Ve_Z_doublewall = (Ve_Z1 + Ve_Z2 + 1i .* Ve_omega ./ s .* (Ve_Z1 + Zc) .* (Ve_Z2 + Zc));
    Ve_Z_doublewall_host = (Ve_Z1_curved + Ve_Z2_curved + 1i .* Ve_omega ./ s .* (Ve_Z1_curved + Zc) .* (Ve_Z2_curved + Zc));
    
    % Transmission coefficients
    Ve_coefficient = 1 + 1 ./ (2 * Zc) .* Ve_Z_doublewall;
    Ve_coefficient_host = 1 + 1 ./ (2 * Zc) .* Ve_Z_doublewall_host;
    
    Ve_tau = abs(Ve_coefficient).^(-2);
    Ve_tau_host = abs(Ve_coefficient_host).^(-2);
    
    Ve_STL_meta = 10 * log10(1 ./ Ve_tau);
    Ve_STL_host = 10 * log10(1 ./ Ve_tau_host);
    
    % Host results for reference
    host_results.panel1.material_name = params.panel1.material.name;
    host_results.panel2.material_name = params.panel2.material.name;
    host_results.panel1.thickness = params.panel1.thickness;
    host_results.panel2.thickness = params.panel2.thickness;
    host_results.panel1.radius = params.panel1.radius;
    host_results.panel2.radius = params.panel2.radius;
    host_results.gap_distance = params.gap_distance;
end
