clear; close all; clc;

A = [2,1;1,2];

XLIMs = [-5,5];
YLIMs = [-5,5];

vert_u = [XLIMs(1):XLIMs(2); ones(1,diff(XLIMs)+1)*XLIMs(2)];
vert_d = [YLIMs(1):YLIMs(2); ones(1,diff(YLIMs)+1)*YLIMs(1)];

hori_r = [ones(1,diff(YLIMs)+1)*XLIMs(2); YLIMs(1):YLIMs(2)];
hori_l = [ones(1,diff(YLIMs)+1)*XLIMs(1); YLIMs(1):YLIMs(2)];
figure;
for i=1:size(vert_u,2)
    line([vert_u(1,i) vert_d(1,i)],[vert_u(2,i) vert_d(2,i)],'color','k');
    hold on;
    line([hori_l(1,i) hori_r(1,i)],[hori_l(2,i) hori_r(2,i)],'color','k');
end

xlim(XLIMs)
ylim(YLIMs)

figure;
Avert_u = A*vert_u;
Avert_d = A*vert_d;
Ahori_r = A*hori_r;
Ahori_l = A*hori_l;
figure;
for i=1:size(vert_u,2)
    line([Avert_u(1,i) Avert_d(1,i)],[Avert_u(2,i) Avert_d(2,i)],'color','k');
    hold on;
    line([Ahori_l(1,i) Ahori_r(1,i)],[Ahori_l(2,i) Ahori_r(2,i)],'color','k');
end
xlim(XLIMs)
ylim(YLIMs)
