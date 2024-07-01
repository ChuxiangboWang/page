clc;
clear all;

basePath = '/Users/chuxiangbowang/Desktop/761 project/face_data';

classPaths = {
    '0'; '1'; '2'; '3'; '4';
    '5'; '6'; '7'; '8'; '9'; '10'
};


numImagesPerClass = 54;

targetRows = 12;
targetCols = 10;
trainingData = cell(1, length(classPaths));


for i = 1:length(classPaths)
    folderPath = fullfile(basePath, classPaths{i});
    files = dir(fullfile(folderPath, '*.png')); 

    if length(files) < numImagesPerClass
        warning('Class %d has less than %d images. Found only %d images.', i, numImagesPerClass, length(files));
        continue; % Skip to the next class
    end

   
    classMatrix = zeros(targetRows * targetCols, numImagesPerClass);

    
    for j = 1:numImagesPerClass
        img = imread(fullfile(folderPath, files(j).name));
       % gray 
        if size(img, 3) == 3
            img = rgb2gray(img);
        end
        % Resize
        img = imresize(img, [targetRows, targetCols]);
        imgVector = img(:);
        classMatrix(:, j) = imgVector;
    end

    trainingData{i} = classMatrix;
end

overallTrainingSet = horzcat(trainingData{:});

numClasses = length(classPaths); 
numImagesPerClass = 54; 

class_indices = [];
for i = 1:numClasses
    
    class_indices = [class_indices; i * ones(numImagesPerClass, 1)];
end
