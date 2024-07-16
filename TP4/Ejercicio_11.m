clear;clc;close all;

frecM = 10000;
t = [0:1/frecM:0.025];

sMuestreada = sin(2*pi*880*t)+sin(2*pi*88*t)+sin(2*pi*88000*t);
subplot(4,1,1);
plot(t,sMuestreada);
title('Senal muestreada');

f=linspace(-frecM/2,frecM/2,length(sMuestreada));
espectro_sMuestreada = fftshift(abs(fft(sMuestreada)));
subplot(4,1,2);
stem(f,espectro_sMuestreada);
title('Espectro senal muestreada');

sFiltrada(1)=0;
sFiltrada(2)=0;
for n=3:1:length(sMuestreada)
    sFiltrada(n) = sMuestreada(n)*200-sMuestreada(n-1)*170+sFiltrada(n-1)*1.68-sFiltrada(n-1)*.97;
end
subplot(4,1,3); 
plot(t,sFiltrada);
title('Senal filtrada')

espectro_filtrada = fftshift(abs(fft(sFiltrada)));
subplot(4,1,4);
stem(f,espectro_filtrada);
title('Espectro senal filtrada')