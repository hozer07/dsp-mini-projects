% Written in OCTAVE
% Differential PCM demo
clear;clc;
T = 3; % Record your voice for T seconds
Fs = 8000; % Sampling frequency
filter_order = 21; % Order of the prediction filter
bits = 8; % Number of bits to quantize
data = record(T,Fs);
pred_filt = predictor(data,filter_order); % Prediction filter for next sample
[encoded,errors] = dpcm_encoder(data,pred_filt,bits);
decoded = dpcm_decoder(encoded,pred_filt);
SQNR = 10*log10(sum(data.^2)/sum((data'-decoded).^2));
soundsc(decoded,Fs);
plot(encoded);hold on;plot(data);plot(errors);