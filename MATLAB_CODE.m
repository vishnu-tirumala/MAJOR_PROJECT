
%% clear the command window
clc
% clear the workspace
clear
% close the image viewer app
close all
warning off
%% open the input image
[filename,pathname] =uigetfile('*.*');
x =imread([pathname,filename]);% READ THE IMAGE
figure; imshow(x); title('RGB Image');

%%to resize the input image%%

x=imresize(x,[200 178]);

%% train the inoput images 
matlabroot='C:\Users\soura\Desktop\matlab code\dataset';

Data=imageDatastore(matlabroot,'IncludeSubfolders',true,'LabelSource','foldernames');
%% ------------ CRAETE CNN LAYERS -------------------%%
% % image input layer inputs images to a network 
layers=[imageInputLayer([200 178 3]) 
%      The layer convolves the input by moving the filters along the input vertically and horizontally and computing the dot product of the weights and the input, and then adding a bias term.
convolution2dLayer(5,20)
% threshouling layers
    reluLayer
% A max pooling layer performs down-sampling by dividing the input into rectangular pooling regions, and computing the maximum of each region.    
   maxPooling2dLayer(2,'stride',2)
   
       convolution2dLayer(5,20)
       
     reluLayer
     
 maxPooling2dLayer(2,'stride',2)

%A fully connected layer multiplies the input by a weight matrix and then adds a bias vector.
 fullyConnectedLayer(2)
%  A softmax layer applies a softmax function to the input.
 softmaxLayer
%  Create classification output layer
 classificationLayer()]

% % Options for training deep learning neural network
options=trainingOptions('sgdm','MaxEpochs',15,'initialLearnRate',0.0001,'Plots','training-progress');

%Train neural network for deep learning
convnet=trainNetwork(Data,layers,options);
% CLASSIFICATION 

% Classify data using a trained deep learning neural network
output=classify(convnet,x);

tf1=[];

for ii=1:2
    
    st=int2str(ii);
    
    tf=ismember(output,st);
%     Array elements that are members of set array
    tf1=[tf1 tf];
    
end
output=find(tf1==1);

if output==1
    
    msgbox('dry- do irrigate')
    
elseif output==2
    
    msgbox('wet')
  
end

%%  HARDWARE CONNECTED

instrumentObjects=instrfind;  % don't pass it anything - find all of them. 
    delete(instrumentObjects) 
a=serial('COM5','BaudRate',9600);
  fopen(a);
                
           if output == 1
             fwrite(a,'A');  
           elseif output == 2
               fwrite(a,'B');
           end
fclose(a);

