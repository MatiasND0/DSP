clear;clc;close all;

nums = [200 0];
dens = [1 200 5500^2];

%bode(nums,dens);

numz = [200 -170];
denz = [1 -1.68 .97];

%fvtool(numz,denz);

frecM = 10000;
t = [0:1/frecM:.01];

sMuestreada = sin(2*pi*880*t)+sin(2*pi*2000*t)+sin(2*pi*50*t);
subplot(2,2,1);
plot(t,sMuestreada);

f = linspace(-frecM/2,frecM/2,length(sMuestreada));
espectro_sMuestreada = fftshift(abs(fft(sMuestreada)));
subplot(2,2,3);
stem(f,espectro_sMuestreada);

sFiltrada(1)=0;
sFiltrada(2)=0;

for n=3:1:length(sMuestreada)
        sFiltrada(n) = 200*sMuestreada(n) - 200*sMuestreada(n-1) + 1.68*sFiltrada(n-1) - 0.97*sFiltrada(n-2);
end

subplot(2,2,2);
plot(t,sFiltrada);

subplot(2,2,4);
espectro_sFiltrada = fftshift(abs(fft(sFiltrada)));
stem(f,espectro_sFiltrada);
