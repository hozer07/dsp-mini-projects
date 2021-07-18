function [output_img] = adaptive_median_filter(img)
[rows, cols] = size(img);
window_int = 3:2:7;
conds = zeros(rows,cols,length(window_int));%To keep record of whether the pixel is decided
current2 = zeros(rows,cols);
for window=window_int
    zmin = ordfilt2(img,1,true(window),'symmetric');
    zmax = ordfilt2(img,window*window,ones(window,window),'symmetric');
    zmed = medfilt2(img,[window window],'symmetric');
    cond1 = not(logical(sum(conds,3))).*(zmed>zmin & zmed<zmax);
    cond2 = (img>zmin & img<zmax);
    current1 = img.*uint8(cond1.*cond2);
    cond3 = (cond1==1 & cond2==0);
    current2 = uint8(current2)+uint8(current1) + uint8(zmed).*uint8(cond3);
    conds(:,:,window-2)=cond1.*cond2+cond1.*cond3;
    if (window==7)
        current2 = current2+uint8(zmed).*uint8(not(logical(sum(conds,3))));
    end
end
output_img = current2;
end

