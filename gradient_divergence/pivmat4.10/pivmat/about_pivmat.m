function about_pivmat(opt)
%ABOUT_PIVMAT  About PIVMat
%    ABOUT_PIVMAT displays the 'about' informations in the command window.
%    ABOUT_PIVMAT('dialog') displays the 'about' info in a dialog box.
%
%   See also CHECKUPDATE_PIVMAT


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.02,  Date: 2006/10/31
%   This function is part of the PIVMat Toolbox

% History:
% 2005/12/16: v1.00, first version.
% 2006/07/23: v1.01, cosmetics
% 2006/10/31: v1.02, modal window

if nargin==0
    opt='command';
end;

v=ver('pivmat');

switch lower(opt),
    case 'command',
        disp('PIVMat');
        disp('A PIV Post-processing and data analysis toolbox for MATLAB');
        disp(['Version ' v.Version ' (' v.Date ')']);
        disp('Frederic Moisy');
    otherwise
        a=imread('about_pivmat.jpg');
        ss=get(0,'ScreenSize');
        figure('Position',[(ss(3)-size(a,2))/2 (ss(4)-size(a,1))/2 size(a,2) size(a,1)]);
        image(a); set(gca,'Position',[0 0 1 1]);
        axis off;
        set(gcf,'Toolbar','none');
        set(gcf,'Menubar','none');
        set(gcf,'Numbertitle','off');
        set(gcf,'Name','About pivmat');
        set(gcf,'Resize','off');
        set(gcf,'WindowStyle','modal');
        delete(findobj(gcf,'Label','Easyfit'));

        annotation('textbox',[.175 .33 .4 .2],'Color',.65*[1 1 1],'LineStyle','none',...
            'FontName','Verdana','FontSize',8,'FontWeight','bold',...
            'String',['Version ' v.Version ' (' v.Date ')']);
end;
