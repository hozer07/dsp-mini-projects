% Implements the feedback loop for DPCM
% Uses logarithmic compression
function [retval,errors] = dpcm_encoder (s,pred_filt,bits)
    filt_register = zeros(1,length(pred_filt));
    s_predicted = 0;
    retval = zeros(1,length(s));
    errors = retval;
    for i=1:length(s)
      quantizer_inp = s(i)-s_predicted;
      quantizer_inp2 = mu_law_compressor(quantizer_inp,255);
      retval(i)=quantizer(quantizer_inp2,bits);
      errors(i) = quantizer_inp;
      s_hat = s_predicted+quantizer_inp;
      filt_register(2:length(filt_register)) = filt_register(1:length(filt_register)-1);
      filt_register(1) = s_hat;
      s_predicted = sum(filt_register.*pred_filt');
    end
