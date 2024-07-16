clear;clc;close all

%Filtro pasa todo (Pasa bajo con fc=fm/2=2.5khz)
M=50;
W=hanning(M);
fm=1000;

fc1=fm/2;
wc1=2*pi*fc1/fm;
wm1=wc1/pi;

hd1=wm1*sinc(wm1*( (-(M-1)/2):(M-1)/2) );
h1=hd1.*W';

freqz(h1,1);

%Filtro pasa altos con fc=25hz
fc2=20;
wc2=2*pi*fc2/fm;
wm2=wc2/pi;

hd2=wm2*sinc(wm2*( (-(M-1)/2):(M-1)/2) );
W=hanning(M);
h2=hd2.*W';

freqz(h1-h2,1);

%Filtro pasa bajos con fc=150hz
fc3=150;
wc3=2*pi*fc3/fm;
wm3=wc3/pi;

hd3=wm3*sinc(wm3*( (-(M-1)/2):(M-1)/2) );
W=hanning(M);
h3=hd3.*W';

h=h2-h3
fvtool(h,1);


%prueba
t=[0:1/fm:63/fm];
s=sin(2*pi*50*t)+sin(2*pi*3*t)+sin(2*pi*275*t);
t = 0:1/1e3:2;
s = chirp(t,0,1,250);

figure
subplot(2,1,1);
plot(s);
xlim([0 length(t)]);
grid;
hold
s2=conv(s,h2-h3);
s2=conv(s,h);
plot(s2);
hold off

subplot(2,1,2);
espectro=fftshift(abs(fft(s)));
frec=linspace(-fm/2,fm/2,length(s));
stem(frec,espectro);
hold on;
espectro=fftshift(abs(fft(s2)));
frec=linspace(-fm/2,fm/2,length(s2));
stem(frec,espectro);