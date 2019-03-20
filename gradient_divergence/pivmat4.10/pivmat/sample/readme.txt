 
   Sample Directory - PIVMat Toolbox
   
   F. Moisy
_______________________________________________________________________

The 'sample' directory of the PIVMat toolbox has 4 subdirectories,
'jet', 'surf', 'wake' and 'stereo', each containing some sample vector
fields from DaVis (Lavision) or DynamicStudio (Dantec).

To open these fields, go into one of those subdirectories and type
   v = loadvec('*');

To display them, type
   showf(v);

Type 'help loadvec' or 'help showf' to learn more about these functions.

*** JET ***    (Experiment at Lab FAST, Univ. Paris-Sud, CNRS)
This directory contains 3 velocity fields in the Davis 7 format (*.VC7).
These velocity fields have been obtained from a 12 m/s air jet
with a diameter of 15 cm. The flow is seeded by 11 microns hollow glass
spheres (Sphericel), and lighted by a pulsed 25 mJ Yag laser.
Pictures are taken with a 2048x2048 14 bits camera (ImagerProPlus),
imaging a vertical plane of dimension 23x23 cm, using an interframe
time of 40 microseconds. Velocity fields have been computed using
interrogation windows of size 32x32 pixels, 50% overlap. A triangular
zone on the bottom left has not been computed due to insufficient
lighting.

*** WAKE ***    (Experiment at Ecole Navale, Brest, by P. Bot)
This directory contains a MAT file exported from DynamicStudio (Dantec).

*** SURF ***    (Experiment at Lab FAST, Univ. Paris-Sud, CNRS)
This directory contains a MAT file containing a PIVMat structure array
of 3 displacement fields measured using the SG-BOS method - see for details: 
  www.fast.u-psud.fr/~moisy/sgbos/tutorial.php
These displacement fields are obtained by correlating a reference image and
refracted images as observed by imaging a printed pattern of random dots
through a wavy water surface. Pictures are taken with a 2048x2048 14 bits
camera (ImagerProPlus), imaging an area of dimension 13x13 cm.
The displacement field is proportional to the surface gradient. Use
'surfheight' to reconstruct the surface.

*** STEREO ***    (Experiment at Lab FAST, Univ. Paris-Sud, CNRS)
This directory contains two 3-components velocity fields in the Davis 7
format (*.VC7), obtained from stereoscopic PIV.
These velocity fields have been obtained from a forced rotating turbulence
experiment in the 'Gyroflow' rotating platform (FAST, Univ. Paris-Sud).
Field of view are vertical, containing the rotating axis of the experiment.
As a result, the fields are nearly vertically invariant.
_______________________________________________________________________
