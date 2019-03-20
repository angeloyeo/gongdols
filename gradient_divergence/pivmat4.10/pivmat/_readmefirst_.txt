
   PIVMat Toolbox for Matlab

   F. Moisy

   version 4.10, 27 Feb 2017
________________________________________________________________

See:  www.fast.u-psud.fr/pivmat

Bug report:  moisy@fast.u-psud.fr
________________________________________________________________

The PIVMat Toolbox for Matlab contains a set of command-line functions to
import, post-process and analyse 2- and 3-components vector fields from
various file formats, including files from Davis (LaVision) and
DynamicStudio (Dantec).

It enables to handle and perform complex operations over large amount of
vector fields, and to produce high-quality 2D and 3D outputs based on
standard Matlab visualization tools.

The PIVMat Toolbox in itself does not perform any PIV computations.
________________________________________________________________

Compatibility

The PIVMat Toolbox works with MATLAB 8 or higher, on every operating system
(Windows, Unix, Mac).

Files from DaVis 6 and 7 (formats VEC, VC7, IMG, IMX, IM7, SET and EXP),
DynamicStudio (formats MAT, DAT), DPIVSoft (format MAT), MatPIV (format
MAT) and Optical Flow files (formats UW0 and CM0) are supported.

Note that the import of DaVis files requires to install first the READIMX
package provided by LaVision: see the installation procedure below.

Some functions require the Image Processing Toolbox.
________________________________________________________________

Installation procedure

1. Download the PIVMat Toolbox and extract the ZIP file in a folder, for
example /My documents/Matlab/toolbox/pivmat (make sure the subdirectories
html, sample and private are correctly unzipped as well). Do NOT install in
the Matlab application folder (typically /Program Files/Matlab/...). If you
upgrade from an older version, first empty the previous directory.

2. If you wish to import DaVis files, download also the ReadIMX package
from the 'Download' area of the LaVision web site www.lavision.de (menu
Software, submenu DaVis Add-Ons), and extract the ZIP file in another
folder, for example /My documents/Matlab/toolbox/readimx. Note that you
need to sign up first and login to access to the LaVision download area.

3. From the menu 'File > Set Path', click on 'Add Folder' (NOT 'Add with
Subfolders') and select the directories pivmat and readimx. Click on 'Save'
and 'Close'.

4. Restart MATLAB. To get started, type docpivmat.

________________________________________________________________

What's new?

Once installed, have a look to the Release Notes and the Known Bugs sections
in the help browser (type 'docpivmat').
________________________________________________________________

The PIVMat toolbox is covered by the BSD License
Copyright (c) 2016, Frederic Moisy
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are 
met:

    * Redistributions of source code must retain the above copyright 
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in 
      the documentation and/or other materials provided with the distribution
    * Neither the name of the University Paris Sud nor the names 
      of its contributors may be used to endorse or promote products derived 
      from this software without specific prior written permission.
      
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
________________________________________________________________

The End.
