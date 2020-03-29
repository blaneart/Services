minikube delete
minikube start --vm-driver virtualbox \
  --bootstrapper=kubeadm  \
  --kubernetes-version=v1.17.0 \
  --extra-config=kubelet.authentication-token-webhook=true --extra-config=apiserver.service-node-port-range=1-45535

minikube addons enable dashboard
eval $(minikube docker-env)
echo "pasv_address=$(minikube ip)" >> ./srcs/ftp_alpine/vsftpd.conf
MINIKUBE_IP=$(minikube ip)
cp srcs/mysql/wordpress.sql srcs/mysql/wordpress-tmp.sql
sed -i '' "s/http:\/\/192.168.99.133\/wordpress/http:\/\/$MINIKUBE_IP:5050/g" srcs/mysql/wordpress-tmp.sql
minikube addons enable ingress
docker build -t mysql ./srcs/mysql
rm -f ./srcs/mysql/wordpress-tmp.sql
docker build -t wordpress ./srcs/wordpress
docker build -t nginx ./srcs/nginx
docker build -t ftps ./srcs/ftp_alpine
docker build -t grafana ./srcs/grafana
docker build -t phpmyadmin ./srcs/phpmyadmin
kubectl apply -f ./srcs/ingress.yml
kubectl apply -f ./srcs/mysql-pv.yml
kubectl apply -f ./srcs/mysql-pvc.yml
kubectl apply -f ./srcs/mysql.yml
kubectl apply -f ./srcs/nginx.yml
kubectl apply -f ./srcs/wordpress.yml
kubectl apply -f ./srcs/phpmyadmin.yml
kubectl apply -f ./srcs/ftps.yml
kubectl apply -f ./srcs/influxdb/influxdb-config.yaml
kubectl apply -f ./srcs/influxdb/influxdb-data.yaml
kubectl apply -f ./srcs/influxdb/influxdb-secrets.yaml
kubectl apply -f ./srcs/influxdb/influxdb.yml
kubectl describe secret kubernetes-dashboard -n kubernetes-dashboard > ./srcs/test.txt
TOKEN=$(awk '{for (I=1;I<=NF;I++) if ($I == "token:") {print $(I+1)};}' ./srcs/test.txt)
rm -f ./srcs/test.txt
TMP=$(awk '{for (I=1;I<=NF;I++) if ($I == "bearer_token_string") {print $(I+2)};}' ./srcs/telegraf/telegraf-conf.yml | sed -e 's/^"//' -e 's/"$//' )
if [[ ! ($TOKEN == $TMP) ]]
then
	echo  "    [[inputs.kubernetes]]
        ## URL for the kubelet
      url = \"https://$(minikube ip):10250\"

      ## Use bearer token for authorization. ('bearer_token' takes priority)
      ## If both of these are empty, we'll use the default serviceaccount:
          ## at: /run/secrets/kubernetes.io/serviceaccount/token
      # bearer_token = \"/path/to/bearer/token\"
      ## OR
      bearer_token_string = \"$TOKEN\"
      ## Pod labels to be added as tags.  An empty array for both include and
      ## exclude will include all labels.
      # label_include = []
      # label_exclude = [\"*\"]

      ## Set response_timeout (default 5 seconds)
      # response_timeout = \"5s\"

      ## Optional TLS Config
      # tls_ca = /path/to/cafile
      # tls_cert = /path/to/certfile
      # tls_key = /path/to/keyfile
      ## Use TLS but skip chain & host verification
       insecure_skip_verify = true" >> ./srcs/telegraf/telegraf-conf.yml
fi
kubectl apply -f ./srcs/telegraf/telegraf-conf.yml
kubectl apply -f ./srcs/telegraf/telegraf-deployment.yml
kubectl apply -f ./srcs/grafana/grafana-deployment.yaml
kubectl apply -f ./srcs/grafana/grafana-service.yaml
