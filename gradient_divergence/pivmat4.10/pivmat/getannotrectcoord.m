function coord = getannotrectcoord(h)
%GETANNOTRECTCOORD  gets the coordinates of the annotation rectangle
%   R = GETANNOTRECTCOORD(H) returns the coordinates R = [X0 Y0 X1 Y1] of
%   the annotation rectangle H using the units of the current axis. An
%   annotation rectangle may be created either using the menu Insert >
%   Rectangle, or using Matlab's annotation('rectangle',[  ]) function.
%
%   R = GETANNOTRECTCOORD, without input argument, uses the active
%   annotation rectangle.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.0,  Date: 2017/03/02

if nargin==0
    h = gco;
end

if strfind(get(h,'Type'),'rectangle')
    rr = get(h, 'Position');  % rect coord, in pixels
    ar = get(gca, 'Position');  % axes coord (incl title), in pixels
    xL = get(gca, 'XLim');
    yL = get(gca, 'YLim');

    x0 = xL(1) + (xL(2)-xL(1))*(rr(1)-ar(1))/ar(3);
    x1 = xL(1) + (xL(2)-xL(1))*(rr(1)+rr(3)-ar(1))/ar(3);
    
    switch get(gca,'YDir');
        case 'normal'
        y0 = yL(1) + (yL(2)-yL(1))*(rr(2)-ar(2))/ar(4);
        y1 = yL(1) + (yL(2)-yL(1))*(rr(2)+rr(4)-ar(2))/ar(4);
    case 'reverse'
        y0 = (yL(2)-yL(1))*(ar(2)+ar(4)-rr(2)-rr(4))/ar(4);
        y1 = y0 + (yL(2)-yL(1))*rr(4)/ar(4);
    end
    
    coord = [x0 y0 x1 y1];
else
    error('Select an annotation rectangle (create one using the menu Insert > Rectangle)');
end


