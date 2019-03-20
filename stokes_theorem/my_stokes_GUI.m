function my_stokes_GUI(nr,ntheta)
% close all;
% DEFINE function
r = linspace(0,1,100);
theta = linspace(0,2*pi,100);

[R,T]=meshgrid(r,theta);
x = R.*cos(T);
y = R.*sin(T);

% figure;
plot_curls(nr,ntheta,3);
camlight
caxis([-3 3])
zlim([-3 3])
grid on;
hold on;

% slider
set(gcf,'position',[410 150 560 626]);
figsize= get(gcf,'position');
SliderH = uicontrol('style','slider','position',[figsize(3)*0.95, figsize(4)*0.1 20 300],...
    'min', -3, 'max', 3,'SliderStep',[0.001, 0.01],'Value',3);

btn_on = uicontrol('style','pushbutton','String','LIGHT ON',...
    'position',[20 45 70 20],...
    'callback',@light_button_press);

btn_off = uicontrol('style','pushbutton','String','LIGHT OFF',...
    'position',[20 20 70 20],...
    'callback',@light_off_button_press);

addlistener(SliderH, 'Value','PostSet',@callbackfn);


    function callbackfn(source, eventdata)
        [az,el]=view;
        num = get(eventdata.AffectedObject, 'Value');
        cla
        plot_curls(nr,ntheta,num)
        view([az,el]);
        zlim([-3 3])
        
        caxis([-3 3])
        camlight
        grid on;
    end

    function light_off_button_press(source,event)
        delete(findall(gcf,'Type','light'))
        
    end

    function light_button_press(source,event)
        camlight;
    end
end
