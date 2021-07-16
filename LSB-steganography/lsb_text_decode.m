function [message] = lsb_text_decode(stego_img)
temp = [];
message = [];
[v,h,d] = size(stego_img);
message_count = 0;
for v_ind=1:v
    for h_ind=1:h
        for d_ind=1:d
            binary_codeword = de2bi(stego_img(v_ind,h_ind,d_ind));
            temp = [temp binary_codeword(1)];
            message_count = message_count + 1;
            if(mod(message_count,7)==0)
                message = [message char(bi2de(temp))];
                temp = [];
                if(length(message)>=3)
                    if(isequal(message(end-2:end),'---')),message = strcat(message(1:end-3));return;end
                end
            end
        end
    end
end
end

