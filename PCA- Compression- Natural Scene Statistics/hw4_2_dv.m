clear all
close all
clc

file = fopen('natural-image-patches.dat');
A = fread(file);
images = reshape(A,64,64,10000);

ii=images(:,:,1);
iif=abs(fft2(ii));
w=[];
for u=2:2:10
    for v=2:2:10
        w2=(2*pi*sqrt(u^2+v^2))/64;
        w=[w w2];
    end
end
w3=unique(w);
f=[];
for u=2:2:10
    for v=u:2:10
        if u==v
            f2=iif(u,v);
        else
            f2=0.5*(iif(u,v)+iif(v,u));
        end
        f=[f f2];
    end
end
plot(w3,f,'*')

