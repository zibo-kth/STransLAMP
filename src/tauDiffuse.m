function tau_diffuse = tauDiffuse(z, dtheta, theta1, theta2)

%%%% this function reture the diffuse transmission coefficient of a panel
%%%% from angle theta1 to angle theta2

parameter_pressure_acoustics

tau_diffuse = zeros(length(f),1);

for theta = [theta1:dtheta:theta2]
    Ve_tau = tauOblique(z, theta);
    tau_diffuse = tau_diffuse +  Ve_tau*sin(2*theta)*dtheta;
end

end