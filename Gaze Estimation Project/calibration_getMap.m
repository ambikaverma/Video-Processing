clc,close all,clear all,rehash
cal=1;
%%
point=1;
for it2=[1:4]
for it=[1:5]
    it
    x=(it-1)*1280./4;%PM(2,4)*rand(1);
    y=(it2-1)*1024./3;
    filepath=strcat('./cal',num2str(cal),'dvd_x_',num2str(y),'_y_',num2str(x),'.avi');
    v = VideoReader(filepath);
    for j=10:40
        try
            tic
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
%             eye1=eyes(:,1:round(size(eyes,2)/2));
%             eye2=eyes(:,round(size(eyes,2)/2)+1:end);
            g=vision.GammaCorrector('Gamma',3);
            eyes=step(g,eyes);
            eyes=imresize(eyes,[70 300]);
            [centersBright, radiiBright] = imfindcircles(eyes,...
                [round(0.15*size(eyes,1)), round(0.4*size(eyes,1))]...
                ,'ObjectPolarity','dark');
            cent(:,j,it,it2)=[centersBright(1,1),centersBright(2,1)];
            diff_ver=(mean([centersBright(1,2),centersBright(2,2)])+boxes2(2));
            cent2(:,j,it,it2)=diff_ver;
            toc
        catch ME
            if (strcmp(ME.identifier,'MATLAB:catenate:dimensionMismatch'))
                msg = ['Dimension mismatch occurred: First argument has ', ...
                    num2str(size(A,2)),' columns while second has ', ...
                    num2str(size(B,2)),' columns.'];
                causeException = MException('MATLAB:myCode:dimensions',msg);
                ME = addCause(ME,causeException);
            end
        end
    end
end
end
for it=1:5
    x=cent(:,:,it,1:4);
    [idx,C] = kmeans(x(x~=0),2);
    cc(:,it)=C;
end
cc=sort(cc);
cc

for it=1:4
    x=cent2(:,:,1:5,it);
    [idx,C] = kmeans(x(x~=0),1);
    cc2(:,it)=C;
end
% cc2(1,3)=306;
m1=(cc(1,:) - min(cc(1,:))) / (max(cc(1,:)) - min(cc(1,:)))
m2=(cc(2,:) - min(cc(2,:))) / ( max(cc(2,:)) - min(cc(2,:)))
m3=(cc2(1,:) - min(cc2(1,:))) / (max(cc2(1,:)) - min(cc2(1,:)))
 %m3(2)=0.52
% m3(3)=0.66
f1=fit(m1',[1-[0:0.25:1]]','pchip')
f2=fit(m2',[1-[0:0.25:1]]','pchip')
p3=fit(m3',[1-[0:0.33:1]]','pchip')
save('cc_matP','f1','f2','p3','m1','m2','m3','cc','cc2')
