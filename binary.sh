# minikube, kubernetes
# vagrant
# terraform
if [ ! -e '/usr/local/bin/terraform' ];
then
    wget https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip
    unzip terraform_0.14.3_linux_amd64.zip
    sudo mv terraform /usr/local/bin
fi
# ansible
# serverless

# 바이너리 실행파일 설치 필요할 시 스크립트에 적어서 설치하는 방식으로 해서 설치파일을 컴퓨터가 바껴도 이식이 되도록 하자

# 중복설치를 막도록 파일검사를 하고 설치명령어를 입력

cp workspace/file/config ~/.aws/
cp workspace/file/credentials ~/.aws/

cp workspace/do_backend.hcl ~/workspace/kubernetes-test/do/
cp workspace/do_variables.tf ~/workspace/kubernetes-test/do/
