function t = getpivtime(f,varargin)
%GETPIVTIME  Get the time from the Attribute string of an image field
%   T = GETPIVTIME(F) returns the time(s), in seconds, of the field(s) F.
%   F may be vector or scalar fields, or filenames of any file format
%   supported by LOADVEC. Wildcards (*) and brackets ([]) may be used (see
%   RDIR for details).
%
%   T = GETPIVTIME(F,'0') does the same, starting at time 0 for the first
%   field.
%
%   Note that, for VC7 vector fields (DaVis 7), GETPIVTIME returns the
%   image acquisition time, as stored in the attribute 'AcqTimeSeries0'.
%   However, for VEC vector fields (DaVis 6), GETPIVTIME returns the PIV
%   computation time, as stored in the attributed 'TIME', which is usually
%   of no use. To get the true image acquisition time instead, use
%   GETPIVTIME with IMX files.
%
%   Examples:
%      t = getpivtime('*.vc7');
%
%      t = getpivtime('B[1:10].vc7','0');
%
%   See also GETFRAMEDT, GETATTRIBUTE.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.13,  Date: 2008/09/10
%   This function is part of the PIVMat Toolbox


% History:
% 2005/02/23: v1.00, first version.
% 2005/09/02: v1.01, help text changed.
% 2006/03/02: v1.10, works now with getattribute
% 2006/03/10: v1.11, use the 'acqtimeseries0' or 'TIME' attributes for
%                    DaVis 6 or 7 files.
% 2006/07/21, v1.12, use varargin
% 2008/09/10, v1.13, help text improved


if (ischar(f) || iscellstr(f) || isnumeric(f)),
    f=loadvec(f);
end

t = zeros(1,length(f));
for i=1:length(f),
    timestr = getattribute(f(i), 'AcqTimeSeries0');
    if ~isempty(timestr)
        t(i) = str2double(strrep(timestr,' µs',''))*1e-6; % convert µs in seconds
    else
        % Acquisition time of IMX files is in the TIME attribute:
        timestr = getattribute(f(i), 'time');
        if isempty(timestr),
            error('Time attribute not found');
        end
        hh = str2double(timestr(1:2));
        mm = str2double(timestr(4:5));
        ss = str2double(timestr(7:8)) + str2double(timestr(10:12))/1000;
        t(i) = hh*3600 + mm*60 + ss;
    end
end

if any(strcmp(varargin,'0'))
    t = t - t(1);
end
