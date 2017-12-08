function [fin]=gHeat(a,es)
load('cmap','mycmap')
a=imresize(a,[1024 1280]);
a=padarray(a,[300 300],0,'both');
v = fspecial( 'gaussian', [401 401], 0.08*1000 );
v=v./max(v(:));
est=[es(1)+300 es(2)+300];%[randi([1 1024]),randi([1 1280])];
ker=min(v(:))*ones(1280+600,1024+600);
ker(est(1)-200:est(1)+200,est(2)-200:est(2)+200)=v;
Gray = ker';
RGB1 = cat(3, Gray, Gray, Gray);  % information stored in intensity
RGB2 = Gray;
RGB2(end, end, 3) = 0;  % All information in red channel
GrayIndex = uint8(floor(Gray * 255));
RGB3      = ind2rgb(GrayIndex, mycmap);
C = imfuse(a,RGB3,'blend','Scaling','joint');
fin=imcrop(C,[300 300 1280 1024]);











