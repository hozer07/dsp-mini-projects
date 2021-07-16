clear;clc;
I = imread('test.jpg');
message = input("Type message to hide, end your message with '---':");
stego_img = lsb_text_encode(I,message);
decoded_message = lsb_text_decode(stego_img);
imshow(I);figure,imshow(stego_img);
disp(decoded_message);