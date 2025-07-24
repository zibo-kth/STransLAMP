function ResultDisplayFunctions(func_name, results, params)
    %% Result Display Functions for STransLAMP
    % Collection of functions to display calculation results in a formatted way
    %
    % Usage:
    %   ResultDisplayFunctions('single_panel', results, params)
    %   ResultDisplayFunctions('double_wall', results, params)
    %   ResultDisplayFunctions('curved_panel', results, params)
    %   ResultDisplayFunctions('curved_double_wall', results, params)
    %   ResultDisplayFunctions('metamaterial_panel', results, params)
    
    switch lower(func_name)
        case 'single_panel'
            display_single_panel_results(results, params);
        case 'double_wall'
            display_double_wall_results(results, params);
        case 'curved_panel'
            display_curved_panel_results(results, params);
        case 'curved_double_wall'
            display_curved_double_wall_results(results, params);
        case 'metamaterial_panel'
            display_metamaterial_panel_results(results, params);
        otherwise
            error('Unknown display function: %s', func_name);
    end
end

function display_single_panel_results(results, params)
    %% Display single panel calculation results
    
    fprintf('\n========== SINGLE PANEL RESULTS ==========\n');
    fprintf('Material: %s\n', results.material_name);
    fprintf('Thickness: %.2f mm\n', results.thickness * 1000);
    fprintf('Incident angle: %.1f degrees\n', results.incident_angle * 180/pi);
    fprintf('\n--- Panel Properties ---\n');
    fprintf('Surface density: %.2f kg/m²\n', results.surface_density);
    fprintf('Bending stiffness: %.2e N⋅m\n', results.bending_stiffness);
    fprintf('Critical frequency: %.1f Hz\n', real(results.critical_frequency));
    
    % Find key frequency points
    [max_stl_oblique, max_idx_oblique] = max(results.transmission_loss_oblique);
    [max_stl_diffuse, max_idx_diffuse] = max(results.transmission_loss_diffuse);
    
    fprintf('\n--- Transmission Loss Summary ---\n');
    fprintf('Maximum STL (oblique): %.1f dB at %.0f Hz\n', max_stl_oblique, results.frequency(max_idx_oblique));
    fprintf('Maximum STL (diffuse): %.1f dB at %.0f Hz\n', max_stl_diffuse, results.frequency(max_idx_diffuse));
    
    % STL at specific frequencies
    freq_points = [100, 500, 1000, 2000, 4000];
    fprintf('\n--- STL at Key Frequencies ---\n');
    fprintf('Frequency [Hz] | Oblique [dB] | Diffuse [dB]\n');
    fprintf('---------------|--------------|-------------\n');
    for i = 1:length(freq_points)
        [~, idx] = min(abs(results.frequency - freq_points(i)));
        if idx <= length(results.frequency)
            fprintf('%13.0f | %11.1f | %11.1f\n', ...
                    freq_points(i), ...
                    results.transmission_loss_oblique(idx), ...
                    results.transmission_loss_diffuse(idx));
        end
    end
    fprintf('==========================================\n');
end

function display_double_wall_results(results, params)
    %% Display double wall calculation results
    
    fprintf('\n========== DOUBLE WALL RESULTS ==========\n');
    fprintf('Panel 1: %s (%.2f mm)\n', results.panel1.material_name, results.panel1.thickness * 1000);
    fprintf('Panel 2: %s (%.2f mm)\n', results.panel2.material_name, results.panel2.thickness * 1000);
    fprintf('Gap distance: %.1f mm\n', results.double_wall.gap_distance * 1000);
    fprintf('Incident angle: %.1f degrees\n', results.incident_angle * 180/pi);
    
    fprintf('\n--- Panel 1 Properties ---\n');
    fprintf('Surface density: %.2f kg/m²\n', results.panel1.surface_density);
    fprintf('Critical frequency: %.1f Hz\n', real(results.panel1.critical_frequency));
    
    fprintf('\n--- Panel 2 Properties ---\n');
    fprintf('Surface density: %.2f kg/m²\n', results.panel2.surface_density);
    fprintf('Critical frequency: %.1f Hz\n', real(results.panel2.critical_frequency));
    
    fprintf('\n--- Double Wall Properties ---\n');
    fprintf('Resonance frequency: %.1f Hz\n', real(results.double_wall.resonance_frequency));
    
    % Find maximum transmission loss
    [max_stl_oblique, max_idx_oblique] = max(results.transmission_loss_oblique);
    [max_stl_diffuse, max_idx_diffuse] = max(results.transmission_loss_diffuse);
    
    fprintf('\n--- Transmission Loss Summary ---\n');
    fprintf('Maximum STL (oblique): %.1f dB at %.0f Hz\n', max_stl_oblique, results.frequency(max_idx_oblique));
    fprintf('Maximum STL (diffuse): %.1f dB at %.0f Hz\n', max_stl_diffuse, results.frequency(max_idx_diffuse));
    
    % STL at specific frequencies
    freq_points = [100, 500, 1000, 2000, 4000];
    fprintf('\n--- STL at Key Frequencies ---\n');
    fprintf('Frequency [Hz] | Double Wall [dB] | Panel 1 [dB] | Panel 2 [dB]\n');
    fprintf('---------------|------------------|---------------|---------------\n');
    for i = 1:length(freq_points)
        [~, idx] = min(abs(results.frequency - freq_points(i)));
        if idx <= length(results.frequency)
            fprintf('%13.0f | %15.1f | %12.1f | %12.1f\n', ...
                    freq_points(i), ...
                    results.transmission_loss_oblique(idx), ...
                    results.transmission_loss_panel1(idx), ...
                    results.transmission_loss_panel2(idx));
        end
    end
    fprintf('==========================================\n');
end

function display_curved_panel_results(results, params)
    %% Display curved panel calculation results
    
    fprintf('\n========== CURVED PANEL RESULTS ==========\n');
    fprintf('Material: %s\n', results.material_name);
    fprintf('Thickness: %.2f mm\n', results.thickness * 1000);
    fprintf('Radius of curvature: %.2f m\n', results.radius);
    fprintf('Incident angle: %.1f degrees\n', results.incident_angle * 180/pi);
    
    fprintf('\n--- Panel Properties ---\n');
    fprintf('Surface density: %.2f kg/m²\n', results.surface_density);
    fprintf('Bending stiffness: %.2e N⋅m\n', results.bending_stiffness);
    fprintf('Critical frequency: %.1f Hz\n', real(results.critical_frequency));
    fprintf('Ring frequency: %.1f Hz\n', real(results.ring_frequency));
    
    % Find maximum transmission loss
    [max_stl_curved, max_idx_curved] = max(results.transmission_loss_oblique);
    [max_stl_flat, max_idx_flat] = max(results.flat_panel.transmission_loss_oblique);
    
    fprintf('\n--- Transmission Loss Summary ---\n');
    fprintf('Maximum STL (curved): %.1f dB at %.0f Hz\n', max_stl_curved, results.frequency(max_idx_curved));
    fprintf('Maximum STL (flat): %.1f dB at %.0f Hz\n', max_stl_flat, results.frequency(max_idx_flat));
    fprintf('Curvature effect: %.1f dB improvement\n', max_stl_curved - max_stl_flat);
    
    % STL at specific frequencies
    freq_points = [100, 500, 1000, 2000, 4000];
    fprintf('\n--- STL at Key Frequencies ---\n');
    fprintf('Frequency [Hz] | Curved [dB] | Flat [dB] | Difference [dB]\n');
    fprintf('---------------|-------------|-----------|----------------\n');
    for i = 1:length(freq_points)
        [~, idx] = min(abs(results.frequency - freq_points(i)));
        if idx <= length(results.frequency)
            diff_stl = results.transmission_loss_oblique(idx) - results.flat_panel.transmission_loss_oblique(idx);
            fprintf('%13.0f | %10.1f | %8.1f | %13.1f\n', ...
                    freq_points(i), ...
                    results.transmission_loss_oblique(idx), ...
                    results.flat_panel.transmission_loss_oblique(idx), ...
                    diff_stl);
        end
    end
    fprintf('==========================================\n');
end

function display_curved_double_wall_results(results, params)
    %% Display curved double wall calculation results
    
    fprintf('\n========== CURVED DOUBLE WALL RESULTS ==========\n');
    fprintf('Panel 1: %s (%.2f mm, R = %.2f m)\n', ...
            results.panel1.material_name, results.panel1.thickness * 1000, results.panel1.radius);
    fprintf('Panel 2: %s (%.2f mm, R = %.2f m)\n', ...
            results.panel2.material_name, results.panel2.thickness * 1000, results.panel2.radius);
    fprintf('Gap distance: %.1f mm\n', results.double_wall.gap_distance * 1000);
    fprintf('Incident angle: %.1f degrees\n', results.incident_angle * 180/pi);
    
    fprintf('\n--- Panel 1 Properties ---\n');
    fprintf('Surface density: %.2f kg/m²\n', results.panel1.surface_density);
    fprintf('Critical frequency: %.1f Hz\n', real(results.panel1.critical_frequency));
    fprintf('Ring frequency: %.1f Hz\n', real(results.panel1.ring_frequency));
    
    fprintf('\n--- Panel 2 Properties ---\n');
    fprintf('Surface density: %.2f kg/m²\n', results.panel2.surface_density);
    fprintf('Critical frequency: %.1f Hz\n', real(results.panel2.critical_frequency));
    fprintf('Ring frequency: %.1f Hz\n', real(results.panel2.ring_frequency));
    
    fprintf('\n--- Double Wall Properties ---\n');
    fprintf('Resonance frequency: %.1f Hz\n', real(results.double_wall.resonance_frequency));
    
    % Find maximum transmission loss
    [max_stl_curved, max_idx_curved] = max(results.transmission_loss_oblique);
    [max_stl_flat, max_idx_flat] = max(results.flat_double_wall.transmission_loss_oblique);
    
    fprintf('\n--- Transmission Loss Summary ---\n');
    fprintf('Maximum STL (curved): %.1f dB at %.0f Hz\n', max_stl_curved, results.frequency(max_idx_curved));
    fprintf('Maximum STL (flat): %.1f dB at %.0f Hz\n', max_stl_flat, results.frequency(max_idx_flat));
    fprintf('Curvature effect: %.1f dB improvement\n', max_stl_curved - max_stl_flat);
    
    % STL at specific frequencies
    freq_points = [100, 500, 1000, 2000, 4000];
    fprintf('\n--- STL at Key Frequencies ---\n');
    fprintf('Frequency [Hz] | Curved DW [dB] | Flat DW [dB] | Panel 1 [dB] | Panel 2 [dB]\n');
    fprintf('---------------|----------------|---------------|---------------|---------------\n');
    for i = 1:length(freq_points)
        [~, idx] = min(abs(results.frequency - freq_points(i)));
        if idx <= length(results.frequency)
            fprintf('%13.0f | %13.1f | %12.1f | %12.1f | %12.1f\n', ...
                    freq_points(i), ...
                    results.transmission_loss_oblique(idx), ...
                    results.flat_double_wall.transmission_loss_oblique(idx), ...
                    results.transmission_loss_panel1(idx), ...
                    results.transmission_loss_panel2(idx));
        end
    end
    fprintf('===============================================\n');
end

function display_metamaterial_panel_results(results, params)
    %% Display metamaterial panel calculation results
    
    fprintf('\n========== METAMATERIAL PANEL RESULTS ==========\n');
    fprintf('Host Panel Type: %s\n', results.host_type);
    fprintf('Incident angle: %.1f degrees\n', results.incident_angle * 180/pi);
    
    % Display host-specific information
    if isfield(results, 'host_results') && ~isempty(results.host_results)
        fprintf('\n--- Host Panel Properties ---\n');
        host_res = results.host_results;
        
        switch results.host_type
            case 'single_panel'
                fprintf('Material: %s\n', host_res.material_name);
                fprintf('Thickness: %.2f mm\n', host_res.thickness * 1000);
                fprintf('Critical frequency: %.1f Hz\n', real(host_res.critical_frequency));
                
            case 'curved_panel'
                fprintf('Material: %s\n', host_res.material_name);
                fprintf('Thickness: %.2f mm\n', host_res.thickness * 1000);
                fprintf('Radius: %.2f m\n', host_res.radius);
                fprintf('Critical frequency: %.1f Hz\n', real(host_res.critical_frequency));
                fprintf('Ring frequency: %.1f Hz\n', real(host_res.ring_frequency));
                
            case 'double_wall'
                fprintf('Panel 1: %s (%.2f mm)\n', host_res.panel1.material_name, host_res.panel1.thickness * 1000);
                fprintf('Panel 2: %s (%.2f mm)\n', host_res.panel2.material_name, host_res.panel2.thickness * 1000);
                fprintf('Gap distance: %.2f mm\n', host_res.gap_distance * 1000);
                fprintf('Resonance frequency: %.1f Hz\n', real(host_res.resonance_frequency));
                
            case 'curved_double_wall'
                fprintf('Panel 1: %s (%.2f mm, R=%.2f m)\n', host_res.panel1.material_name, host_res.panel1.thickness * 1000, host_res.panel1.radius);
                fprintf('Panel 2: %s (%.2f mm, R=%.2f m)\n', host_res.panel2.material_name, host_res.panel2.thickness * 1000, host_res.panel2.radius);
                fprintf('Gap distance: %.2f mm\n', host_res.gap_distance * 1000);
        end
    end
    
    fprintf('\n--- Resonator Properties ---\n');
    fprintf('Resonance frequency: %.1f Hz\n', results.resonators.resonance_frequency);
    fprintf('Mass ratio (delta): %.3f\n', results.resonators.mass_ratio);
    if isfield(results.resonators, 'complex_resonance')
        fprintf('Complex resonance: %.1f + %.3fi Hz\n', real(results.resonators.complex_resonance), imag(results.resonators.complex_resonance));
    end
    
    % Find maximum transmission loss
    [max_stl_meta, max_idx_meta] = max(results.transmission_loss_oblique);
    [max_stl_host, max_idx_host] = max(results.base_panel.transmission_loss_oblique);
    
    fprintf('\n--- Transmission Loss Summary ---\n');
    fprintf('Maximum STL (metamaterial): %.1f dB at %.0f Hz\n', max_stl_meta, results.frequency(max_idx_meta));
    fprintf('Maximum STL (host panel): %.1f dB at %.0f Hz\n', max_stl_host, results.frequency(max_idx_host));
    
    % Calculate improvement
    improvement = results.transmission_loss_oblique - results.base_panel.transmission_loss_oblique;
    [max_improvement, max_imp_idx] = max(improvement);
    fprintf('Maximum improvement: %.1f dB at %.0f Hz\n', max_improvement, results.frequency(max_imp_idx));
    
    % STL at specific frequencies
    freq_points = [100, 500, 1000, 2000, 4000];
    fprintf('\n--- STL at Key Frequencies ---\n');
    fprintf('Frequency [Hz] | Metamaterial [dB] | Host Panel [dB] | Improvement [dB]\n');
    fprintf('---------------|-------------------|-----------------|------------------\n');
    for i = 1:length(freq_points)
        [~, idx] = min(abs(results.frequency - freq_points(i)));
        if idx <= length(results.frequency)
            improvement_val = results.transmission_loss_oblique(idx) - results.base_panel.transmission_loss_oblique(idx);
            fprintf('%13.0f | %16.1f | %14.1f | %15.1f\n', ...
                    freq_points(i), ...
                    results.transmission_loss_oblique(idx), ...
                    results.base_panel.transmission_loss_oblique(idx), ...
                    improvement_val);
        end
    end
    
    % Performance metrics
    fprintf('\n--- Performance Metrics ---\n');
    avg_improvement = mean(results.transmission_loss_oblique - results.base_panel.transmission_loss_oblique);
    fprintf('Average improvement: %.1f dB\n', avg_improvement);
    
    % Find frequency range of significant improvement (>3dB)
    improvement_curve = results.transmission_loss_oblique - results.base_panel.transmission_loss_oblique;
    significant_idx = find(improvement_curve > 3);
    if ~isempty(significant_idx)
        fprintf('Significant improvement (>3dB) range: %.0f - %.0f Hz\n', ...
                results.frequency(significant_idx(1)), results.frequency(significant_idx(end)));
    else
        fprintf('No significant improvement (>3dB) found in frequency range\n');
    end
    
    fprintf('===============================================\n');
end
