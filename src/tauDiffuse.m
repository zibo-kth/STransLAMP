function tau_diffuse = tauDiffuse(z, dtheta, theta1, theta2)

%%%% this function return the diffuse transmission coefficient of a panel
%%%% from angle theta1 to angle theta2

% Get the size of the impedance function output to determine frequency array size
% Test with a sample angle to get the array dimensions
test_tau = tauOblique(z, theta1);
tau_diffuse = zeros(size(test_tau));

for theta = [theta1:dtheta:theta2]
    Ve_tau = tauOblique(z, theta);
    tau_diffuse = tau_diffuse + Ve_tau .* sin(2*theta) .* dtheta;
end

end