function drawing_app
figure('WindowButtonDownFcn',@wbdcb)
ah = axes('SortMethod','childorder');
axis ([1 10 1 10])
title('Click and drag')
   function wbdcb(src,callbackdata)
     seltype = src.SelectionType;
     % This code uses dot notation to set properties
     % Dot notation runs in R2014b and later.
     % For R2014a and earlier: seltype = get(src,'SelectionType');
     if strcmp(seltype,'normal')
        src.Pointer = 'circle';
        cp = ah.CurrentPoint;
        % For R2014a and earlier: 
        % set(src,'Pointer','circle');
        % cp = get(ah,'CurrentPoint');
        xinit = cp(1,1);
        yinit = cp(1,2);
        hl = line('XData',xinit,'YData',yinit,...
        'Marker','p','color','b');
        src.WindowButtonMotionFcn = @wbmcb;
        src.WindowButtonUpFcn = @wbucb;
        % For R2014a and earlier: 
        % set(src,'WindowButtonMotionFcn',@wbmcb);
        % set(src,'WindowButtonUpFcn',@wbucb);

     end    
 
        function wbmcb(src,callbackdata)
           cp = ah.CurrentPoint;
           % For R2014a and earlier: 
           % cp = get(ah,'CurrentPoint');
           xdat = [xinit,cp(1,1)];
           ydat = [yinit,cp(1,2)];
           hl.XData = xdat;
           hl.YData = ydat;
           % For R2014a and earlier: 
           % set(hl,'XData',xdat);
           % set(hl,'YData',ydat);
           drawnow
        end
   
        function wbucb(src,callbackdata)
           last_seltype = src.SelectionType;
           % For R2014a and earlier: 
           % last_seltype = get(src,'SelectionType');
           if strcmp(last_seltype,'alt')
              src.Pointer = 'arrow';
              src.WindowButtonMotionFcn = '';
              src.WindowButtonUpFcn = '';
              % For R2014a and earlier:
              % set(src,'Pointer','arrow');
              % set(src,'WindowButtonMotionFcn','');
              % set(src,'WindowButtonUpFcn','');
           else
              return
           end
        end
  end
end