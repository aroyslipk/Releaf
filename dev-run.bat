@echo off
set "JAVA_HOME=C:\Program Files\Java\jdk-21"
set "PATH=%JAVA_HOME%\bin;%PATH%"
echo Starting Spring Boot application with DevTools hot reloading...
echo Using Java 21 from %JAVA_HOME%
echo.
echo Changes to Java files will automatically restart the application
echo Changes to static resources (CSS, JS, JSP) will be reloaded without restart
echo.
echo Press Ctrl+C to stop the server
echo.
gradlew.bat bootRun