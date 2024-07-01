
imageFilePath = '/Users/chuxiangbowang/Desktop/test_face_set';
imageFileName = 'person1.11.jpg'; 
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

identity = SRC_ADMM2(A, y, class_indices)




%identity = SRC_ADMM(A, y, class_indices)
%identity2 = SRC_L2Norm(A, y, class_indices)
%identity0 = SRC_OMP(A, y, class_indices)