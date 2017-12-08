clc,close all,clear all,
cam=webcam();

names=strsplit(ls('/Users/pablocaballerogarces/Dropbox/DV-project/print_ads'),'.jpg\n');
cal=1;
mmm=randperm(44,40);
for it=1:5
    nam=strcat('/Users/pablocaballerogarces/Dropbox/DV-project/print_ads/',names{mmm(it)},'.jpg');
    a=imread(nam);
    PM=get(0,'MonitorPositions');
    hFig = figure('Position',PM(end,:));
    hFig = gcf;
    hAx  = gca;
    set(hAx,'Unit','normalized','Position',[0 0 1 1]);
    set(hFig,'menubar','none')
    set(hFig,'NumberTitle','off');
    image(a)
    filepath2=strcat('./im',num2str(cal),'ad_',names{mmm(it)});
    outputVideo = VideoWriter(filepath2);
    outputVideo.FrameRate=30;
    open(outputVideo)
    for i=1:240
        I=snapshot(cam);
        f=im2frame(I);
        writeVideo(outputVideo,f)
    end
    close(outputVideo)
    close all
end