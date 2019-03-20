function gj_2d_ani(before,after,x,xy_ans)

n_steps = 100;

diff = after-before;
% figure;
for i_step = 1:n_steps
    tempA = before+diff/n_steps*i_step;
    
    y1 = (-tempA(1,1)*x+tempA(1,3))/(tempA(1,2)+eps);
    y2 = (-tempA(2,1)*x+tempA(2,3))/(tempA(2,2)+eps);
    
    plot(x,y1);
    hold on;
    plot(x,y2);
    plot(xy_ans(1,1), xy_ans(2,1),'r.','markersize',20)
    grid on;
    hold off;
        xlim([-5 5])
    ylim([-5 5])
    pause(0.01)

end