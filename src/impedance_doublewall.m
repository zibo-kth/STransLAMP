function z = impedance_doublewall(f, s, z1, z2, za)
% Calculate impedance of double wall system
% f - frequency array
% s - stiffness parameter
% z1, z2 - impedance functions for panels 1 and 2
% za - acoustic impedance function

% Ensure frequency array is column vector
f = f(:);

% Calculate double wall impedance using input frequency array
z = @(theta) z1(theta) + z2(theta) + 1i.*2.*pi.*f./s.*(z1(theta) + za(theta)).*(z2(theta) + za(theta));

end