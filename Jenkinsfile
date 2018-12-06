node {
    stage ('SCM checkout') {
        git 'https://github.com/urasai212/jenkins-nodejs.git'
    }
    stage ('npm Install and Bundle') {
        sh '''
        npm install
        npm build
        sudo chmod 777 /usr/lib/node_modules
        sudo mkdir -p $BUILD_DIR/bundle/
        sudo cp Dockerfile $BUILD_DIR/bundle/
        sudo cp package*.json $BUILD_DIR/bundle/
        sudo cp -r  node_modules $BUILD_DIR/bundle/
        cd $BUILD_DIR/bundle/
        '''
    }
    stage ('Build Docker Image') {
        //Using docker plugin
        docker.build("cloudseals/node-app:latest")
    }
    stage ('Remove Existing Running Container')
    {
        sh '''
        containerid=`docker ps -a -q --filter name="cloudseals-node-app"`
	    if [[ ! -z "$containerid" ]]
	    then
		    docker rm -f $containerid
	    fi
	   '''
    }
    stage ('Docker container') {
       //Using docker plugin
	   docker.image('cloudseals/node-app:latest').run('--name "cloudseals-node-app" -e "DBConnectionString=db.cloudseals.com" -p 5555:7777')
	   
    }
     stage ('Docker Smoke Test') {
        sh '''
        res=$(curl -Is "http://localhost:8080/" | head -1)
        if [[ "$res" == "HTTP/1.1 200 OK" ]]
        then
            echo "Pushing docker image to ECR...!"
        else
            echo "Smoke test failed, please verify your docker file and the application code!"
        fi
        '''
     }
     stage ('Push Docker Image to ECR') {
        //cleanup current user docker credentials
        sh 'rm  ~/.dockercfg || true'
        sh 'rm ~/.docker/config.json || true'
        //Using docker plugin to push to AWS ECR
        docker.withRegistry("https://453093980721.dkr.ecr.us-east-2.amazonaws.com", "ecr:us-east-2:3d026207-85a4-45bc-abd4-501c2fd07fa0") {
        docker.image("cloudseals/node-app:latest").push()
        }
     }
     stage ('terraform apply') {
        sh '''
            echo "$PATH"
            cd /opt/terraform
            pwd
            terraform init
            terraform plan
            terraform apply --auto-approve
        '''
     }
     stage ('CleanUP')
     {
         cleanWs()
     }
}
