clear;
N = 9; % number of frequency domain samples, or FIR filter order
frequency_sample_indexes = 0:N-1;
w = (2*pi.*frequency_sample_indexes/N)';
cut_off_frequency = pi/2;
sampled_magnitude_response = double(w<cut_off_frequency)+double(2*pi-w<cut_off_frequency);
phase_response_of_designed_filter= -floor(N/2).*w; % impulse response is delayed to make the filter causal
F = exp(1i.*meshgrid(0:N-1).*w); % IDFT matrix
designed_filter_impulse_response = F\(sampled_magnitude_response.*exp(1i.*phase_response_of_designed_filter));
stem(real(designed_filter_impulse_response),'.','MarkerSize',15);grid on; %h[n] was imaginary but with 0 imaginary coefficients
title('Impulse Response of Causal LPF');
xlabel('n');
ylabel('h[n]');
frequency_response_of_designed_filter = fft(designed_filter_impulse_response,1024);
freq_range=linspace(0,2*pi,1024);
frequency_sample_indexes=round(1024/N).*frequency_sample_indexes;
figure,plot(freq_range,abs(frequency_response_of_designed_filter),'-p','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerSize',7,'MarkerIndices',1+frequency_sample_indexes,'LineWidth',2);
hold on;
title('|H(e^j^w)|');
xlabel('Frequency');
ylabel('Magnitude');
xlim([0 2*pi]);
xticks(0:pi/2:2*pi);
xticklabels({'0','pi/2','pi','3pi/2','2pi'});
grid on;
range = linspace(0,2*pi,1024);
plot(freq_range,double(range<cut_off_frequency | range>2*pi-cut_off_frequency),'LineWidth',2);
legend('Designed LPF','Ideal LPF','location','North');