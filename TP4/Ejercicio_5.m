clear;clc;close all;

frecM = 10000;

HS = tf([6283^2],[1 6283 6283^2]);
[numZ,denZ] = tfdata(c2d(HS,1/frecM),'v');

t = [0:1/frecM:0.025];
sMuestreada = sin(2*pi*200*t)+sin(2*pi*3000*t);
subplot(4,1,1);
plot(t,sMuestreada);

f=linspace(-frecM/2,frecM/2,length(sMuestreada));
espectro_sMuestreada = fftshift(abs(fft(sMuestreada)));
subplot(4,1,2);
stem(f,espectro_sMuestreada);

sFiltrada(1)=0;
sFiltrada(2)=0;

for n=3:1:length(sMuestreada)
    sFiltrada(n) = sMuestreada(n)*numZ(1)+sMuestreada(n-1)*numZ(2)+sMuestreada(n-2)*numZ(3)-sFiltrada(n-1)*denZ(2)-sFiltrada(n-2)*denZ(3)
    
    2743.18*sMuestreada(n-1)+sFiltrada(n-1)*1.25-sFiltrada(n-2)*0.533;
end
subplot(4,1,3);
plot(t,sFiltrada);
title('senal filtrada')

espectro_filtrada = fftshift(abs(fft(sFiltrada)));
subplot(4,1,4);
stem(f,espectro_filtrada);