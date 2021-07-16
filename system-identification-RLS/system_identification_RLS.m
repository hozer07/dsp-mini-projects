clear;clc;
identified_system_order = 21; % length of impulse response of calculated system
data_length = 1e5;
data = randn(1,data_length);
delta = 1e-4;
R_inv = eye(identified_system_order)./delta; % initial guess for inverse of correlation matrix R
system_length = 11; % length of impulse response of system to identify
system_impulse_response = randn(1,system_length);
system_impulse_response = system_impulse_response./sqrt(sum(system_impulse_response.^2));
system_output_data = conv(data,system_impulse_response);
system_output_data = system_output_data(1:data_length);
identified_system = zeros(identified_system_order,1); % initial guess
for t = identified_system_order:data_length
    q_vector = flipud(conj(data(t-identified_system_order+1:t)'));
    k_of_t = R_inv*q_vector./(1+q_vector'*R_inv*q_vector);
    error_t = system_output_data(t) - q_vector'*identified_system;
    identified_system = identified_system + k_of_t.*error_t;
    R_inv = (eye(identified_system_order) - k_of_t*q_vector')*R_inv;
end
identified_system = identified_system.';