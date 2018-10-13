%SHAPE RECONGNITION FUAD AHMAD
clc;

D=imread('shapes.jpg'); % reading image
E=rgb2gray(D); % changing it to grayscale image


BW1 = imgaussfilt(E, 2); % applying gaussfilter


SE= strel("arbitrary", [100 100]); %morph structure element to preprocess on image 
BW1 = imdilate(BW1, SE); %dilation on image
SE2= strel("line", 6, 45);%structure line
BW1 = imerode(BW1, SE2); %eroding lines 


M = BW1 >100; %converting to binary image by thresholding


BW2 = edge(M); % finding edges of the shapes
BW2 = imfill(BW2, 'holes'); % filling holes

P = BW2;


SE4 = strel("sphere",13);
P = imopen(P, SE4);%preparing circles for each shape to subtract and get how manny edges left



P = imsubtract(BW2, P);


SE5 = strel("cube", 3);
P = imdilate(P ,SE5);

SE8 = strel("cube", 2);
P = imerode(P ,SE8);

SE9 = strel("rectangle", [3 1]);
P = imdilate(P, SE9);
%preprocessing subtracted image 



[B,L] = bwboundaries(BW2); 


stats = regionprops(L, 'all');
%regionproping to learn details of the shapes

W = bwlabel(P);%laleing to learn how many edges left

smls= regionprops(W, 'all');
imshow(D);
hold on;

for i=1 : length(stats)
    cnt=0;
    for j=1 : length(smls)
        if(stats(i).BoundingBox(1)-3<=smls(j).BoundingBox(1) && stats(i).BoundingBox(1)+ stats(i).BoundingBox(3)+3 >=smls(j).BoundingBox(1)+ smls(j).BoundingBox(3) && stats(i).BoundingBox(2)-3 <= smls(j).BoundingBox(2) && stats(i).BoundingBox(2) + stats(i).BoundingBox(4)+3 >= smls(j).BoundingBox(2)+ smls(j).BoundingBox(4))
            %this loop counting how many edges shape have
            cnt = cnt+1;
        end
    end
    %from here it is checking which shape it is after it is edge count
    %other details we got from regionprops we use regionprops details to
    %lessen error
    if(cnt==3)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Triangle', 'Color', 'r');
    elseif(cnt==4 && stats(i).Eccentricity >0.75)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Rectangle', 'Color', 'r');
    elseif(cnt==4)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Square', 'Color', 'r');
    elseif(cnt==5 && stats(i).Solidity>0.5 && stats(i).Solidity <0.9)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Star*5', 'Color', 'r');
    elseif(cnt==6 && stats(i).Solidity>0.5 && stats(i).Solidity <0.9)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Star*6', 'Color', 'r');
    elseif(cnt==5)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Pentagon', 'Color', 'r');
    else
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Circle', 'Color', 'r');       
    end
    
end


