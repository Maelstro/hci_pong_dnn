%camera = webcam;


% Input image
inputSize = net.Layers(1).InputSize(1:2);
classes = net.Layers(end).Classes;

h = figure;
h.Position(3) = 2*h.Position(3);
ax1 = subplot(1,2,1);
ax2 = subplot(1,2,2);
ax2.ActivePositionProperty = 'position';
while ishandle(h)
    % Display and classify the image
    im = snapshot(camera);
    im = imresize(im,inputSize);
    im_g = rgb2gray(im);
    im_g = im_g(:,:,1);
    image(ax1, im_g)
    
    [label,score] = classify(net,im_g);
    title(ax1,{char(label),num2str(max(score),2)});

    % Select the top five predictions
    [~,idx] = sort(score,'descend');
    idx = idx(3:-1:1);
    scoreTop = score(idx);
    classNamesTop = string(classes(idx));

    % Plot the histogram
    barh(ax2,scoreTop)
    title(ax2,'Top 3')
    xlabel(ax2,'Probability')
    xlim(ax2,[0 1])
    yticklabels(ax2,classNamesTop)
    ax2.YAxisLocation = 'right';

    drawnow
end