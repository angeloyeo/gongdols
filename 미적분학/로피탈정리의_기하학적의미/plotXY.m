function plotXY(x1, x2, y1, y2,h_newfig, fontsize)

% fontsize= 20;
if h_newfig
    figure;
    set(gcf,'position',[500,100,1000,650])
    set(gcf,'color','w');
end

mArrow2(x1,0,x2,0,{'color','k'});
mArrow2(0,y1,0,y2,{'color','k'});
xlim([x1,x2])
ylim([y1,y2])
set(gca,'visible','off');

% (x1+1):10:(x2-1)
for i = unique(round([linspace(x1*0.9, x2*0.9,7),0]))
    line([i i],[-(y2-y1)*0.005 (y2-y1)*0.005],'color','k')
    line([-(x2-x1)*0.005 (x2-x1)*0.005],[i i],'color','k')
    
    % xticks
    if i<=0
        t= text(i-(y2-y1)*0.03, -(x2-x1)*0.025,num2str(round(i)));
    else
        t= text(i-(y2-y1)*0.02, -(x2-x1)*0.025,num2str(round(i)));
    end
    t.FontSize=fontsize;
    
    % yticks
    if i<0
        t = text((y2-y1)*0.01, i, num2str(round(i)));
    elseif i>0
        t = text((y2-y1)*0.01, i, num2str(round(i)));
    end
    t.FontSize = fontsize;
end

t = text(x2*0.97,(y2-y1)*0.03,'$$x$$','Interpreter','latex');
t.FontSize = fontsize;
t = text(-(x2-x1)*0.03,y2*1,'$$y$$','Interpreter','latex');
t.FontSize = fontsize;
axis square

end

function [ h ] = mArrow2(x1,y1,x2,y2,props)

h = annotation('arrow');
set(h,'parent', gca, ...
    'position', [x1,y1,x2-x1,y2-y1], ...
    'HeadLength', 10, 'HeadWidth', 10, 'HeadStyle', 'cback1', ...
    props{:} );
end
