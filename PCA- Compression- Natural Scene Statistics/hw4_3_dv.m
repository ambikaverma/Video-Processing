clear all
close all
clc

file = fopen('natural-image-patches.dat');
A = fread(file);
images = reshape(A,64,64,10000);
f=[];
 for i=1:1:10
 ii=images(:,:,i);
 ii2=ii(:)';
% ii3=ii2-mean(ii2);
 f=cat(1,f,ii2);
 end
c=cov(f);
[p,b,pt]=svd(c);
figure
for j=1:1:15
p2=reshape(p(:,j),64,64);
subplot (4,4,j)
    imshow(p2,[])
end