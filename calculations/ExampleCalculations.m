function ExampleCalculations()
    %% Example Calculations for STransLAMP
    % Demonstrates metamaterial panel enhancement with comparison plot only
    
    fprintf('=== STransLAMP Metamaterial Demo ===\n');
    fprintf('Generating metamaterial enhancement comparison plot...\n\n');
    
    % Run metamaterial panel example (figure 4 only)
    run_metamaterial_demo();
    
    fprintf('\nMetamaterial demo completed!\n');
    fprintf('Figure 4 shows the STL improvement achieved with resonators.\n\n');
end

function run_metamaterial_demo()
    %% Metamaterial panel demo - generates comparison plot only
    
    % Define material
    aluminum = MaterialDatabase('aluminum');
    
    % Set up parameters for metamaterial panel calculation
    params.host_type = 'single_panel';
    params.material = aluminum;
    params.thickness = 20e-3;  % 20 mm thick aluminum panel
    
    % Resonator parameters for demonstration
    params.resonators.resonance_frequency = 800;  % 800 Hz resonance
    params.resonators.mass_ratio = 0.08;          % 8% additional mass
    
    % Analysis parameters
    params.freq_range = 50:2:2500;  % Custom frequency range for better resolution
    params.incident_angle = pi/3;   % 60 degrees
    
    % Perform metamaterial calculation
    results = MetamaterialPanelCalculator(params);
    
    % Create only the comparison plot (Figure 4)
    create_metamaterial_comparison_plot(results);
end

function create_comparison_plot(results)
    %% Create comparison plot similar to original main.m
    
    figure('Name', 'STransLAMP Example - Curved Double Wall Analysis', 'Position', [300, 300, 1000, 700]);
    
    % Plot transmission loss curves
    c1 = semilogx(results.frequency, results.transmission_loss_panel1, ':', 'LineWidth', 1.5, 'Color', [0.8 0.4 0.2]);
    hold on;
    c2 = semilogx(results.frequency, results.transmission_loss_panel2, ':', 'LineWidth', 1.5, 'Color', [0.2 0.6 0.8]);
    cd = semilogx(results.frequency, results.transmission_loss_oblique, '-.', 'LineWidth', 2.5, 'Color', [0.2 0.4 0.8]);
    cd2 = semilogx(results.frequency, results.transmission_loss_diffuse, '-', 'LineWidth', 4.5, 'Color', [0.8 0.2 0.4]);
    
    % Formatting to match original style
    xlabel('Frequency (Hz)', 'FontSize', 16, 'Interpreter', 'latex');
    ylabel('Transmission loss (dB)', 'FontSize', 16, 'Interpreter', 'latex');
    
    legend([c1 c2 cd cd2], ...
           'curved panel 1', 'curved panel 2', 'curved double wall', 'diffuse', ...
           'Location', 'Northwest', 'FontSize', 12, 'box', 'off', 'interpreter', 'latex');
    
    axis([100 2000 0 80]);
    grid on;
    set(gca, 'TickLabelInterpreter', 'latex');
    
    % Add title with enhanced information
    title('Enhanced STransLAMP: Curved Double Wall Analysis', 'FontSize', 18, 'Interpreter', 'latex');
    
    % Add text box with calculation details
    textstr = {sprintf('Panel 1: %s (%.1f mm, R=%.1f m)', results.panel1.material_name, ...
                      results.panel1.thickness*1000, results.panel1.radius), ...
               sprintf('Panel 2: %s (%.1f mm, R=%.1f m)', results.panel2.material_name, ...
                      results.panel2.thickness*1000, results.panel2.radius), ...
               sprintf('Gap: %.1f mm', results.double_wall.gap_distance*1000), ...
               sprintf('Resonance: %.0f Hz', results.double_wall.resonance_frequency)};
    
    annotation('textbox', [0.15, 0.75, 0.25, 0.15], 'String', textstr, ...
               'FontSize', 10, 'BackgroundColor', 'white', 'EdgeColor', 'black', ...
               'Interpreter', 'latex');
end

function create_metamaterial_comparison_plot(results)
    %% Create comparison plot highlighting metamaterial improvement
    
    figure('Name', 'STransLAMP Enhanced Demo - Metamaterial Improvement', 'Position', [400, 200, 1000, 700]);
    
    % Plot host panel and metamaterial transmission loss
    host_line = semilogx(results.frequency, results.base_panel.transmission_loss_oblique, ...
                        '--', 'LineWidth', 2.5, 'Color', [0.6 0.6 0.6], 'DisplayName', 'Host Panel');
    hold on;
    meta_line = semilogx(results.frequency, results.transmission_loss_oblique, ...
                        '-', 'LineWidth', 3, 'Color', [0.8 0.2 0.4], 'DisplayName', 'Metamaterial Panel');
    
    % Calculate and plot improvement
    improvement = results.transmission_loss_oblique - results.base_panel.transmission_loss_oblique;
    yyaxis right;
    imp_line = semilogx(results.frequency, improvement, ':', 'LineWidth', 2, 'Color', [0.2 0.6 0.2]);
    ylabel('STL Improvement (dB)', 'FontSize', 14, 'Color', [0.2 0.6 0.2]);
    set(gca, 'YColor', [0.2 0.6 0.2]);
    
    % Mark resonance frequency
    xline(results.resonators.resonance_frequency, 'c--', 'LineWidth', 2, ...
          'Label', sprintf('Resonance: %.0f Hz', results.resonators.resonance_frequency));
    
    % Formatting
    yyaxis left;
    xlabel('Frequency (Hz)', 'FontSize', 14);
    ylabel('Transmission Loss (dB)', 'FontSize', 14);
    title('Metamaterial Panel Enhancement Demo', 'FontSize', 16);
    
    legend([host_line, meta_line], 'Location', 'northwest', 'FontSize', 12);
    grid on;
    axis([min(results.frequency), max(results.frequency), 0, max(results.transmission_loss_oblique)*1.1]);
    
    % Add text box with improvement summary
    max_improvement = max(improvement);
    [~, max_idx] = max(improvement);
    avg_improvement = mean(improvement);
    
    textstr = {sprintf('Max improvement: %.1f dB', max_improvement), ...
               sprintf('At frequency: %.0f Hz', results.frequency(max_idx)), ...
               sprintf('Average improvement: %.1f dB', avg_improvement), ...
               sprintf('Mass ratio: %.1f%%', results.resonators.mass_ratio*100)};
    
    annotation('textbox', [0.65, 0.75, 0.25, 0.15], 'String', textstr, ...
               'FontSize', 11, 'BackgroundColor', 'yellow', 'EdgeColor', 'black', ...
               'Interpreter', 'none');
end
