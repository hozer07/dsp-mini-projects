%% y = quantized signal
function retval = mu_law_expander (y,mu)
  retval = ((1+mu).^(abs(y))-1)./mu.*sign(y);  
