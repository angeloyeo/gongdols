function fun_plotNumberLine(x1,x2,h_newfig)

if h_newfig
    figure;
    set(gcf,'position',[500,100,1000,650])
    set(gcf,'color','w');
end
set(gca,'visible','off')
mArrow2(x1-1,0,x2+1,0,{'color','k'});
xlim([x1-1 x2+1])
ylim([-1 1])

for i = x1:x2
    line([i i],[-0.025 0.025],'color','k')
    t= text(i-0.1, -0.1,num2str(i));
    t.FontSize=15;
end
