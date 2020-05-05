close all;

% Initialize a camera - make sure it is no.1 device
if ~exist('camera', 'var')
   camera = webcam(1);
end

% Uncomment only on first boot
if ~exist('net', 'var')
    load('net_model.mat');
end


% Input image
inputSize = net.Layers(1).InputSize(1:2);
classes = net.Layers(end).Classes;

h = figure;
h.Position(3) = 2*h.Position(3);
ax_im1 = subplot(1,2,1);
ax_im2 = subplot(1,2,2);
ax_im2.ActivePositionProperty = 'position';

% pong2
% [press left and right keyboard arrows to move block]

% ----------------------------- Setup -------------------------------- %
figure()
axis = axes;
axis.Color = 'black';
axis.XLim  =  [-10, 10];
axis.YLim  =  [-10, 10];

ball = line;
ball.Color = 'blue';
ball.Marker = '.';
ball.MarkerSize = 50;
ball.XData = 5;
ball.YData = 4;
ball.UserData.speed_x = 10;
ball.UserData.speed_y = 10;

block = line;
block.Color = 'yellow';
block.LineWidth = 5;
block.UserData.speed_x = 0;
block.XData = [ 3, 5];
block.YData = [-9,-9];

set( gcf, "WindowKeyPressFcn",   { @gesture_sel, block } );

% -------------------- Main loop for the program ----------------------- %
while 1 > 0
    % Display and classify the image
    im = snapshot(camera);
    im = imresize(im,inputSize);
    im_g = rgb2gray(im);
    image(ax_im1, im_g)
    
    [label,score] = classify(net,im_g);
    title(ax_im1,{char(label),num2str(max(score),2)});

    % Select the top five predictions
    [~,idx] = sort(score,'descend');
    idx = idx(3:-1:1);
    scoreTop = score(idx);
    classNamesTop = string(classes(idx));

    % Plot the histogram
    barh(ax_im2,scoreTop)
    title(ax_im2,'Top 3')
    xlabel(ax_im2,'Probability')
    xlim(ax_im2,[0 1])
    yticklabels(ax_im2,classNamesTop)
    ax_im2.YAxisLocation = 'right';

    drawnow
    tic;
    
    if (label == 'c') && (min(block.XData) > -10)
        block.UserData.speed_x = -20;
    elseif (label == 'v') && (max(block.XData) < 10)
        block.UserData.speed_x =  20;
    else
        block.UserData.speed_x = 0;
    end
    
    if ball.XData < -10 || ball.XData >  10        
        ball.UserData.speed_x = - ball.UserData.speed_x;
    end
    
    if ball.YData > 10
        ball.UserData.speed_y = - ball.UserData.speed_y;
    end
    
    if ball.YData < - 9
        if ball.XData < min(block.XData) || ball.XData > max(block.XData)
            disp("You lost!")
            clear cam;
            close all; break;
        else 
            ball.UserData.speed_y = - ball.UserData.speed_y;
        end
    end
    
    pause(.01);
    ball.XData  = ball.XData  + ball.UserData.speed_x*toc;
    ball.YData  = ball.YData  + ball.UserData.speed_y*toc;
    block.XData = block.XData + block.UserData.speed_x*toc;
    
end

% -------------------------- Functions ------------------------------ %
function keyboard_down( figure, event, block)
    switch event.Key
        case 'leftarrow',  block.UserData.speed_x = -20; 
        case 'rightarrow', block.UserData.speed_x =  20;
    end
end

function keyboard_up( figure, event, block)
    block.UserData.speed_x = 0;
end

function gesture_sel( figure, label, block)
    if label == 'c'
        block.UserData.speed_x = -20;
    elseif label == 'v'
        block.UserData.speed_x =  20;
    else
        block.UserData.speed_x = 0;
    end
end

