*************************************************
  RobotPy: Python for FRC cRIO Robot Controller
*************************************************

:Author: Peter Johnson, FRC Team 294
:Copyright: Copyright © 2010, Peter Johnson, Ross Light

About RobotPy
===============

`RobotPy`_ is a distribution of `Python`_ intended to be used for the `FIRST
Robotics Competition`_.  Teams can use this to write their robot code in
Python, a powerful dynamic programming language.

.. _RobotPy: http://firstforge.wpi.edu/sf/projects/robotpy
.. _Python: http://www.python.org/
.. _FIRST Robotics Competition: http://www.usfirst.org/

Features
==========

*  `Python`_ is simple to learn and easy to maintain.
*  RobotPy lets you reload code without restarting.
*  RobotPy provides access to the WPILib class library.
*  You don't need to use WindRiver (unless you're rebuilding RobotPy itself).

Installation from Source (Advanced Users Only)
==============================================

To build the interpreter and loadable modules, you must perform steps 1-4
at least once after cloning the RobotPy source from git

Step 1: Install Python 

    Python 2.6.6 is known to work. Ensure that you add your python installation
    directory to your PATH variable.
    
    Note: This step is required for SIP installation

Step 2: Install SIP v4.x:

    http://www.riverbankcomputing.com/static/Docs/sip4/installation.html

    Note: Installation of SIP requires Visual Studio or MinGW installed,
    see the SIP build instructions for more details.
    
    Tested version of SIP: 4.14.2
    
Step 3: Use SIP to generate the CPP wrappers needed for build
    
    Run Packages\sip_all.bat to generate the wrappers
    
    Note: These scripts assume that SIP is in your %PATH% variable. SIP
    is installed by default into your python directory, so you should
    check your system and set the PATH appropriately. For example:
    
        set PATH=c:\Python27;%PATH
        cd Packages
        sip_all.bat
    
Step 4: Generate RobotPy build files

    We do not include the Makefiles generated by Wind River in the git 
    source directories, so you must generate those on your own. Open Wind
    River and do the following:
    
    1. Click File->Import
    2. Select General, Existing Projects into Workspace. Click Next
    3. Set the root directory to be your_path_to_robotpy_source\RobotPy 
    4. Ensure that 'RobotPy' shows up under 'Projects', click Finish
    5. Click Project->Build Project
    
    Note that even though this step builds RobotPy, it does not build any
    of its associated modules. So go to Step 5... 
    
Step 5: Build RobotPy

    Run Start|Programs|Wind River|
    VxWorks 6.3 and General Purpose Technologies|VxWorks Development Shell.
    CD to the directory where you cloned the git repository.  Run the
    following:
    
        make all
        make dist
    
Step 6: Robot Installation
    
    Connect to your robot's IP with an FTP client (e.g. ``ftp://10.XX.YY.2/``,
    where XXYY is your team number).  Copy the ``dist\RobotPy-Core\robot`` and
    ``dist\RobotPy-WPILib\robot`` directory trees to the root (top level)
    directory on the robot.  Alternatively, install.py can be run in each of
    these directories to do this for you.

Technical Overview
====================

RobotPy is a packaging of a patched `Python`_ 3.1.2 interpreter (found in the
``RobotPy/Python`` subdirectory of the source code).  All access to the WPILib
is generated by a `SIP`_ interface, which is found in ``Packages/wpilib/sip/``.
When the robot is started, it initializes the Python interpreter and runs the
file ``py/boot.py``.  From there, all responsibility is given to the
``boot.py`` script, which is referred to as the bootloader.

If ``boot.py`` ever exits (due to an exception, for example), the C++ code
exits.  The default ``boot.py`` simply exits on any user exception.  If this
happens, you can reboot easily via NetConsole by simply typing "reboot"
followed by hitting the enter key.  This is how code reloads are performed.
As boot.py is written in Python, this behavior can be customized as desired.

.. _SIP: http://www.riverbankcomputing.com/software/sip/intro

Major Differences from standard Python
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*  Several Python modules with large and/or incompatible dependencies removed,
   namely: curses, dbm, gdbm, tkinter, nis, ossaudiodev, resource, spwd,
   syslog, termios, audioop, bz2, crypt, grp, ssl, pwd, and mmap.

Licensing
===========

A brief overview of licensing terms:

*  `Python`_: `PSF License`_
*  RobotPy (all other support code): `MIT License`_

.. _PSF License: http://docs.python.org/license.html
.. _MIT License: http://www.opensource.org/licenses/mit-license.php

If you redistribute RobotPy and add other libraries, please include their
licensing information here.

RobotPy
~~~~~~~~~

Copyright © 2010 Peter Johnson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

.. vim: tw=80 et ts=3 sw=3 ft=rst fenc=utf-8
