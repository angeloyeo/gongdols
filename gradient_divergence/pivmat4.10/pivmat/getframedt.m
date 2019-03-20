function dt=getframedt(filename)
%GETFRAMEDT  Get the time interval between the frames of an IMX/IM7 file
%   DT = GETFRAMEDT(FILENAME) explores the 'AcqTimeSeries' attributes
%   of a DaVis multiframe image matching FILENAME (format IMX or IM7) and
%   computes the time intervals DT between the first frame and the
%   following ones (in ms).
%
%   If the file FILENAME contains N frames, then DT is an array of size N-1
%   (N=2 for classical PIV applications, so DT is a single number).
%   If N=1 (single frame image), then DT is 0.
%
%   Examples:
%      dt = getframedt('B00001.IM7');
%
%   See also GETPIVTIME, GETATTRIBUTE.


%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.02,  Date: 2009/08/26
%   This function is part of the PIVMat Toolbox


% History:
% 2008/07/25: v1.00, first version.
% 2008/09/10: v1.01, help text improved
% 2009/08/26: v1.02, bug fix in help text

im=loadvec(filename);

num=0;
end_of_ats = false;  % true if end of AcqTimeSeries is reached
while ~end_of_ats
    str = getattribute(im, ['AcqTimeSeries' num2str(num)]);
    if ~isempty(str)
        str = str(1:(findstr(str,' ')-1));
        acqtimeseries(num+1)=str2double(str);
        num=num+1;
    else
        end_of_ats = true;
    end
end

dt = round((acqtimeseries - acqtimeseries(1))/1000);
