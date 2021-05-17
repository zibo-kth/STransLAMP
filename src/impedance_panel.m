function z = impedance_panel(f, m, D)
%%%% input m:surface density; D:stiffness of the panel, theta:incident elevation angle. 
%%%% this function return the impedance of a flat panel under acoustic
%%%% excitation with the incident angle theta

% 


z = @impedance_panel_theta; % Return handle to nested function

    function ztheta = impedance_panel_theta(theta)
        % This nested function can see the variables 'a','b', and 'c'
        
        ztheta = 1i.*omega(f).*m.*(1 - wn(f).^4./kappa(f, m, D).^4.*sin(theta).^4);
    end

end