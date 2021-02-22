function retval = dpcm_decoder (s,pred_filt)
    filt_register = zeros(1,length(pred_filt));
    retval = zeros(1,length(s));
    s_predicted = 0;
    for i=1:length(s)
      temp = mu_law_expander(s(i),255)+s_predicted;
      filt_register(2:length(filt_register)) = filt_register(1:length(filt_register)-1);
      filt_register(1) = temp;
      retval(i)=temp;
      s_predicted = sum(filt_register.*pred_filt');      
    end
