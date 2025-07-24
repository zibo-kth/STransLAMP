function material = MaterialDatabase(material_name)
    %% Material Database for STransLAMP
    % Returns material properties for common materials used in acoustic panels
    %
    % Input:
    %   material_name - string specifying material ('aluminum', 'pvc', 'steel', etc.)
    %                  or 'list' to see available materials
    %                  or 'custom' to define custom material interactively
    %
    % Output:
    %   material - structure containing:
    %     .name - material name
    %     .density - density [kg/m³]
    %     .youngs_modulus - complex Young's modulus [Pa]
    %     .youngs_modulus_real - real part of Young's modulus [Pa]
    %     .poisson_ratio - Poisson's ratio [-]
    %     .loss_factor - loss factor [-]
    
    if nargin == 0 || strcmpi(material_name, 'list')
        display_available_materials();
        material = [];
        return;
    end
    
    if strcmpi(material_name, 'custom')
        material = create_custom_material();
        return;
    end
    
    % Material database
    switch lower(material_name)
        case {'aluminum', 'aluminium', 'al'}
            material.name = 'Aluminum';
            material.density = 2700;                    % kg/m³
            material.youngs_modulus_real = 6.9e10;      % Pa
            material.loss_factor = 0.0001;              % -
            material.poisson_ratio = 0.3;               % -
            
        case {'pvc', 'polyvinyl_chloride'}
            material.name = 'PVC';
            material.density = 1400;                    % kg/m³
            material.youngs_modulus_real = 3.0e9;       % Pa
            material.loss_factor = 0.02;                % -
            material.poisson_ratio = 0.38;              % -
            
        case {'steel', 'carbon_steel'}
            material.name = 'Steel';
            material.density = 7850;                    % kg/m³
            material.youngs_modulus_real = 2.1e11;      % Pa
            material.loss_factor = 0.0002;              % -
            material.poisson_ratio = 0.3;               % -
            
        case {'glass', 'soda_lime_glass'}
            material.name = 'Glass';
            material.density = 2500;                    % kg/m³
            material.youngs_modulus_real = 7.0e10;      % Pa
            material.loss_factor = 0.001;               % -
            material.poisson_ratio = 0.23;              % -
            
        case {'concrete'}
            material.name = 'Concrete';
            material.density = 2400;                    % kg/m³
            material.youngs_modulus_real = 3.0e10;      % Pa
            material.loss_factor = 0.01;                % -
            material.poisson_ratio = 0.2;               % -
            
        case {'wood', 'plywood'}
            material.name = 'Wood/Plywood';
            material.density = 600;                     % kg/m³
            material.youngs_modulus_real = 1.0e10;      % Pa
            material.loss_factor = 0.01;                % -
            material.poisson_ratio = 0.3;               % -
            
        case {'gypsum', 'drywall'}
            material.name = 'Gypsum/Drywall';
            material.density = 800;                     % kg/m³
            material.youngs_modulus_real = 2.5e9;       % Pa
            material.loss_factor = 0.005;               % -
            material.poisson_ratio = 0.25;              % -
            
        otherwise
            error('Unknown material: %s. Use MaterialDatabase(''list'') to see available materials.', material_name);
    end
    
    % Calculate complex Young's modulus
    material.youngs_modulus = material.youngs_modulus_real * (1 + 1i * material.loss_factor);
end

function display_available_materials()
    %% Display list of available materials
    fprintf('\n=== AVAILABLE MATERIALS ===\n');
    fprintf('1. aluminum (or al)\n');
    fprintf('2. pvc\n');
    fprintf('3. steel\n');
    fprintf('4. glass\n');
    fprintf('5. concrete\n');
    fprintf('6. wood (or plywood)\n');
    fprintf('7. gypsum (or drywall)\n');
    fprintf('\nUsage: material = MaterialDatabase(''aluminum'');\n');
    fprintf('       material = MaterialDatabase(''custom''); % for custom material\n\n');
end

function material = create_custom_material()
    %% Interactive custom material creation
    fprintf('\n=== CREATE CUSTOM MATERIAL ===\n');
    
    material.name = input('Enter material name: ', 's');
    if isempty(material.name)
        material.name = 'Custom Material';
    end
    
    material.density = input('Enter density [kg/m³]: ');
    material.youngs_modulus_real = input('Enter Young''s modulus [Pa]: ');
    material.poisson_ratio = input('Enter Poisson''s ratio [-]: ');
    material.loss_factor = input('Enter loss factor [-] (typical: 0.001-0.1): ');
    
    % Validate inputs
    if material.density <= 0
        error('Density must be positive');
    end
    if material.youngs_modulus_real <= 0
        error('Young''s modulus must be positive');
    end
    if material.poisson_ratio < 0 || material.poisson_ratio >= 0.5
        error('Poisson''s ratio must be between 0 and 0.5');
    end
    if material.loss_factor < 0 || material.loss_factor > 1
        error('Loss factor must be between 0 and 1');
    end
    
    % Calculate complex Young's modulus
    material.youngs_modulus = material.youngs_modulus_real * (1 + 1i * material.loss_factor);
    
    fprintf('\nCustom material "%s" created successfully!\n', material.name);
end