function lennaSVD_demo

img = double(rgb2gray(imread('lena_std.tif')));

[U,S,V]=svd(img);

FigH = figure('position',[541 100 700 700]);

axes('XLim', [0 500], 'YLim',[0 500], 'units','pixels', ...
    'position',[100 100 500 500], 'NextPlot', 'add');


ImageH = imagesc(U(:,1)*S(1:1,1:1)*V(:,1)'); colormap('gray');
set(gca,'YDir','reverse')

TextH = uicontrol('style','text',...
    'position',[640 80 40 15]);
SliderH = uicontrol('style','slider','position',[650 100 20 500],...
    'min', 0, 'max', size(S,1),'SliderStep',[1/size(S,1), 0.01]);

addlistener(SliderH, 'Value', 'PostSet', @callbackfn);
movegui(FigH, 'center')

    function callbackfn(source, eventdata)
        num          = get(eventdata.AffectedObject, 'Value');
        num=round(num);
        ImageH.CData  =U(:,1:num)*S(1:num,1:num)*V(:,1:num)';
        TextH.String = num2str(num);
    end

end