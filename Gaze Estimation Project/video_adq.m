clc,close all,clear all,
cam=webcam();

names=strsplit(ls('/Users/pablocaballerogarces/Dropbox/DV-project/video_ads'),'.mp4');
cal=1;
for it=2
    video=strcat('/Users/pablocaballerogarces/Dropbox/DV-project/video_ads/iPhone.mp4');
    videoReader = VideoReader(video);
    fps = get(videoReader, 'FrameRate');
    disp(fps); % the fps is correct: it's the same declared in the video file properties
    PM=get(0,'MonitorPositions');
    hFig = figure('Position',PM(end,:));
    hFig = gcf;
    hAx  = gca;
    currAxes = axes;
    set(hAx,'Unit','normalized','Position',[0 0 1 1]);
    set(hFig,'menubar','none')
    set(hFig,'NumberTitle','off');
    filepath2=strcat('./vid',num2str(cal),'ad_',names{it});
    outputVideo = VideoWriter(filepath2);
    outputVideo.FrameRate=5;
    open(outputVideo)
    ita=1;
    while hasFrame(videoReader)
        %
        vidFrame = readFrame(videoReader);
        image(vidFrame, 'Parent', currAxes);
        %
        I{ita}=snapshot(cam);
        ita=ita+1;
        %%
        currAxes.Visible = 'off';
        hFig = gcf;
        hAx  = gca;
        set(hAx,'Unit','normalized','Position',[0 0 1 1]);
        set(hFig,'menubar','none')
        set(hFig,'NumberTitle','off');
        pause(1e-12);
    end
    close all
    for imm=1:ita-1
        imm
        f=im2frame(I{imm});
        writeVideo(outputVideo,f)
    end
    close(outputVideo)
    clear I
end