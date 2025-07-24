%% STransLAMP - Sound Transmission Loss of Acoustic Metamaterial Panels
%% Enhanced Version with Improved Structure and User Experience
%% Author: Zibo Liu (zibo@kth.se)
%% Enhanced: 2025
%% License: Open Source - Please cite relevant research papers when using this code

function STransLAMP_Main()
    %% Main interface for STransLAMP calculations
    % This function provides a user-friendly interface for calculating
    % sound transmission loss of various panel configurations
    
    clear; clc; close all;
    
    % Add all necessary paths
    addpath(genpath('./src/'));
    addpath(genpath('./calculations/'));
    addpath(genpath('./materials/'));
    addpath(genpath('./utils/'));
    
    % Display welcome message and options
    display_welcome();
    
    % Main menu loop
    while true
        choice = display_main_menu();
        
        switch choice
            case 1
                calculate_single_panel();
            case 2
                calculate_double_wall();
            case 3
                calculate_curved_panel();
            case 4
                calculate_curved_double_wall();
            case 5
                calculate_metamaterial_panel();
            case 6
                run_example_calculations();
            case 7
                display_help();
            case 0
                fprintf('\nThank you for using STransLAMP!\n');
                break;
            otherwise
                fprintf('\nInvalid choice. Please try again.\n');
        end
        
        fprintf('\nPress any key to continue...\n');
        pause;
    end
end

function display_welcome()
    %% Display welcome message
    fprintf('\n');
    fprintf('========================================================\n');
    fprintf('    STransLAMP - Sound Transmission Loss Calculator    \n');
    fprintf('    for Acoustic Metamaterial Panels                  \n');
    fprintf('========================================================\n');
    fprintf('Author: Zibo Liu (zibo@kth.se)\n');
    fprintf('Enhanced Version with Improved User Experience\n');
    fprintf('========================================================\n\n');
end

function choice = display_main_menu()
    %% Display main menu and get user choice
    fprintf('\n--- MAIN MENU ---\n');
    fprintf('1. Single Panel Analysis\n');
    fprintf('2. Double Wall Analysis\n');
    fprintf('3. Curved Panel Analysis\n');
    fprintf('4. Curved Double Wall Analysis\n');
    fprintf('5. Metamaterial Panel Analysis\n');
    fprintf('6. Run Example Calculations\n');
    fprintf('7. Help & Documentation\n');
    fprintf('0. Exit\n');
    fprintf('\nEnter your choice (0-7): ');
    
    choice = input('');
    if isempty(choice) || ~isnumeric(choice)
        choice = -1;
    end
end

function calculate_single_panel()
    %% Single panel calculation interface
    fprintf('\n=== SINGLE PANEL ANALYSIS ===\n');
    
    % Get user inputs
    params = InputHandlers('single_panel');
    
    % Perform calculations
    results = SinglePanelCalculator(params);
    
    % Display and plot results
    ResultDisplayFunctions('single_panel', results, params);
    PlottingFunctions('single_panel', results, params);
end

function calculate_double_wall()
    %% Double wall calculation interface
    fprintf('\n=== DOUBLE WALL ANALYSIS ===\n');
    
    % Get user inputs
    params = InputHandlers('double_wall');
    
    % Perform calculations
    results = DoubleWallCalculator(params);
    
    % Display and plot results
    ResultDisplayFunctions('double_wall', results, params);
    PlottingFunctions('double_wall', results, params);
end

function calculate_curved_panel()
    %% Curved panel calculation interface
    fprintf('\n=== CURVED PANEL ANALYSIS ===\n');
    
    % Get user inputs
    params = InputHandlers('curved_panel');
    
    % Perform calculations
    results = CurvedPanelCalculator(params);
    
    % Display and plot results
    ResultDisplayFunctions('curved_panel', results, params);
    PlottingFunctions('curved_panel', results, params);
end

function calculate_curved_double_wall()
    %% Curved double wall calculation interface
    fprintf('\n=== CURVED DOUBLE WALL ANALYSIS ===\n');
    
    % Get user inputs
    params = InputHandlers('curved_double_wall');
    
    % Perform calculations
    results = CurvedDoubleWallCalculator(params);
    
    % Display and plot results
    ResultDisplayFunctions('curved_double_wall', results, params);
    PlottingFunctions('curved_double_wall', results, params);
end

function calculate_metamaterial_panel()
    %% Metamaterial panel calculation interface
    fprintf('\n=== METAMATERIAL PANEL ANALYSIS ===\n');
    
    % Get user inputs
    params = InputHandlers('metamaterial_panel');
    
    % Perform calculations
    results = MetamaterialPanelCalculator(params);
    
    % Display and plot results
    ResultDisplayFunctions('metamaterial_panel', results, params);
    PlottingFunctions('metamaterial_panel', results, params);
end

function run_example_calculations()
    %% Run predefined example calculations
    fprintf('\n=== EXAMPLE CALCULATIONS ===\n');
    fprintf('Running example calculations from the original main.m...\n\n');
    
    % Run the original example (curved double wall with Al and PVC)
    ExampleCalculations();
end

function display_help()
    %% Display help and documentation
    fprintf('\n=== HELP & DOCUMENTATION ===\n');
    fprintf('\n🎯 STransLAMP Enhanced - Sound Transmission Loss Analysis for Acoustic Metamaterial Panels\n\n');
    
    fprintf('=== PANEL CONFIGURATIONS ===\n');
    fprintf('1. SINGLE PANEL: Flat panel with specified material properties\n');
    fprintf('   - Input: Material, thickness, frequency range, incident angle\n');
    fprintf('   - Output: Transmission loss vs frequency, critical frequency analysis\n\n');
    
    fprintf('2. DOUBLE WALL: Two parallel panels with air gap\n');
    fprintf('   - Input: Two panel specifications, gap distance, stiffness\n');
    fprintf('   - Output: Combined transmission loss, resonance frequency analysis\n\n');
    
    fprintf('3. CURVED PANEL: Single curved panel (cylindrical shell)\n');
    fprintf('   - Input: Material, thickness, radius of curvature\n');
    fprintf('   - Output: Transmission loss with curvature effects, ring frequency\n\n');
    
    fprintf('4. CURVED DOUBLE WALL: Two curved panels with air gap\n');
    fprintf('   - Input: Two curved panel specifications, gap properties\n');
    fprintf('   - Output: Combined transmission loss with curvature effects\n\n');
    
    fprintf('5. METAMATERIAL PANEL: Any host panel enhanced with resonators\n');
    fprintf('   - Host types: Single, double wall, curved, curved double wall\n');
    fprintf('   - Input: Host panel parameters + resonator specifications\n');
    fprintf('   - Output: Enhanced STL with resonator improvement analysis\n\n');
    
    fprintf('=== MATERIAL DATABASE ===\n');
    fprintf('Built-in materials: Aluminum, Steel, PVC, Concrete, Glass, Plywood, Gypsum\n');
    fprintf('Custom materials: Define your own material properties\n\n');
    
    fprintf('Material Properties Required:\n');
    fprintf('- Young''s modulus (E) [Pa] - Elastic stiffness\n');
    fprintf('- Density (rho) [kg/m³] - Mass density\n');
    fprintf('- Poisson''s ratio (nu) [-] - Lateral strain ratio\n');
    fprintf('- Loss factor (eta) [-] - Material damping\n');
    fprintf('- Thickness (t) [m] - Panel thickness\n\n');
    
    fprintf('For curved panels, also specify:\n');
    fprintf('- Radius of curvature (R) [m] - Cylindrical shell radius\n\n');
    
    fprintf('=== METAMATERIAL RESONATORS ===\n');
    fprintf('Resonator Parameters:\n');
    fprintf('- Resonance frequency (f_res) [Hz] - Target frequency for enhancement\n');
    fprintf('- Mass ratio (delta) [-] - Additional mass from resonators (e.g., 0.05 = 5%%)\n');
    fprintf('- Host panel type - Any of the 4 traditional configurations\n\n');
    
    fprintf('Physics: Z_metamaterial = Z_host + Z_resonator\n');
    fprintf('Where: Z_resonator = i*omega*m*delta / (1 - (f/f_res)^2)\n\n');
    
    fprintf('=== ANALYSIS FEATURES ===\n');
    fprintf('- Custom frequency ranges with user-defined steps\n');
    fprintf('- Variable incident angles (0-90 degrees)\n');
    fprintf('- Oblique and diffuse field transmission loss\n');
    fprintf('- Critical frequency and resonance analysis\n');
    fprintf('- Professional plotting with LaTeX formatting\n');
    fprintf('- Comprehensive result summaries and comparisons\n\n');
    
    fprintf('=== EXAMPLE USAGE ===\n');
    fprintf('Option 6: Metamaterial demo showing ~20+ dB improvement\n');
    fprintf('README_Enhanced.md: Detailed usage examples and theory\n\n');
    fprintf('📚 For detailed examples and theory, see README_Enhanced.md\n');
    fprintf('🚀 Try the metamaterial demo (Option 6) to see dramatic STL improvements!\n\n');
    fprintf('Press any key to return to main menu...\n');
    pause;
end
