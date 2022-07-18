@ECHO ON

cd C:\myFiles\training\TestProjects\standings

call mvn clean
call mvn install

del "C:\Program Files\apache-tomcat-9.0.46\webapps\standings-1.0.war"
rd /s /q "C:\Program Files\apache-tomcat-9.0.46\webapps\standings-1.0"

copy "C:\myFiles\training\TestProjects\standings\target\standings-1.0.war" "C:\Program Files\apache-tomcat-9.0.46\webapps"

