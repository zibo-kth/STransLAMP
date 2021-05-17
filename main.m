%% STransLAMP (Sound Transmission Loss of Acoustic Metamaterial Panels)
%% Author: Zibo Liu
%% Email: zibo@kth.se
%% Date: 2021-05-18
%% License: An Open Source Code, please cite Zibo's relevant research papers after using the code.
%% Note that there may be assumptions for the metamaterial panels under consideration (e.g., 'thin plate assumption')

clear
clc
close

%%% this is a small trial

addpath(genpath('./src/')); parameter_path; parameter_aluminum; parameter_pvc
parameter_pressure_acoustics

% the following example is the calculation for a curved double wall
%% calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%% panel 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta = pi/3;
t1= 2e-3; % thickness
m1 = rho_al*t1; % surface density
D1 = E_al*t1^3/12/(1-nu_al^2); % bending stiffness
f_critical1 = fcritical(m1, D1);

z1f = impedance_panel(f, m1, D1); % Ve_Z1f = 1i.*omega.*m1.*(1-(f./f_critical1).^2.*sin(theta)^4);


R1 = 1; % radius of the curvature
f_ring1 = fring(E0_al, nu_al, rho_al, R1);

z1c = impedance_shell(f, E0_al, nu_al, rho_al, R1, m1, D1); % Ve_Z1c = 1i.*omega.*m1.*(1-(f./f_critical1).^2.*sin(theta)^4-(f_ring1./f).^2 );

%%%%%%%%%%%%%%%%%%%%%%%%%%% panel 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t2= 2e-3; % thickness
m2 = rho_pvc*t2; % surface density
D2 = E_pvc*t2^3/12/(1-nu_pvc^2); % bending stiffness
f_critical2 = fcritical(m2, D2);
z2f = impedance_panel(f, m2, D2);

R2 = 1; % radius of the curvature

f_ring2 = fring(E0_pvc, nu_pvc, rho_pvc, R2);

z2c = impedance_shell(f, E0_pvc, nu_pvc, rho_pvc, R2, m2, D2); 


%%%%%%%%%%%%%%%%%%%%%%%%%% double panel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d = 40e-3; % distance of two wall
Stiffness = 5.6e5*(1+1i*0.0); % [N/m^2]

s = Stiffness/d; % s = c0^2*rho0/d;
za = @(theta) rho0*c0/cos(theta);
freq_doublewallres  = sqrt(s*(1/m1+1/m2))/2/pi;

% zd = @(theta) z1f(theta) + z2f(theta) + 1i.*omega./s.*(z1f(theta) + za(theta)).*(z2f(theta) + za(theta)); 
% zcd = @(theta) (z1c(theta) + z2c(theta) + 1i*omega./s.*(z1c(theta) + za(theta)).*(z2c(theta) + za(theta))); 

zd = impedance_doublewall(f, s, z1f, z2f, za);
zcd = impedance_doublewall(f, s, z1c, z2c, za);

%%%%%%%%%%%%%%%%%%%%%%%%%% stl %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
% d = semilogx(Ve_freq, fun_stl(Ve_Zd_non),'b--','linewidth',1.8);
c1 = semilogx(f, stl(tauOblique(z1c, theta)),':','linewidth',1.5);
hold on
c2 = semilogx(f, stl(tauOblique(z2c, theta)),':','linewidth',1.5);
cd = semilogx(f, stl(tauOblique(zcd, theta)),'b-.','linewidth',2.5);
cd2 = semilogx(f, stl(tauDiffuse(zcd, pi/180, 0, 78*pi/180)),'-','linewidth',4.5);
plotxlabel = xlabel('Frequency (Hz)'); set(plotxlabel,'FontSize',16, 'interpreter', 'latex');
plotylabel = ylabel('Transmission loss (dB)'); set(plotylabel,'FontSize',16,'interpreter', 'latex');
plotlegend= legend([c1 c2 cd cd2],...
                    'curved panel 1','curved panel 2','curved double wall','diffuse'); set(plotlegend,'Location','Northwest','FontSize',12,'box','off','interpreter','latex');
axis([100 2000 0 80]);
filename = 'nonidentical_c1_c2_cd_mcd_ana'; grid; set(gca,'TickLabelInterpreter','latex')
% savefigure(path_png, path_eps, path_fig, filename)





