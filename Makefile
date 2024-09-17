
RELEASE := minio
HELM_CHART := oci://registry-1.docker.io/bitnamicharts/minio
TIMEOUT := 1200s
NAMESPACE := YOUR_NAMESPACE
CLUSTER := YOUR_CLUSTER_NAME
WEB_URL := YOUR_MINIO_WEB_URL
S3_URL := YOUR_S3_ENDPOINT_URL
ROOT_USER := YOUR_MINIO_ROOT_ACCOUNT_USERNAME
ROOT_PASSWORD := YOUR_MINIO_ROOT_ACCOUNT_PASSWORD
REPLICA_COUNT := 4

install:
	kubectl config use-context $(CLUSTER)
	kubectl config set-context --current --cluster=$(CLUSTER) --namespace=$(NAMESPACE)

	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm upgrade --wait --timeout=$(TIMEOUT) --install \
	--values values.yaml \
	--set auth.rootUser=$(ROOT_USER) \
	--set auth.rootPassword=$(ROOT_PASSWORD) \
	--set service.ingress.hostname=$(WEB_URL) \
	--set service.apiIngress.hostname=$(S3_URL) \
	--set statefulset.replicaCount=$(REPLICA_COUNT) \
	$(RELEASE) $(HELM_CHART)

purge:
	helm del $(RELEASE)
