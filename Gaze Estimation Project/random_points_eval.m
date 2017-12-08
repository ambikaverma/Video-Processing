%%
clc,close all,clear all,rehash
cal=1;
load('cc_matP');
it=1;

[~,n]=unix('ls rp1*');
n=strrep(n,'\n','');
nam=strsplit(n,'.avi');


filepath2=strcat('./rp_final',num2str(1),'rp_1');
outputVideo = VideoWriter(filepath2);
outputVideo.FrameRate=30;
open(outputVideo)
for it=1:20%:21%[46 1087 1196 869 970 951 502 839 219 904 41 354 59 124 1054 889 406 1216 44 562]
    it
    filepath=strcat(strtrim(nam{it}),'.avi');
    v = VideoReader(filepath);
    m=strsplit(nam{it},'_x_');
    val=strsplit(m{2},'_y_');
    val=[str2num(val{1}) str2num(val{2})];
    for j=10:40
        try
            %         tic
            %% Read
            i=read(v,j);
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
    error(it)=abs(val(2)-max((1280-mean([f1(est(1)) f2(est(2))])*1280),0));
    est(3)=(ccoc(1,:) - min(cc2(1,:))) / ( max(cc2(1,:)) - min(cc2(1,:)) );
    errorV(it)=abs(val(1)-(1024-p3(est(3))*1024));
    estimated=[max((1280-mean([f1(est(1)) f2(est(2))])*1280),0),(1024-p3(est(3))*1024)];
    estimated(1)=max(estimated(1),0);
    estimated(1)=min(estimated(1),1280);
    estimated(2)=max(estimated(2),0);
    estimated(2)=min(estimated(2),1024);
    a=zeros(1024,1280,3);
    a(max(val(1)-31,1):min(val(1)+31,1024)...
        ,max(val(2)-31,1):min(val(2)+31,1280),3)=1;
    q=gHeat(a,estimated);
    imshow(q)
%    f=im2frame(q);
%     for repeat=1:30
%         writeVideo(outputVideo,f)
%     end
    clear C
    clear cco
    clear ccoc
    clear cen
    clear cen2
    [mean(error),std(error)]
    [mean(errorV),std(errorV)]
end
close(outputVideo)

[mean(error),std(error)]./1280
[mean(errorV),std(errorV)]./1024

% pd = fitdist(error','Normal')
% ci = paramci(pd)
