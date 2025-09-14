@echo off
setlocal
set "LOG=%USERPROFILE%\devtools_probe.log"
echo [%date% %time%] Start > "%LOG%"
echo --- where dart --- >> "%LOG%"
where dart >> "%LOG%" 2>&1
echo. >> "%LOG%"
echo --- dart --version --- >> "%LOG%"
dart --version >> "%LOG%" 2>&1
echo. >> "%LOG%"
echo --- dart pub global list --- >> "%LOG%"
dart pub global list >> "%LOG%" 2>&1
echo. >> "%LOG%"
echo --- dart pub global deactivate devtools --- >> "%LOG%"
dart pub global deactivate devtools >> "%LOG%" 2>&1
echo. >> "%LOG%"
echo --- dart pub global activate devtools --- >> "%LOG%"
dart pub global activate devtools >> "%LOG%" 2>&1
echo. >> "%LOG%"
echo --- dart pub global run devtools --- >> "%LOG%"
dart pub global run devtools --host 127.0.0.1 --port 9130 --machine >> "%LOG%" 2>&1
echo. >> "%LOG%"
echo [%date% %time%] End >> "%LOG%"
endlocal
