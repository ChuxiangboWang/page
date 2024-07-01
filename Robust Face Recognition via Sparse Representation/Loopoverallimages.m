tic
imageFilePath = '/Users/chuxiangbowang/Desktop/test_face_set';

numPeople = 11;
numImagesPerPerson = 3;

identities = cell(numPeople, numImagesPerPerson);

for person = 1:numPeople
  
    for imageNum = 1:numImagesPerPerson
   
        imageFileName = sprintf('person%d.%d.png', person, imageNum); 
        fullImagePath = fullfile(imageFilePath, imageFileName);

        img = imread(fullImagePath);
        if size(img, 3) == 3
            img = rgb2gray(img);
        end
        targetRows = 12; 
        targetCols = 10; 
        resizedImg = imresize(img, [targetRows, targetCols]);
        y = resizedImg(:);

 
        A = overallTrainingSet;

        identity = SRC_ADMM(A, y, class_indices);


        identities{person, imageNum} = identity;
    end
end


disp(identities);
toc