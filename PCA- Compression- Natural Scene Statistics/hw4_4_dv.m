clear all
close all
clc
v = VideoReader('C:\Users\user1\Downloads\q1_diff2.avi');
outputVideo = VideoWriter('C:\Users\user1\Downloads\q1_dct2');
outputVideo.FrameRate = v.FrameRate;
v.NumberofFrames
v = VideoReader('C:\Users\user1\Downloads\q1_diff2.avi');
i=0;
open(outputVideo)
cr1=[];
cr2=[];
%%
while hasFrame(v)
    frame = readFrame(v);
    frame_gray=double(rgb2gray(frame));
dctn2 = @(block_struct) dct2(block_struct.data);
C = blockproc(frame_gray,[8 8],dctn2,'PadPartialBlocks',true);
%%
mquant=1;
q=mquant*[16 11 10 16 24 40 51 61;
12 12 14 19 26 58 60 55;
14 13 16 24 40 57 69 56;
14 17 22 29 51 87 80 62;
18 22 37 56 68 109 103 77;
24 35 55 64 81 104 113 92;
49 64 78 87 103 121 120 101;
72 92 95 98 112 100 103 99];
B2 = blockproc(C,[8 8],@(block_struct) block_struct.data./q);
B4=round(B2);
c=nnz(B4);
c2=numel(B4);
r2=c/c2;
cr1=[cr1 r2];
B5= blockproc(B4,[8 8],@(block_struct) q.* block_struct.data);
c=nnz(B5);
c2=numel(B5);
r=c2/c;
cr2=[cr2 r];
%%
invdct2 = @(block_struct) idct2(block_struct.data);
I2 = blockproc(B5,[8 8],invdct2);
writeVideo(outputVideo,uint8(I2))
i=i+1
end
close(outputVideo)