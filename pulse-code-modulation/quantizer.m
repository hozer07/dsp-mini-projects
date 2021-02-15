%%Uniform quantizer
%% s = input signal b = bits
function retval = quantizer (s,b)
  step_size = 2^(-b+1);
  retval = round(s./step_size).*step_size;
