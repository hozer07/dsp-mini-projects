clear;clc;
% Data generation
sawtooth = repmat(linspace(-1,1,2000),[1 5]);
exponential_pulse_train = exp(linspace(-5,0,1e4));
sinusoidal = sin(linspace(0,1e4,1e4)./33);
random_sequence = sqrt(1/25).*randn(1,1e4);
% PCM outputs for each sequence
compressed_sawtooth = mu_law_compressor(sawtooth,255);
quantized_sawtooth = quantizer(compressed_sawtooth,8);
final_sawtooth = mu_law_expander(quantized_sawtooth,255);

compressed_exp = mu_law_compressor(exponential_pulse_train,255);
quantized_exp = quantizer(compressed_exp,8);
final_exp = mu_law_expander(quantized_exp,255);

compressed_sin = mu_law_compressor(sinusoidal,255);
quantized_sin = quantizer(compressed_sin,8);
final_sin = mu_law_expander(quantized_sin,255);

compressed_random = mu_law_compressor(random_sequence,255);
quantized_random = quantizer(compressed_random,8);
final_random = mu_law_expander(quantized_random,255);

SQNR = zeros(1,4);
SQNR(1) = 10.*log10(sum(sawtooth.^2)./sum((sawtooth-final_sawtooth).^2));
SQNR(2) = 10.*log10(sum(exponential_pulse_train.^2)./sum((exponential_pulse_train-final_exp).^2));
SQNR(3) = 10.*log10(sum(sinusoidal.^2)./sum((sinusoidal-final_sin).^2));
SQNR(4) = 10.*log10(sum(random_sequence.^2)./sum((random_sequence-final_random).^2));
plot(final_sawtooth);figure,
plot(final_exp);figure,
plot(final_sin);figure,
plot(final_random);figure,
bar(SQNR);ylim([min(SQNR-5) max(SQNR+5)]);
labels = ["Sawtooth";"Exponential Pulse Train";"Sinusoidal";"Random Sequence"];
set(gca, 'XTickLabel', labels);