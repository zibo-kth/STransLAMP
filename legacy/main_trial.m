clear
clc
close


parameter_path
parameter_aluminum
parameter_pressure_acoustics
parameter_pvc
%% use function to calculate the stl
theta = pi/3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% panel data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rho_al = 270
t1= 20e-3; % thickness
m1 = rho_al*t1; % surface density
D1 = E_al*t1^3/12/(1-nu_al^2); % bending stiffness

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculate impedance %%%%%%%%%%%%%%%%%%%%%
zFlat = impedance_panel(f, m1, D1); % Ve_Z1f = 1i.*omega.*m1.*(1-(f./f_critical1).^2.*sin(theta)^4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% curved panel data %%%%%%%%%%%%%%%%%%%%%%%%
R1 = 1; % radius of the curvature

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% calculate impedance %%%%%%%%%%%%%%%%%%%%%%%
zCurved = impedance_shell(f, E0_al, nu_al, rho_al, R1, m1, D1); % Ve_Z1c = 1i.*omega.*m1.*(1-(f./f_critical1).^2.*sin(theta)^4-(f_ring1./f).^2 );

%%

dtheta = 0.1*pi/180;
theta1 = 0*pi/180;
theta2 = 80*pi/180;

figure(1)
% d = semilogx(Ve_freq, fun_stl(Ve_Zd_non),'b--','linewidth',1.8);
p1 = semilogx(f, stl(tauOblique(zFlat, theta)),'b-','linewidth',1.5);
hold on
p2 = semilogx(f, stl(tauDiffuse(zFlat, dtheta, theta1, theta2)),'r-.','linewidth',1.5); %dtheta theta1 theta2
hold off
plotxlabel = xlabel('Frequency (Hz)'); set(plotxlabel,'FontSize',16, 'interpreter', 'latex');
plotylabel = ylabel('Transmission loss (dB)'); set(plotylabel,'FontSize',16,'interpreter', 'latex');
plotlegend= legend([p1 p2],...
                    'oblique','diffuse'); set(plotlegend,'Location','Northwest','FontSize',12,'box','off','interpreter','latex');
axis([100 4000 0 100]);
filename = '-'; grid; set(gca,'TickLabelInterpreter','latex')
% savefigure(path_png, path_eps, path_fig, filename)