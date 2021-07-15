clear;clc;
frame_length = 120;
pitch_lim = unique(round(frame_length.*(24:120)./160));
filt_ord = 10;

% % % Uncomment if you want to record your voice
% Fs = 8000;
% T = 3; % record duration
% recObj = audiorecorder;
% recordblocking(recObj, T);
% data_main = getaudiodata(recObj);
% stop = round(T*Fs/frame_length)*frame_length;
% data = data_main(1:stop);

[data_main,Fs] = audioread('test.wav');
stop = floor(length(data_main)/frame_length)*frame_length;
data = data_main(1:stop);

frame_count = stop/frame_length;
data = reshape(data,[frame_length frame_count]);
coefficients = zeros(frame_count,filt_ord);
gains = zeros(frame_count,1);
voiced = gains;
for i=1:frame_count
    coefficients(i,:) = coef_predictor(data(:,i)',filt_ord);
    ra = xcorr(coefficients(i,:));
    ra = ra(round(length(ra)/2)+1:length(ra));
    re = xcorr(data(:,i)');
    re = re(round(length(re)/2):length(re));
    gains(i) = sqrt(re(1)+sum(re(2:filt_ord+1).*coefficients(i,:)));
    re = conv(re,ra);
    re = re(1:frame_length);
    re = re./re(1);
    re = re(pitch_lim);
    [pitch,index] = max(re);
    if(pitch>=0.25)
      voiced(i) = index+pitch_lim(1)-1;
    end 
end
reconstruct = zeros(1,stop);
clear temp;
for i=1:frame_count
    excitation = randn(1,frame_length);
    excitation = excitation./sqrt(sum(excitation.^2));
    if(voiced(i)>0)
        excitation = zeros(1,frame_length);
        excitation(1:voiced(i):frame_length) = 1;
        excitation = excitation./sqrt(sum(excitation.^2));
    end
    if(isnan(coefficients(i,1)) || sum(coefficients(i,:).^2)<1e-8),temp = zeros(1,frame_length);
    else
        temp = filter(gains(i),[1 coefficients(i,:)],excitation);
    end
    reconstruct((i-1)*frame_length+1:i*frame_length)=temp;
end
sound(reconstruct,Fs);
% pause(ceil(stop/Fs));
% sound(data_main,Fs);
plot(reconstruct);hold on;
plot(data_main);