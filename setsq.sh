#!/bin/bash
/bin/su -s /bin/bash -c 'bin/sonar.sh &' sonarqube
sleep 10;

apk add curl
until [[ $(curl -s GET -u admin:admin "http://localhost:9000/api/system/health") =~ "GREEN" ]]; do
  echo .
  sleep 3;
done

curl "http://admin:admin@localhost:9000/api/webhooks/create" -X POST -d  "name=jenkins&url=http://jenkins:8080/sonarqube-webhook/"
#curl "http://admin:admin@localhost:9000/api/webhooks/create" -X POST -d  "name=jenkins&url=http://cloudlab18jenkinsservice.default.svc.cluster.local:8081/sonarqube-webhook/"

curl -X POST -u admin:admin "http://localhost:9000/api/settings/set?key=sonar.forceAuthentication&value=false"
curl "http://admin:admin@localhost:9000/api/qualitygates/create" -X POST -d  "name=myqualitygate"
curl "http://admin:admin@localhost:9000/api/qualitygates/create_condition" -X POST -d  "gateName=myqualitygate&error=1&metric=sqale_rating&op=GT"
curl "http://admin:admin@localhost:9000/api/qualitygates/set_as_default" -X POST -d  "name=myqualitygate"

echo "SonarQube setup with curl"

sleep infinity
