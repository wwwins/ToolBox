@ECHO OFF

ECHO SVN Auto Commit...
ECHO.

set SVN_PATH="d:/Data/project/svn/flash/"
svn commit -m "Auto Commit" %SVN_PATH%

ECHO Press any key to continue...
::PAUSE >NUL
EXIT
