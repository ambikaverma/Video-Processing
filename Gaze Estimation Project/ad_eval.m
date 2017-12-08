%%
clc,close all,clear all,rehash
cal=1;
load('cc_matP');
it=1;

a=imread('/Users/pablocaballerogarces/Dropbox/DV-project/print_ads/wolswagen.jpg');
filepath2='./ad_final1_rp_delete';
outputVideo = VideoWriter(filepath2);
outputVideo.FrameRate=15;
open(outputVideo)
for it=1%:21%[46 1087 1196 869 970 951 502 839 219 904 41 354 59 124 1054 889 406 1216 44 562]
    filepath=strcat('im1ad_wolswagen','.avi');
    v = VideoReader(filepath);
    for ii=1:2:230
        ii
    for j=1:2
        try
            %         tic
            %% Read
            i=read(v,ii+j);
            %% 2Gray
            i_gray=rgb2gray(i);
            %% Detect eyes
            eyeDetector =vision.CascadeObjectDetector('EyePairBig',...
                'MinSize',[60 200]);
            boxes2=step(eyeDetector,rgb2gray(i));
            %% Gamma correction and
            eyes=imcrop(i_gray,[boxes2(1) boxes2(2) boxes2(3) boxes2(4)]);
            eyes=histeq(eyes);
            eyes=eyes(round(size(eyes,1)./7):end,:);
            eye1=eyes(:,1:round(size(eyes,2)/2));
            eye2=eyes(:,round(size(eyes,2)/2)+1:end);
            g=vision.GammaCorrector('Gamma',3);
            eyes=step(g,eyes);
            eyes=imresize(eyes,[70 300]);
            [centersBright, radiiBright] = imfindcircles(eyes,...
                [round(0.15*size(eyes,1)), round(0.4*size(eyes,1))]...
                ,'ObjectPolarity','dark');
            cen(:,j)=[centersBright(1,1),centersBright(2,1)];
            diff_ver=(mean([centersBright(1,2),centersBright(2,2)])+boxes2(2));
            cen2(:,j)=diff_ver;
            %         toc
        catch ME
            continue
        end
    end
    
    x=cen(:,:);
    [idx,C] = kmeans(x(x~=0),2);
    cco=sort(C);
    x=cen2(:,:);
    [idx,C] = kmeans(x(x~=0),1);
    ccoc=sort(C);
    % %% normalize vectors
    est(1)=(cco(1,:) - min(cc(1,:))) / ( max(cc(1,:)) - min(cc(1,:)) );
    est(2)=(cco(2,:) - min(cc(2,:))) / ( max(cc(2,:)) - min(cc(2,:)) );
    est(3)=(ccoc(1,:) - min(cc2(1,:))) / ( max(cc2(1,:)) - min(cc2(1,:)) );
    estimated=[max((1280-mean([f1(est(1)) f2(est(2))])*1280),0),(1024-p3(est(3))*1024)];
    estimated(1)=max(estimated(1),0);
    estimated(1)=min(estimated(1),1280);
    estimated(2)=max(estimated(2),0);
    estimated(2)=min(estimated(2),1024);
    estimated
    q=gHeat(a,estimated);
    imshow(q)
    f=im2frame(q);
    for repeat=1:3
        writeVideo(outputVideo,f)
    end
    clear C
    clear cco
    clear ccoc
    clear cen
    clear cen2
    end
end
close(outputVideo)


% pd = fitdist(error','Normal')
% ci = paramci(pd)
