@echo off
IF "%1"=="" goto man

setx GT "%1"
setx GT_PRODUCT "%1\product"
setx GT_BIN "%1\product\bin"
setx GT_SOURCES "%1\sources"
setx GT_COMMON "%1\sources\common"
setx GT_IMPLEMENT "%1\sources\implement"
setx GT_IMPORTS "%1\imports"

echo Environment variables for Golden Temp installed succesfuly
goto :EOF

:man
echo usage: env ^<path to IVK project directory^>
echo sample: env.bat d:\Projects\GT
goto :EOF