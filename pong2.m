% pong2
% [press left and right keyboard arrows to move block]

clear; clc; close all;
% ----------------------------- Setup -------------------------------- %
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

set( gcf, "WindowKeyPressFcn",   { @keyboard_down, block } );
set( gcf, "WindowKeyReleaseFcn", { @keyboard_up,   block } );

% --------------------------- Loop ---------------------------------- %
while 1
    tic;
    
    if ball.XData < -10 || ball.XData >  10        
        ball.UserData.speed_x = - ball.UserData.speed_x;
    end
    
    if ball.YData > 10
        ball.UserData.speed_y = - ball.UserData.speed_y;
    end
    
    if ball.YData < - 9
        if ball.XData < min(block.XData) || ball.XData > max(block.XData)
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