clear cam; clc;
camList = webcamlist;
cam = webcam(2);
gesture= 'down';
% Preview
for idx = 121:180
    img = snapshot(cam);
    image(img);
    %imshow(img);
    imwrite(img, (join([gesture,num2str(idx),'.png'])))
    pause(0.5);
end
clear cam

