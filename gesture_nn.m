%% Skrypt do generowania modelu g³êbokiej sieci neuronowej

% Wczytanie danych
gestureDatasetPath = fullfile('gesture_dataset');
imds = imageDatastore(gestureDatasetPath, ...
    'IncludeSubFolders', true, 'LabelSource', 'foldernames');

% Reprezentacja danych w postaci obrazów
figure;
perm = randperm(215, 20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end

labelCount = countEachLabel(imds);
img = readimage(imds, 1);
size(img);

% Parametry do uczenia
numTrainFiles = 71;
[imdsTrain, imdsValidation] = splitEachLabel(imds, 0.7, 'randomize');

% Struktura sieci
layers = [
    imageInputLayer([128 128 1])
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,64,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,128,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,64,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',100, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',1, ...
    'Verbose',true, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation);

