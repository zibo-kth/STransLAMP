function z = impedance_panel(f, m, D)
%%%% input m:surface density; D:stiffness of the panel, theta:incident elevation angle. 
%%%% this function return the impedance of a flat panel under acoustic
%%%% excitation with the incident angle theta

% 


z = @impedance_panel_theta; % Return handle to nested function

    function ztheta = impedance_panel_theta(theta)
        % This nested function can see the variables 'f', 'm', 'D'
        % Ensure all arrays are compatible for element-wise operations
        
        % Ensure frequency array is column vector
        f_vec = f(:);
        
        % Calculate frequency-dependent values
        omega_vals = omega(f_vec);
        wn_vals = wn(f_vec);
        kappa_vals = kappa(f_vec, m, D);
        
        % Ensure all arrays are column vectors with same size
        omega_vals = omega_vals(:);
        wn_vals = wn_vals(:);
        kappa_vals = kappa_vals(:);
        
        % Verify array sizes are compatible
        if length(omega_vals) ~= length(wn_vals) || length(omega_vals) ~= length(kappa_vals)
            error('Array size mismatch in impedance calculation');
        end
        
        % Calculate impedance with proper element-wise operations
        % Ensure theta is scalar for the calculation
        sin_theta_4 = sin(theta)^4;  % Scalar value
        
        ztheta = 1i .* omega_vals .* m .* (1 - wn_vals.^4 ./ kappa_vals.^4 .* sin_theta_4);
    end

end