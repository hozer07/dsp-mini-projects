function [stego_img] = lsb_text_encode(plain_img,message)
stego_img = plain_img;
[v,h,d] = size(plain_img);
dec_arr = uint8(message);
bit_arr = de2bi(dec_arr');
bit_arr2 = reshape(bit_arr',1,size(bit_arr,1)*size(bit_arr,2));
message_len = length(bit_arr2);
message_count = 1;
for v_ind=1:v
    for h_ind=1:h
        for d_ind=1:d
            binary_codeword = de2bi(plain_img(v_ind,h_ind,d_ind));
            binary_codeword(1) = bit_arr2(message_count);
            stego_img(v_ind,h_ind,d_ind) = bi2de(binary_codeword);
            message_count = message_count + 1;
            if(message_count==message_len)
                return;
            end
        end
    end
end
end

