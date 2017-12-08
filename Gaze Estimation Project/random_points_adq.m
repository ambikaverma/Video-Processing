clear all
close all
clc
cam=webcam();
filepath=strcat('/Users/pablocaballerogarces/Dropbox/DV-project/side_screen_calibration/grid_on_edges_1.png');
a=imread(filepath);
PM=get(0,'MonitorPositions');
hFig = figure('Position',PM(end,:));

hFig = gcf;
hAx  = gca;
set(hAx,'Unit','normalized','Position',[0 0 1 1]);
set(hFig,'menubar','none')
set(hFig,'NumberTitle','off');

for cal=1
    
    q=0;
    for it=[1:20]
        x=round(rand*PM(2,3))%PM(2,4)*rand(1);
        a=zeros(PM(2,4),PM(2,3),3);
        y=round(rand*PM(2,4))%PM(2,4)*rand(1);
        a(y+1:y+21,x+1:x+21,:)=1;
        image(a)
        hFig = gcf;
        hAx  = gca;
        %set(hFig,'units','normalized','outerposition',[0 0 1 1]);
        set(hAx,'Unit','normalized','Position',[0 0 1 1]);
        set(hFig,'menubar','none')
        set(hFig,'NumberTitle','off');
        filepath2=strcat('./rp',num2str(cal),'dvd_x_',num2str(y),'_y_',num2str(x));
        outputVideo = VideoWriter(filepath2);
        outputVideo.FrameRate=30;
        open(outputVideo)
        
        filepath=strcat('/Users/pablocaballerogarces/Dropbox/DV-project/side_screen_calibration/grid_on_edges_',num2str(it),'.png');
        
        %a=imread(filepath);
        %image(a)
        pause(1)
        for i=1:1:20
            I=snapshot(cam);
            f=im2frame(I);
            writeVideo(outputVideo,f)
        end
        close(outputVideo)
        
    end
end

clear('cam');

