clear;clc;close all

%Filtro pasa todo (Pasa bajo con fc=fm/2=2.5khz)
M=31;
W=hanning(31);
fm=5000;

fc1=fm/2;
wc1=2*pi*fc1/fm;
wm1=wc1/pi;

hd1=wm1*sinc(wm1*( (-(M-1)/2):(M-1)/2) );
h1=hd1.*W';

freqz(h1,1);
pause

%Filtro pasa bajo con fc=1khz
fc2=1000;
wc2=2*pi*fc2/fm;
wm2=wc2/pi;

hd2=wm2*sinc(wm2*( (-(M-1)/2):(M-1)/2)  );
W=hanning(31);
h2=hd2.*W';

freqz(h2,1);
pause

%Resta de ambos filtros
h=h1-h2;
freqz(h,1);

t=[0:1/fm:63/fm];
s1=sin(2*pi*250*t);
s2=sin(2*pi*750*t);
s3=sin(2*pi*1250*t);
s=s1+s2+s3;

figure
subplot(2,1,1)
plot(s)

espectro=fftshift(abs(fft(s)));
frec=linspace(-fm/2,fm/2,length(s));
subplot(2,1,2)
stem(frec,espectro)

s2=conv(s,h);
pause
figure
subplot(2,1,1)
plot(s2)
espectro=fftshift(abs(fft(s2)));
frec=linspace(-fm/2,fm/2,length(s2));
subplot(2,1,2)
stem(frec,espectro)