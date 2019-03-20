% PIVMat Toolbox
% Version 4.10 27-Feb-2017
% F. Moisy
%
% Data import and display
%   loadvec           - Load vector fields, images or movies
%   showf             - Display vector/scalar fields (still images or movies)
%   vec2scal          - Compute scalar fields from vector fields
%   im2pivmat         - Convert an image into a PIVMat structure
%
% Spatial field processing 
%   filterf           - Spatial filter of a field 
%   interpf           - Interpolate missing data
%   bwfilterf         - Spatial Butterworth filter of a field 
%   medianf           - Median filter
%   spaverf           - Spatial average over X and/or Y of a field 
%   azaverf           - Azimuthally average field
%   azprofile         - Azimuthal profile
%   subaverf          - Substract the average of field 
%   remapf            - Remap a field to a new grid
%   truncf            - Truncate a field 
%   extractf          - Extract a rectangle from a field 
%   resizef           - Resize a field
%   maskrectf         - Mask a rectangular area on fields
%   rotatef           - Rotate a field about the center 
%   shiftf            - Shift the axis of a field 
%   setoriginf        - Set the origin (0,0) of a field 
%   flipf             - Flip (mirror) a field
%   operf             - Other operations (sum, multiply, etc)
%   gradientf         - Gradient of a scalar field
%   convert3dto2df    - Convert 3D vector fields to 2D vector fields
%
% Temporal field processing 
%   averf             - Average of a series of fields 
%   subaverf          - Substract the average of fields 
%   phaseaverf        - Phase average of fields
%   tempspecf         - Temporal power spectrum of fields.
%   tempcorrf         - Temporal correlation function of fields
%   tempfilterf       - Temporal filter (e.g., band-pass filter)
%   spatiotempcorrf   - Spatio-temporal correlation function of a scalar field.
%   smoothf           - Temporal smooth of fields 
%   resamplef         - Re-sample time series of fields
%   probef            - Record the time evolution of a probe in a field
%
% Statistics, spectra and histograms
%   statf             - Mean, standard deviation and rms of a field. 
%   histf             - Histogram of a field. 
%   corrf             - Spatial correlation function of a scalar field.
%   histvec_disp      - Display histograms from vector fields. 
%   histscal_disp     - Display histograms from scalar fields. 
%   statvec_disp      - Display statistics from vector fields. 
%   ssf               - Scalar structure functions.
%   vsf               - Vector structure functions.
%   vsf_disp          - Display vector structure functions. 
%   specf             - 1D power spectrum of vector/scalar fields.
%   spec2f            - 2D power spectrum of vector/scalar fields.
%   tempspecf         - Temporal power spectrum of vector/scalar fields.
%   jpdfscal          - Joint probability density function.
%   jpdfscal_disp     - Display joint PDF
%
% Advanced file operations
%   loadpivtxt        - Load a DaVis vector field exported in TXT mode 
%   loadarrayvec      - Load a 2D array of vector fields 
%   changefieldf      - Change the values of variables in a PIVMat structure
%   batchf            - Execute some functions over a series of files 
%   vec2mat           - Convert DaVis files into MAT-Files 
%   imvectomovie      - Create a movie directly from files
%   zerotonanfield    - Convert missing data representation to NaNs
%   nantozerofield    - Convert missing data representation to zeros
%   randvec           - Random vector field. 
%   addnoisef         - Add noise to fields
%   vortex            - Test vector field containing a single vortex. 
%   multivortex       - Test vector fields of randomly distributed Burgers vortices
%   nam               - Normalized Angular Momentum
%   stresstensor      - Reynolds stress tensor
%   matrixcoordf      - Matrix-coordinates (i,j) of a point (x,y) in a field
% 
% VEC/VC7 and SET Attribute handling
%   getattribute      - Get attributes from an IMX or VEC/VC7 file
%   readsetfile       - Read attributes from a .SET or .EXP file
%   getpivtime        - Acquisition time of a IMX/IM7 or VEC/VC7 files
%   getframedt        - Time intervals between the frames of an IMX/IM7 file
%
% Miscellaneous files handling (from Fileseries v1.40)
%   cdw               - Change current working directory with wildcards
%   lsw               - List directory with wildcards
%   rdir              - Recursive list directory.
%   rdelete           - Delete files recursively.
%   rrmdir            - Delete directories recursively.
%   renamefile        - Rename a series of files.
%   renumberfile      - Re-number the indices of a series of files
%   getfilenum        - Get the index of a series of files.
%
% Free-Surface Synthetic Schlieren (FS-SS)
%   makebospattern    - Make a random dot pattern for SS or BOS
%   surfheight        - Surface height reconstruction.
%
% Miscellaneous
%   getsetname        - Get the name of the current set
%   getvar            - Get the value of the parameters in a string 'p1=v1_p2=v2_...'


