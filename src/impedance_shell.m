function z = impedance_shell(f, E0, nu, rho, R, m, D, theta) 
%%%% input m:surface density; D:stiffness of the panel, R: radius of curvature of the panel; theta:incident elevation angle. 
%%%% this function return the impedance of a flat panel under acoustic
%%%% excitation with the incident angle theta

% parameter_pressure_acoustics

% fri = fring(E0, nu, rho, R);

% z = 1i.*omega.*m.*(1-(f./fcr).^2.*sin(theta)^4-(fri./f).^2 );




z = @impedance_shell_theta; % Return handle to nested function

    function ztheta = impedance_shell_theta(theta)
        % This nested function can see the variables 'a','b', and 'c'
        
        ztheta = 1i.*omega(f).*m.*(1-(f./fcritical(m, D)).^2.*sin(theta)^4-(fring(E0, nu, rho, R)./f).^2 );
    end

end