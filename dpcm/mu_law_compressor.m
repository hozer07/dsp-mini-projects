%% u Law compression, accepts normalized input |s|<=1
function retval = mu_law_compressor (s,mu)
  retval = log(1+mu*abs(s))./log(1+mu).*sign(s);
