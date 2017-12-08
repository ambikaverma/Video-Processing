clear all
close all
clc
vid = VideoReader('C:\Users\user1\Downloads\cat.mp4');
outputVideo = VideoWriter('C:\Users\user1\Downloads\q1_diff2');
outputVideo.FrameRate = vid.FrameRate;
open(outputVideo)
vframes=vid.NumberofFrames;
vid = VideoReader('C:\Users\user1\Downloads\cat.mp4');
framecell=[];
 for i=1:1:vframes-1
i
    frame1 = read(vid,i);
    frame_gray1=double(rgb2gray(frame1));
%     framecell=cat(3,framecell,frame_gray);
frame2 = read(vid,i+1);
    frame_gray2=double(rgb2gray(frame2));

% c=framecell(:,:,i+1);
c=frame_gray2;
j=13; k=9;
% c1=framecell(:,:,i);
c1=frame_gray1;
c2=c(j:end-j+1,k:end-k+1);
%  figure
%  imshow(c1,[])
%  figure
%  imshow(c,[])
n1=16*ones(1,66);
n2=16*ones(1,119);
d=mat2cell(c2,n1,n2);
blk=16;
result=[];
z3=[];
for hor=1:1:66
    for ver=1:1:119
% first step
m=j+(blk)*(hor-1); n=k+(blk)*(ver-1);

sad=[];
for x=m-4:4:m+4
    for y=n-4:4:n+4
        e=c1(x:x+blk-1,y:y+blk-1);
        s=sum(sum(abs(d{hor,ver}-e)));
        sad=[sad s];
    end
end
[smin,ind]=min(sad);
switch ind
    case 1
        p=m-4;q=n-4;
    case 2
        p=m-4;q=n;
    case 3
        p=m-4;q=n+4;
    case 4
        p=m;q=n-4;
    case 5
        p=m;q=n;
    case 6
        p=m;q=n+4;
    case 7
        p=m+4;q=n-4;
    case 8
        p=m+4;q=n;
    case 9
        p=m+4;q=n+4;
end
% second step
sad2=[];
for x2=p-2:2:p+2
    for y2=q-2:2:q+2
        f=c1(x2:x2+blk-1,y2:y2+blk-1);
        s2=sum(sum(abs(d{hor,ver}-f)));
        sad2=[sad2 s2];
    end
end
[smin2,ind2]=min(sad2);
switch ind2
    case 1
        u=p-2;v=q-2;
    case 2
        u=p-2;v=q;
    case 3
        u=p-2;v=q+2;
    case 4
        u=p;v=q-2;
    case 5
        u=p;v=q;
    case 6
        u=p;v=q+2;
    case 7
        u=p+2;v=q-2;
    case 8
        u=p+2;v=q;
    case 9
        u=p+2;v=q+2;
end
%third step
sad3=[];
for x3=u-1:1:u+1
    for y3=v-1:1:v+1
        g=c1(x3:x3+blk-1,y3:y3+blk-1);
        s3=sum(sum(abs(d{hor,ver}-g)));
        sad3=[sad3 s3];
    end
end
[smin3,ind3]=min(sad3);
switch ind3
    case 1
        a=u-1;b=v-1;
    case 2
        a=u-1;b=v;
    case 3
        a=u-1;b=v+1;
    case 4
        a=u;b=v-1;
    case 5
        a=u;b=v;
    case 6
        a=u;b=v+1;
    case 7
        a=u+1;b=v-1;
    case 8
        a=u+1;b=v;
    case 9
        a=u+1;b=v+1;
end
res=c1(a:a+blk-1,b:b+blk-1);
result=[result res];


% writeVideo(outputVideo,uint8(z3))
    end
end
for pos=1:1904:size(result,2)-1904+1
     z2=result(:,pos:1904+pos-1);
    z3=cat(1,z3,z2);
end
diff=abs(c2-z3);
z4=padarray(diff,[12 8]);
% diff2 = imadjust(diff/255);
z4 = (z4 - min(z4(:))) / (max(z4(:)) - min(z4(:)));
    z4 = im2uint8(z4);

writeVideo(outputVideo,z4)
end
close(outputVideo)
 
%  for pos=1:1904:size(result,2)-1904+1
%      z2=result(:,pos:1904+pos-1);
%     z3=cat(1,z3,z2);
% end
% diff=abs(c2-z3);
% diff2 = imadjust(diff,stretchlim(diff),[]);
% clc