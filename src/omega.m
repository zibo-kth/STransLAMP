function omega = omega(f)
% Calculate angular frequency for given frequency array
% Ensure input is properly formatted
f = f(:);  % Convert to column vector
omega = 2*pi*f;
end