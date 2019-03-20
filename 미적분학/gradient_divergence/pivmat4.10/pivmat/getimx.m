function [lhs1,lhs2,lhs3,lhs4,lhs5,lhs6,lhs7]=getimx(A, frame)
% CALL:      [lhs1,lhs2,lhs3,lhs4,lhs5,lhs6,lhs7]=showimx(A, frame);
%
% Note: This command is a clone of LaVision's SHOWIMX command,
% $Version: 1.0$ $Date: 28.01.09 8:50 $ $Revision: 8 $
% The graphics output has been removed, for use with the PIVMat toolbox.
%
% FUNCTION:  Displaying data of LaVision's IMX structure
%            (one vector field, all image frames or only single image frame)
%
% ARGUMENTS: A  = IMX-structure created by READIMX/READIM7 function
%
% RETURN:    in case of images (image type=0):
%               lhs1 = scaled x-coordinates
%               lhs2 = scaled y-coordinates
%               lhs3 = scaled image intensities
%            in case of 2D vector fields (A.IType = 1,2 or 3):
%               lhs1 = scaled x-coordinates
%               lhs2 = scaled y-coordinates
%               lhs3 = scaled vx-components of vectors
%               lhs4 = scaled vy-components of vectors
%               lhs5 = vector choice field
%            in case of 3D vector fields (A.IType = 4 or 5):
%               lhs1 = scaled x-coordinates
%               lhs2 = scaled y-coordinates
%               lhs3 = scaled z-coordinates
%               lhs4 = scaled vx-components of vectors
%               lhs5 = scaled vy-components of vectors
%               lhs6 = scaled vz-components of vectors
%               lhs7 = vector choice field


% History
% 2010/06/11: v1.0, clone from LaVision's showimx version 1 revision 8.
% 2013/04/23: v1.1 Bug fixed for 3-component fields (wrong vy sign),
%                  thanks Maciej Bujalski.


if nargin==0,
    help showimx, return
elseif nargin<2
    frame = -1;
elseif ~isscalar(frame)
    frame = -1;
else
    frame = floor(frame);
end
if ~isfield(A,'DaVis'),
    help showimx, return
end
%Check image type and data format
nx = size(A.Data,1);
nz = A.Nz;
ny = A.Ny;
%set data range
drng_x = 1:nx;
drng_y = 1:ny;
drng_z = 1:nz;
%initialize left handside values
lhs1 = double( (drng_x-0.5)*A.Grid*A.ScaleX(1)+A.ScaleX(2) ); % x-range
lhs2 = double( (drng_y-0.5)*A.Grid*A.ScaleY(1)+A.ScaleY(2) ); % y-range
lhs3 = double(0);
lhs4 = double(0);
lhs5 = double(0);
lhs6 = double(0);
lhs7 = double(0);
if A.IType<=0, % grayvalue image format
    % Calculate frame range
    if frame>0 & frame<A.Nf,
        drng_y = drng_y + frame*ny;
    end
    lhs3 = double(A.Data(:,drng_y)');
    % Display image
    % imagesc(lhs1,lhs2,lhs3);
elseif A.IType==2, % simple 2D vector format: (vx,vy)
    % Calculate vector position and components
    [lhs1,lhs2] = ndgrid(lhs1,lhs2);
    lhs3 = double(A.Data(:,drng_y   ))*A.ScaleI(1)+A.ScaleI(2);
    lhs4 = double(A.Data(:,drng_y+ny))*A.ScaleI(1)+A.ScaleI(2);
    if A.ScaleY(1)<0.0,
        lhs4 = -lhs4;
    end
    % quiver(lhs1,lhs2,lhs3,lhs4);
elseif (A.IType==3 | A.IType==1) , % normal 2D vector format + peak: sel+4*(vx,vy) (+peak)
    % Calculate vector position and components
    [lhs1,lhs2] = ndgrid(lhs1,lhs2);
    lhs3 = lhs1*0;
    lhs4 = lhs2*0;
    % Get choice
    lhs5 = double(A.Data(:,drng_y));
    % Build best vectors from choice field
    for i = 0:5,
        mask=(lhs5==(i+1));
        if (i<4) % get best vectors
            dat = double(A.Data(:,drng_y+(2*i+1)*ny));
            lhs3(mask) = dat(mask);
            dat = double(A.Data(:,drng_y+(2*i+2)*ny));
            lhs4(mask) = dat(mask);
        else    % get interpolated vectors
            dat = double(A.Data(:,drng_y+7*ny));
            lhs3(mask) = dat(mask);
            dat = double(A.Data(:,drng_y+8*ny));
            lhs4(mask) = dat(mask);
        end
    end
    lhs3 = lhs3*A.ScaleI(1)+A.ScaleI(2);
    lhs4 = lhs4*A.ScaleI(1)+A.ScaleI(2);
    %Display vector field
    if A.ScaleY(1)<0.0,
        lhs4 = -lhs4;
    end
    % quiver(lhs1,lhs2,lhs3,lhs4);
elseif A.IType==4,
    % Calculate vector position and components
    lhs3 = double((drng_z-0.5)*A.Grid*A.ScaleY(1)+A.ScaleY(2));
    lhs4 = double(A.Data(:,drng_y     )*A.ScaleI(1)+A.ScaleI(2));
    lhs5 = double(A.Data(:,drng_y+  ny)*A.ScaleI(1)+A.ScaleI(2));
    lhs6 = double(A.Data(:,drng_y+2*ny)*A.ScaleI(1)+A.ScaleI(2));
    [lhs1,lhs2,lhs3] = ndgrid(lhs1,lhs2,lhs3);
    
    % new (F. Moisy, 22 avril 2013)
    if A.ScaleY(1)<0.0,
        lhs5 = -lhs5;
    end
    
    %Display vector field
    % quiver3(lhs1,lhs2,lhs3,lhs4,lhs5,lhs6);
elseif A.IType==5,
    % Calculate vector position and components
    lhs3 = double((drng_z-0.5)*A.Grid*A.ScaleZ(1)+A.ScaleZ(2));
    lhs4 = double(zeros([nx ny nz]));
    lhs5 = lhs4;
    lhs6 = lhs4;
    for iz=1:nz,
        px = double(zeros([nx ny]));
        py = double(zeros([nx ny]));
        pz = double(zeros([nx ny]));
        prange = drng_y + ((iz-1)*14*ny);
        % Build best vectors from best choice field
        lhs7 = double(A.Data(:,prange));
        for i = 0:5,
            if (i<4) % get best vectors
                mask = (lhs7==(i+1));
                dat = double(A.Data(:,prange+(3*i+1)*ny));
                px(mask) = dat(mask);
                dat = double(A.Data(:,prange+(3*i+2)*ny));
                py(mask) = dat(mask);
                dat = double(A.Data(:,prange+(3*i+3)*ny));
                pz(mask)=dat(mask);
            else    % get interpolated vectors
                mask = (lhs7==(i+1));
                dat = double(A.Data(:,prange+10*ny));
                px(mask) = dat(mask);
                dat = double(A.Data(:,prange+11*ny));
                py(mask) = dat(mask);
                dat = double(A.Data(:,prange+12*ny));
                pz(mask) = dat(mask);
            end
        end
        lhs4(:,:,iz)=px;
        lhs5(:,:,iz)=py;
        lhs6(:,:,iz)=pz;
    end
    [lhs1,lhs2,lhs3] = ndgrid(lhs1,lhs2,lhs3);
    lhs4 = lhs4*A.ScaleI(1)+A.ScaleI(2);
    lhs5 = lhs5*A.ScaleI(1)+A.ScaleI(2);
    lhs6 = lhs6*A.ScaleI(1)+A.ScaleI(2);
    
    % new (F. Moisy, 22 avril 2013)
    if A.ScaleY(1)<0.0,
        lhs5 = -lhs5;
    end
    
    %Display vector field
    % quiver3(lhs1,lhs2,lhs3, lhs4,lhs5,lhs6);
end

% last part of "shomimx" removed:
if false
    % Set label, axis and figure properties
    xlabel([A.LabelX ' ' A.UnitX]);
    ylabel([A.LabelY ' ' A.UnitY]);
    title ([A.LabelI ' ' A.UnitI]);
    set(gcf,'Name',A.Source);
    if A.IType>0,
        set(gcf,'color','w');
    end
    set(gca,'color',[.9 .9 .9]);
    if A.ScaleY(1)>=0.0,
        axis ij;
    else
        axis xy;
    end
end
