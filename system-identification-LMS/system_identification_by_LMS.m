clear;clc;
sys_impulse_response =[0.5,-1,-2,1,0.5];
white_noise = sqrt(0.1).*randn(1,1e5);
received = conv(white_noise,sys_impulse_response);
received = received(1:1e5);
mu = 0.6;
%% 5 coefficients
k = 5;
weights_5 = zeros(k,1);
for i = k:1e5
    f = white_noise(i:-1:i-k+1)';
    weights_5 = weights_5 + mu.*f*(received(i)-f'*weights_5);
end
%% 10 coefficients
k = 10;
weights_10 = zeros(k,1);
for i = k:1e5
    f = white_noise(i:-1:i-k+1)';
    weights_10 = weights_10 + mu.*f*(received(i)-f'*weights_10);
end
%% 3 coefficients
k = 3;
weights_3 = zeros(k,1);
for i = k:1e5
    f = white_noise(i:-1:i-k+1)';
    weights_3 = weights_3 + mu.*f*(received(i)-f'*weights_3);
end