function retval = predictor (s,p)
  corr_vec_t = xcorr(s,p);
  half = round(numel(corr_vec_t)/2);
  corr_vec = corr_vec_t(half+1:half+p);
  len = length(corr_vec);
  corr_mat = zeros(len);
  for i=1:numel(corr_vec)
    corr_mat(i,:)=corr_vec_t(half+i-1:-1:half+i-p);
  end
  retval = corr_mat\corr_vec;
