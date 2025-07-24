function PlottingFunctions(func_name, results, params)
    %% Plotting Functions for STransLAMP Results - Fixed Version
    % Collection of functions to plot and visualize transmission loss results
    %
    % Usage:
    %   PlottingFunctions('single_panel', results, params)
    %   PlottingFunctions('double_wall', results, params)
    %   PlottingFunctions('curved_panel', results, params)
    %   PlottingFunctions('curved_double_wall', results, params)
    %   PlottingFunctions('metamaterial_panel', results, params)
    
    switch lower(func_name)
        case 'single_panel'
            plot_single_panel_results(results, params);
        case 'double_wall'
            plot_double_wall_results(results, params);
        case 'curved_panel'
            plot_curved_panel_results(results, params);
        case 'curved_double_wall'
            plot_curved_double_wall_results(results, params);
        case 'metamaterial_panel'
            plot_metamaterial_panel_results(results, params);
        otherwise
            error('Unknown plotting function: %s', func_name);
    end
end

function plot_single_panel_results(results, params)
    %% Plot single panel transmission loss results
    
    figure('Name', sprintf('Single Panel - %s', results.material_name), 'Position', [100, 100, 800, 600]);
    
    % Main plot
    semilogx(results.frequency, results.transmission_loss_oblique, 'b-', 'LineWidth', 2);
    hold on;
    semilogx(results.frequency, results.transmission_loss_diffuse, 'r--', 'LineWidth', 2);
    
    % Mark critical frequency (fixed to handle complex values)
    try
        fc_real = real(results.critical_frequency);
        if fc_real > min(results.frequency) && fc_real < max(results.frequency) && isfinite(fc_real) && fc_real > 0
            xline(fc_real, 'k:', 'LineWidth', 1.5, 'Label', sprintf('f_c = %.0f Hz', fc_real));
        end
    catch
        % Skip if critical frequency marking fails
    end
    
    % Formatting
    xlabel('Frequency (Hz)', 'FontSize', 14, 'Interpreter', 'latex');
    ylabel('Transmission Loss (dB)', 'FontSize', 14, 'Interpreter', 'latex');
    title(sprintf('Single Panel: %s (t = %.1f mm)', results.material_name, results.thickness*1000), ...
          'FontSize', 16, 'Interpreter', 'latex');
    
    legend({'Oblique incidence', 'Diffuse field'}, 'Location', 'northwest', 'FontSize', 12, 'Interpreter', 'latex');
    grid on;
    axis([min(results.frequency), max(results.frequency), 0, max(results.transmission_loss_diffuse)*1.1]);
    set(gca, 'TickLabelInterpreter', 'latex');
end

function plot_double_wall_results(results, params)
    %% Plot double wall transmission loss results
    
    figure('Name', sprintf('Double Wall - %s + %s', results.panel1.material_name, results.panel2.material_name), ...
           'Position', [150, 150, 900, 600]);
    
    % Main plot
    semilogx(results.frequency, results.transmission_loss_oblique, 'b-', 'LineWidth', 3);
    hold on;
    semilogx(results.frequency, results.transmission_loss_diffuse, 'r--', 'LineWidth', 3);
    semilogx(results.frequency, results.transmission_loss_panel1, 'g:', 'LineWidth', 1.5);
    semilogx(results.frequency, results.transmission_loss_panel2, 'm:', 'LineWidth', 1.5);
    
    % Mark resonance frequency (fixed to handle complex values)
    try
        fres_real = real(results.double_wall.resonance_frequency);
        if fres_real > min(results.frequency) && fres_real < max(results.frequency) && isfinite(fres_real) && fres_real > 0
            xline(fres_real, 'k:', 'LineWidth', 1.5, 'Label', sprintf('f_{res} = %.0f Hz', fres_real));
        end
    catch
        % Skip if resonance frequency marking fails
    end
    
    % Formatting
    xlabel('Frequency (Hz)', 'FontSize', 14, 'Interpreter', 'latex');
    ylabel('Transmission Loss (dB)', 'FontSize', 14, 'Interpreter', 'latex');
    title(sprintf('Double Wall: %s + %s (gap = %.1f mm)', ...
                  results.panel1.material_name, results.panel2.material_name, ...
                  results.double_wall.gap_distance*1000), ...
          'FontSize', 16, 'Interpreter', 'latex');
    
    legend({'Double wall (oblique)', 'Double wall (diffuse)', ...
            sprintf('Panel 1 (%s)', results.panel1.material_name), ...
            sprintf('Panel 2 (%s)', results.panel2.material_name)}, ...
           'Location', 'northwest', 'FontSize', 12, 'Interpreter', 'latex');
    grid on;
    axis([min(results.frequency), max(results.frequency), 0, max(results.transmission_loss_diffuse)*1.1]);
    set(gca, 'TickLabelInterpreter', 'latex');
end

function plot_curved_panel_results(results, params)
    %% Plot curved panel transmission loss results
    
    figure('Name', sprintf('Curved Panel - %s', results.material_name), 'Position', [200, 200, 800, 600]);
    
    % Main plot
    semilogx(results.frequency, results.transmission_loss_oblique, 'b-', 'LineWidth', 2);
    hold on;
    semilogx(results.frequency, results.transmission_loss_diffuse, 'r--', 'LineWidth', 2);
    semilogx(results.frequency, results.flat_panel.transmission_loss_oblique, 'g:', 'LineWidth', 1.5);
    semilogx(results.frequency, results.flat_panel.transmission_loss_diffuse, 'm:', 'LineWidth', 1.5);
    
    % Mark critical and ring frequencies (fixed to handle complex values)
    try
        fc_real = real(results.critical_frequency);
        if fc_real > min(results.frequency) && fc_real < max(results.frequency) && isfinite(fc_real) && fc_real > 0
            xline(fc_real, 'k:', 'LineWidth', 1.5, 'Label', sprintf('f_c = %.0f Hz', fc_real));
        end
    catch
        % Skip if critical frequency marking fails
    end
    
    try
        fring_real = real(results.ring_frequency);
        if fring_real > min(results.frequency) && fring_real < max(results.frequency) && isfinite(fring_real) && fring_real > 0
            xline(fring_real, 'c:', 'LineWidth', 1.5, 'Label', sprintf('f_{ring} = %.0f Hz', fring_real));
        end
    catch
        % Skip if ring frequency marking fails
    end
    
    % Formatting
    xlabel('Frequency (Hz)', 'FontSize', 14, 'Interpreter', 'latex');
    ylabel('Transmission Loss (dB)', 'FontSize', 14, 'Interpreter', 'latex');
    title(sprintf('Curved Panel: %s (R = %.1f m, t = %.1f mm)', ...
                  results.material_name, results.radius, results.thickness*1000), ...
          'FontSize', 16, 'Interpreter', 'latex');
    
    legend({'Curved (oblique)', 'Curved (diffuse)', 'Flat (oblique)', 'Flat (diffuse)'}, ...
           'Location', 'northwest', 'FontSize', 12, 'Interpreter', 'latex');
    grid on;
    axis([min(results.frequency), max(results.frequency), 0, max(results.transmission_loss_diffuse)*1.1]);
    set(gca, 'TickLabelInterpreter', 'latex');
end

function plot_curved_double_wall_results(results, params)
    %% Plot curved double wall transmission loss results
    
    figure('Name', sprintf('Curved Double Wall - %s + %s', results.panel1.material_name, results.panel2.material_name), ...
           'Position', [250, 250, 1000, 600]);
    
    % Main plot
    semilogx(results.frequency, results.transmission_loss_oblique, 'b-', 'LineWidth', 3);
    hold on;
    semilogx(results.frequency, results.transmission_loss_diffuse, 'r--', 'LineWidth', 3);
    semilogx(results.frequency, results.transmission_loss_panel1, 'g:', 'LineWidth', 1.5);
    semilogx(results.frequency, results.transmission_loss_panel2, 'm:', 'LineWidth', 1.5);
    semilogx(results.frequency, results.flat_double_wall.transmission_loss_oblique, 'c:', 'LineWidth', 1);
    
    % Mark resonance frequency (fixed to handle complex values)
    try
        fres_real = real(results.double_wall.resonance_frequency);
        if fres_real > min(results.frequency) && fres_real < max(results.frequency) && isfinite(fres_real) && fres_real > 0
            xline(fres_real, 'k:', 'LineWidth', 1.5, 'Label', sprintf('f_{res} = %.0f Hz', fres_real));
        end
    catch
        % Skip if resonance frequency marking fails
    end
    
    % Formatting
    xlabel('Frequency (Hz)', 'FontSize', 14, 'Interpreter', 'latex');
    ylabel('Transmission Loss (dB)', 'FontSize', 14, 'Interpreter', 'latex');
    title(sprintf('Curved Double Wall: %s (R=%.1fm) + %s (R=%.1fm)', ...
                  results.panel1.material_name, results.panel1.radius, ...
                  results.panel2.material_name, results.panel2.radius), ...
          'FontSize', 16, 'Interpreter', 'latex');
    
    legend({'Curved double wall (oblique)', 'Curved double wall (diffuse)', ...
            sprintf('Curved panel 1 (%s)', results.panel1.material_name), ...
            sprintf('Curved panel 2 (%s)', results.panel2.material_name), ...
            'Flat double wall (reference)'}, ...
           'Location', 'northwest', 'FontSize', 12, 'Interpreter', 'latex');
    grid on;
    axis([min(results.frequency), max(results.frequency), 0, max(results.transmission_loss_diffuse)*1.1]);
    set(gca, 'TickLabelInterpreter', 'latex');
end

function plot_metamaterial_panel_results(results, params)
    %% Plot metamaterial panel transmission loss results
    
    % Create figure title based on host type
    if isfield(results, 'host_results') && isfield(results.host_results, 'material_name')
        title_str = sprintf('Metamaterial Panel - %s (%s)', results.host_results.material_name, results.host_type);
    else
        title_str = sprintf('Metamaterial Panel - %s', results.host_type);
    end
    
    figure('Name', title_str, 'Position', [300, 300, 900, 600]);
    
    % Main plot
    semilogx(results.frequency, results.transmission_loss_oblique, 'b-', 'LineWidth', 3);
    hold on;
    semilogx(results.frequency, results.transmission_loss_diffuse, 'r--', 'LineWidth', 3);
    semilogx(results.frequency, results.base_panel.transmission_loss_oblique, 'g:', 'LineWidth', 1.5);
    semilogx(results.frequency, results.base_panel.transmission_loss_diffuse, 'm:', 'LineWidth', 1.5);
    
    % Mark critical frequency and resonator frequency (fixed to handle complex values)
    try
        if isfield(results, 'host_results') && isfield(results.host_results, 'critical_frequency')
            fc_real = real(results.host_results.critical_frequency);
            if fc_real > min(results.frequency) && fc_real < max(results.frequency) && isfinite(fc_real) && fc_real > 0
                xline(fc_real, 'k:', 'LineWidth', 1.5, 'Label', sprintf('f_c = %.0f Hz', fc_real));
            end
        end
    catch
        % Skip if critical frequency marking fails
    end
    
    % Mark resonator frequency
    try
        fres = results.resonators.resonance_frequency;
        if fres > min(results.frequency) && fres < max(results.frequency)
            xline(fres, 'c:', 'LineWidth', 2, 'Label', sprintf('f_{res} = %.0f Hz', fres));
        end
    catch
        % Skip if resonator frequency marking fails
    end
    
    % Formatting
    xlabel('Frequency (Hz)', 'FontSize', 14, 'Interpreter', 'latex');
    ylabel('Transmission Loss (dB)', 'FontSize', 14, 'Interpreter', 'latex');
    % Create title with available information
    if isfield(results, 'host_results') && isfield(results.host_results, 'material_name')
        if isfield(results.host_results, 'thickness')
            title_text = sprintf('Metamaterial Panel: %s (t = %.1f mm, f_res = %.0f Hz)', ...
                              results.host_results.material_name, results.host_results.thickness*1000, results.resonators.resonance_frequency);
        else
            title_text = sprintf('Metamaterial Panel: %s (f_res = %.0f Hz)', ...
                              results.host_results.material_name, results.resonators.resonance_frequency);
        end
    else
        title_text = sprintf('Metamaterial Panel: %s (f_res = %.0f Hz)', ...
                          results.host_type, results.resonators.resonance_frequency);
    end
    
    title(title_text, 'FontSize', 16, 'Interpreter', 'none');
    
    legend({'Metamaterial (oblique)', 'Metamaterial (diffuse)', 'Base panel (oblique)', 'Base panel (diffuse)'}, ...
           'Location', 'northwest', 'FontSize', 12, 'Interpreter', 'latex');
    grid on;
    axis([min(results.frequency), max(results.frequency), 0, max(results.transmission_loss_diffuse)*1.1]);
    set(gca, 'TickLabelInterpreter', 'latex');
    
    % Add text box with metamaterial parameters
    textstr = {sprintf('Mass ratio (delta): %.3f', results.resonators.mass_ratio), ...
               sprintf('Resonance freq: %.0f Hz', results.resonators.resonance_frequency), ...
               sprintf('Host type: %s', results.host_type)};
    
    annotation('textbox', [0.15, 0.75, 0.25, 0.15], 'String', textstr, ...
               'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
               'Interpreter', 'none');
end
