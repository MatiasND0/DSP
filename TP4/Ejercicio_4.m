clc;clear;close all;

xn = [0 0 0 1 1 1 1 0];
h1 = [0 0 0 1 1 1 1 0];
h2 = [0 0 0 0 -1 0 0 0];
h3 = [0 1 2 3 2 1 0 0];
t = [-3:1:4];

ha = h1+h2;
hb = h3;

conv1 = conv(xn,ha);
conv2 = conv(conv1,hb);

figure
len = length(conv2)/2;
t = [-len-3:1:len-4];
stem(t,conv2);
grid
