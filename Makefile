CHART_VERSION := 0.0.1
OS := $(shell uname)
NAME := group-jx-test-charts

delete:
	helm delete --purge $(NAME)
	kubectl delete cm --all

clean:
	rm -rf secrets.yaml.dec%
	
build: clean
	helm repo add chartmuseum $(CHART_REPO)
	helm repo update
	helm secrets dec secrets.yaml

install: clean build
	helm install chartmuseum/${CHART} --name $(NAME) -f ./values.yaml -f ./secrets.yaml.dec --version ${CHART_VERSION}
	watch kubectl get pods

upgrade: clean build
	helm upgrade $(NAME) chartmuseum/${CHART} -f values.yaml -f secrets.yaml.dec --version ${CHART_VERSION}
	watch kubectl get pods%