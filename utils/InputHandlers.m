function varargout = InputHandlers(varargin)
    %% Input Handler Functions for STransLAMP
    % Collection of functions to handle user input for different calculation types
    %
    % Usage:
    %   params = InputHandlers('single_panel')
    %   params = InputHandlers('double_wall')
    %   params = InputHandlers('curved_panel')
    %   params = InputHandlers('curved_double_wall')
    
    if nargin == 0
        error('InputHandlers requires a function name as input');
    end
    
    func_name = varargin{1};
    
    switch lower(func_name)
        case 'single_panel'
            varargout{1} = get_single_panel_inputs();
        case 'double_wall'
            varargout{1} = get_double_wall_inputs();
        case 'curved_panel'
            varargout{1} = get_curved_panel_inputs();
        case 'curved_double_wall'
            varargout{1} = get_curved_double_wall_inputs();
        case 'metamaterial_panel'
            varargout{1} = get_metamaterial_panel_inputs();
        otherwise
            error('Unknown input handler: %s', func_name);
    end
end

function params = get_single_panel_inputs()
    %% Get user inputs for single panel calculation
    fprintf('\n--- Single Panel Parameters ---\n');
    
    % Material selection
    fprintf('\nSelect material:\n');
    MaterialDatabase('list');
    material_name = input('Enter material name (or ''custom'' for custom material): ', 's');
    params.material = MaterialDatabase(material_name);
    
    % Panel thickness
    params.thickness = input('Enter panel thickness [mm]: ') * 1e-3; % Convert to meters
    
    % Frequency range
    fprintf('\nFrequency range options:\n');
    fprintf('1. Default (20-10000 Hz)\n');
    fprintf('2. Custom range\n');
    freq_choice = input('Choose frequency range (1 or 2): ');
    
    if freq_choice == 2
        f_min = input('Enter minimum frequency [Hz]: ');
        f_max = input('Enter maximum frequency [Hz]: ');
        f_step = input('Enter frequency step [Hz] (default: 1): ');
        if isempty(f_step)
            f_step = 1;
        end
        params.freq_range = (f_min:f_step:f_max)';
    else
        params.freq_range = (20:1:10000)';
    end
    
    % Incident angle
    angle_deg = input('Enter incident angle [degrees] (default: 60): ');
    if isempty(angle_deg)
        angle_deg = 60;
    end
    params.incident_angle = angle_deg * pi/180;
    
    fprintf('\nSingle panel parameters configured successfully!\n');
end

function params = get_double_wall_inputs()
    %% Get user inputs for double wall calculation
    fprintf('\n--- Double Wall Parameters ---\n');
    
    % Panel 1
    fprintf('\n=== PANEL 1 ===\n');
    fprintf('Select material for panel 1:\n');
    MaterialDatabase('list');
    material_name1 = input('Enter material name for panel 1: ', 's');
    params.panel1.material = MaterialDatabase(material_name1);
    params.panel1.thickness = input('Enter panel 1 thickness [mm]: ') * 1e-3;
    
    % Panel 2
    fprintf('\n=== PANEL 2 ===\n');
    fprintf('Select material for panel 2:\n');
    MaterialDatabase('list');
    material_name2 = input('Enter material name for panel 2: ', 's');
    params.panel2.material = MaterialDatabase(material_name2);
    params.panel2.thickness = input('Enter panel 2 thickness [mm]: ') * 1e-3;
    
    % Gap properties
    fprintf('\n=== GAP PROPERTIES ===\n');
    params.gap_distance = input('Enter gap distance [mm]: ') * 1e-3;
    
    fprintf('Gap stiffness options:\n');
    fprintf('1. Default air gap (5.6e5 N/m²)\n');
    fprintf('2. Custom stiffness\n');
    stiffness_choice = input('Choose gap stiffness (1 or 2): ');
    
    if stiffness_choice == 2
        stiffness_real = input('Enter gap stiffness real part [N/m²]: ');
        stiffness_imag = input('Enter gap stiffness imaginary part [N/m²] (default: 0): ');
        if isempty(stiffness_imag)
            stiffness_imag = 0;
        end
        params.gap_stiffness = stiffness_real * (1 + 1i * stiffness_imag);
    else
        params.gap_stiffness = 5.6e5 * (1 + 1i * 0.0);
    end
    
    % Frequency range
    fprintf('\nFrequency range options:\n');
    fprintf('1. Default (20-10000 Hz)\n');
    fprintf('2. Custom range\n');
    freq_choice = input('Choose frequency range (1 or 2): ');
    
    if freq_choice == 2
        f_min = input('Enter minimum frequency [Hz]: ');
        f_max = input('Enter maximum frequency [Hz]: ');
        f_step = input('Enter frequency step [Hz] (default: 1): ');
        if isempty(f_step)
            f_step = 1;
        end
        params.freq_range = (f_min:f_step:f_max)';
    else
        params.freq_range = (20:1:10000)';
    end
    
    % Incident angle
    angle_deg = input('Enter incident angle [degrees] (default: 60): ');
    if isempty(angle_deg)
        angle_deg = 60;
    end
    params.incident_angle = angle_deg * pi/180;
    
    fprintf('\nDouble wall parameters configured successfully!\n');
end

function params = get_curved_panel_inputs()
    %% Get user inputs for curved panel calculation
    fprintf('\n--- Curved Panel Parameters ---\n');
    
    % Material selection
    fprintf('\nSelect material:\n');
    MaterialDatabase('list');
    material_name = input('Enter material name (or ''custom'' for custom material): ', 's');
    params.material = MaterialDatabase(material_name);
    
    % Panel properties
    params.thickness = input('Enter panel thickness [mm]: ') * 1e-3;
    params.radius = input('Enter radius of curvature [m]: ');
    
    % Frequency range
    fprintf('\nFrequency range options:\n');
    fprintf('1. Default (20-10000 Hz)\n');
    fprintf('2. Custom range\n');
    freq_choice = input('Choose frequency range (1 or 2): ');
    
    if freq_choice == 2
        f_min = input('Enter minimum frequency [Hz]: ');
        f_max = input('Enter maximum frequency [Hz]: ');
        f_step = input('Enter frequency step [Hz] (default: 1): ');
        if isempty(f_step)
            f_step = 1;
        end
        params.freq_range = (f_min:f_step:f_max)';
    else
        params.freq_range = (20:1:10000)';
    end
    
    % Incident angle
    angle_deg = input('Enter incident angle [degrees] (default: 60): ');
    if isempty(angle_deg)
        angle_deg = 60;
    end
    params.incident_angle = angle_deg * pi/180;
    
    fprintf('\nCurved panel parameters configured successfully!\n');
end

function params = get_curved_double_wall_inputs()
    %% Get user inputs for curved double wall calculation
    fprintf('\n--- Curved Double Wall Parameters ---\n');
    
    % Panel 1
    fprintf('\n=== CURVED PANEL 1 ===\n');
    fprintf('Select material for panel 1:\n');
    MaterialDatabase('list');
    material_name1 = input('Enter material name for panel 1: ', 's');
    params.panel1.material = MaterialDatabase(material_name1);
    params.panel1.thickness = input('Enter panel 1 thickness [mm]: ') * 1e-3;
    params.panel1.radius = input('Enter panel 1 radius of curvature [m]: ');
    
    % Panel 2
    fprintf('\n=== CURVED PANEL 2 ===\n');
    fprintf('Select material for panel 2:\n');
    MaterialDatabase('list');
    material_name2 = input('Enter material name for panel 2: ', 's');
    params.panel2.material = MaterialDatabase(material_name2);
    params.panel2.thickness = input('Enter panel 2 thickness [mm]: ') * 1e-3;
    params.panel2.radius = input('Enter panel 2 radius of curvature [m]: ');
    
    % Gap properties
    fprintf('\n=== GAP PROPERTIES ===\n');
    params.gap_distance = input('Enter gap distance [mm]: ') * 1e-3;
    
    fprintf('Gap stiffness options:\n');
    fprintf('1. Default air gap (5.6e5 N/m²)\n');
    fprintf('2. Custom stiffness\n');
    stiffness_choice = input('Choose gap stiffness (1 or 2): ');
    
    if stiffness_choice == 2
        stiffness_real = input('Enter gap stiffness real part [N/m²]: ');
        stiffness_imag = input('Enter gap stiffness imaginary part [N/m²] (default: 0): ');
        if isempty(stiffness_imag)
            stiffness_imag = 0;
        end
        params.gap_stiffness = stiffness_real * (1 + 1i * stiffness_imag);
    else
        params.gap_stiffness = 5.6e5 * (1 + 1i * 0.0);
    end
    
    % Frequency range
    fprintf('\nFrequency range options:\n');
    fprintf('1. Default (20-10000 Hz)\n');
    fprintf('2. Custom range\n');
    freq_choice = input('Choose frequency range (1 or 2): ');
    
    if freq_choice == 2
        f_min = input('Enter minimum frequency [Hz]: ');
        f_max = input('Enter maximum frequency [Hz]: ');
        f_step = input('Enter frequency step [Hz] (default: 1): ');
        if isempty(f_step)
            f_step = 1;
        end
        params.freq_range = (f_min:f_step:f_max)';
    else
        params.freq_range = (20:1:10000)';
    end
    
    % Incident angle
    angle_deg = input('Enter incident angle [degrees] (default: 60): ');
    if isempty(angle_deg)
        angle_deg = 60;
    end
    params.incident_angle = angle_deg * pi/180;
    
    fprintf('\nCurved double wall parameters configured successfully!\n');
end

function params = get_metamaterial_panel_inputs()
    %% Get user inputs for metamaterial panel calculation
    fprintf('\n--- Metamaterial Panel Parameters ---\n');
    
    % Host panel type selection
    fprintf('\nSelect host panel type:\n');
    fprintf('1. Flat single panel\n');
    fprintf('2. Double wall\n');
    fprintf('3. Curved panel\n');
    fprintf('4. Curved double wall\n');
    host_choice = input('Choose host panel type (1-4): ');
    
    switch host_choice
        case 1
            params.host_type = 'single_panel';
            params = get_single_panel_params(params);
        case 2
            params.host_type = 'double_wall';
            params = get_double_wall_params(params);
        case 3
            params.host_type = 'curved_panel';
            params = get_curved_panel_params(params);
        case 4
            params.host_type = 'curved_double_wall';
            params = get_curved_double_wall_params(params);
        otherwise
            error('Invalid host panel type selection');
    end
    
    % Resonator parameters (simplified - only mass ratio)
    fprintf('\n--- Resonator Parameters ---\n');
    params.resonators.resonance_frequency = input('Enter resonator resonance frequency [Hz]: ');
    params.resonators.mass_ratio = input('Enter resonator mass ratio (delta = m_resonator/m_panel) [-]: ');
    
    % Validate resonator inputs
    if params.resonators.resonance_frequency <= 0
        error('Resonance frequency must be positive');
    end
    if params.resonators.mass_ratio <= 0
        error('Mass ratio must be positive');
    end
    
    % Frequency range
    fprintf('\nFrequency range options:\n');
    fprintf('1. Default (20-10000 Hz)\n');
    fprintf('2. Custom range\n');
    freq_choice = input('Choose frequency range (1 or 2): ');
    
    if freq_choice == 2
        f_min = input('Enter minimum frequency [Hz]: ');
        f_max = input('Enter maximum frequency [Hz]: ');
        f_step = input('Enter frequency step [Hz] (default: 1): ');
        if isempty(f_step)
            f_step = 1;
        end
        params.freq_range = (f_min:f_step:f_max)';
    else
        params.freq_range = (20:1:10000)';
    end
    
    % Incident angle
    angle_deg = input('Enter incident angle [degrees] (default: 60): ');
    if isempty(angle_deg)
        angle_deg = 60;
    end
    params.incident_angle = angle_deg * pi/180;
    
    fprintf('\nMetamaterial panel parameters configured successfully!\n');
    fprintf('\nResonator summary:\n');
    fprintf('  - Host panel type: %s\n', params.host_type);
    fprintf('  - Resonance frequency: %.0f Hz\n', params.resonators.resonance_frequency);
    fprintf('  - Mass ratio (delta): %.3f\n', params.resonators.mass_ratio);
end

function params = get_single_panel_params(params)
    %% Get single panel parameters for metamaterial host
    fprintf('\n--- Single Panel Host Parameters ---\n');
    
    % Material selection
    fprintf('\nSelect material:\n');
    MaterialDatabase('list');
    material_name = input('Enter material name (or ''custom'' for custom material): ', 's');
    params.material = MaterialDatabase(material_name);
    
    % Panel thickness
    params.thickness = input('Enter panel thickness [mm]: ') * 1e-3;
end

function params = get_double_wall_params(params)
    %% Get double wall parameters for metamaterial host
    fprintf('\n--- Double Wall Host Parameters ---\n');
    
    % Panel 1
    fprintf('\nPanel 1:\n');
    MaterialDatabase('list');
    material_name1 = input('Enter Panel 1 material name: ', 's');
    params.panel1.material = MaterialDatabase(material_name1);
    params.panel1.thickness = input('Enter Panel 1 thickness [mm]: ') * 1e-3;
    
    % Panel 2
    fprintf('\nPanel 2:\n');
    MaterialDatabase('list');
    material_name2 = input('Enter Panel 2 material name: ', 's');
    params.panel2.material = MaterialDatabase(material_name2);
    params.panel2.thickness = input('Enter Panel 2 thickness [mm]: ') * 1e-3;
    
    % Gap distance
    params.gap_distance = input('Enter gap distance [mm]: ') * 1e-3;
end

function params = get_curved_panel_params(params)
    %% Get curved panel parameters for metamaterial host
    fprintf('\n--- Curved Panel Host Parameters ---\n');
    
    % Material selection
    fprintf('\nSelect material:\n');
    MaterialDatabase('list');
    material_name = input('Enter material name (or ''custom'' for custom material): ', 's');
    params.material = MaterialDatabase(material_name);
    
    % Panel properties
    params.thickness = input('Enter panel thickness [mm]: ') * 1e-3;
    params.radius = input('Enter radius of curvature [m]: ');
end

function params = get_curved_double_wall_params(params)
    %% Get curved double wall parameters for metamaterial host
    fprintf('\n--- Curved Double Wall Host Parameters ---\n');
    
    % Panel 1
    fprintf('\nPanel 1:\n');
    MaterialDatabase('list');
    material_name1 = input('Enter Panel 1 material name: ', 's');
    params.panel1.material = MaterialDatabase(material_name1);
    params.panel1.thickness = input('Enter Panel 1 thickness [mm]: ') * 1e-3;
    params.panel1.radius = input('Enter Panel 1 radius [m]: ');
    
    % Panel 2
    fprintf('\nPanel 2:\n');
    MaterialDatabase('list');
    material_name2 = input('Enter Panel 2 material name: ', 's');
    params.panel2.material = MaterialDatabase(material_name2);
    params.panel2.thickness = input('Enter Panel 2 thickness [mm]: ') * 1e-3;
    params.panel2.radius = input('Enter Panel 2 radius [m]: ');
    
    % Gap distance
    params.gap_distance = input('Enter gap distance [mm]: ') * 1e-3;
end
