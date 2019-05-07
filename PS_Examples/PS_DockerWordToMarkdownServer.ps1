# Run the following command first in the console to bypass not digitally signed error
# Ref: http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
# Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


# Ref: https://docs.docker.com/v17.09/docker-for-windows/
docker --version
docker-compose --version
docker-machine --version
docker version
docker info
cd C:\RDAVSTS\word-to-markdown-server
pwd

docker run hello-world

docker build -t w2m .
docker run -p 3000:3000 w2m
open http://localhost:3000
