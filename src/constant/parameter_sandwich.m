
    tf = 0.002; %[m] thickness of the face
    tc = 0.02; % 0.0244; %[m]thickness of the core
    d = tf + tc; % the distance between the centroids of the faces

    rhof = 2700; %[kg/m^3] density of the face - aluminum
%     rhoc = 920; %[kg/m^3] density of the core
    rhoc = 500; %[kg/m^3] density of the core
    
    mf = rhof*tf;
    mc = rhoc*tc;

    E0f = 6.9e10; %[Pa] the Young's modulus
    E0c = 8e8; %[Pa]
%     E0c = 4e9; %[Pa]

    nuf = 0.3; 
    nuc = 0.3;

    etaf = 0.001;
    etac = 0.01;
    eta_tot = 2*etaf+etac;
    
    Ef = E0f*(1+1i*etaf);
    Ec = E0c*(1+1i*etac);
    
    % Gf = 
    G0c = E0c/2/(1+nuc);
    Gc = Ec/2/(1+nuc);
    lambdac = Ec*nuc/(1+nuc)/(1-2*nuc);  % lame coefficient

    Df = Ef*tf^3/12/(1-nuf^2); %[Pa] bending stiffness of the face
    Dc = Ec*tc^3/12/(1-nuc^2); %[Pa] bending stiffness of the core
    Ds = 2*Df + Ef/(1-nuf^2)*tf*d^2/2 + Dc;
    %%
    Gs = G0c*d^2/tc;
    I = rhof*(tf*tc^2/2+tf^2*tc+2/3*tf^3) + rhoc*tc^3/12; %[kg*m^2] Momentum of Inertia
    m = mc+ 2*mf; %[kg/m^2] surface mass density
