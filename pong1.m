% pong1
% [press left and right keyboard arrows to move block]

clear; clc; clf;
% ------------------- setup ------------------------------------------ %
set(gcf,'units', 'normal','position', [.1 .1 .8 .8],...   % figure props                          
  'KeyPressFcn',@controls,   'color', [.6 .6 .8]);                                     

set(gca,'color',  'black','position', [.05 .05 .9 .9],... % axis props
         'XLim', [-5 100],    'YLim', [-5 100],...
        'XTick',       [],   'YTick', [],'nextplot',  'add')
             
global blockPos; blockPos = 0;                            % make a block                                                                         
blockVertices = @(x) [x-5,-2;
                      x+5,-2; 
                      x+5, 0; 
                      x-5, 0];                     
blockObj = patch('Vertices', blockVertices(blockPos),...
                    'Faces', [1 2 3 4],'FaceColor', [.6 .8 .6]);
       
ballPos  = [ 10; 10];                                     % make a ball            
ballVel  = [ .5;  1];                               
ballObj  = plot(ballPos(1),ballPos(2),'.',...
              'MarkerSize',50,'color',[.8 .6 .6]);        

% ----------------------- main loop ------------------------------------ %        
while 0 < 1                                              
    tic;                                                  % start timer
    
    if ballPos(1) > 100 || ballPos(1) < 0                 
        ballVel(1) = -ballVel(1);                         % side bounce
    elseif ballPos(2) > 100
        ballVel(2) = -ballVel(2);                         % wall bounce
    elseif ballPos(2) < 0 
        if abs(blockPos - ballPos(1)) < 5                 % block bounce
            ballVel(2) = -ballVel(2);
        else                                              % miss --> close
            close all; break;                              
        end
    end 
    
    ballPos = ballPos + ballVel;                          % update ball         
    set(ballObj,'XData',ballPos(1),'YData',ballPos(2));
    set(blockObj,'Vertices',  blockVertices(blockPos));   
    pause(1/60 - toc);                                    % 60 fps
end

% -------------------- function(s) ------------------------------------ %
function controls(~, event)                               % buttons
    global blockPos                             
    switch event.Key
        case 'leftarrow'
            blockPos = blockPos - 5;            
        case 'rightarrow'
            blockPos = blockPos + 5;     
    end
end