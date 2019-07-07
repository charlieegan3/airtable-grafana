TAG := $(shell tar -cf - . | md5sum | cut -f 1 -d " ")
PROJECT := charlieegan3/airtable-grafana

build:
	docker build -t $(PROJECT):latest -t $(PROJECT):$(TAG) .

push: build
	docker push $(PROJECT):latest
	docker push $(PROJECT):${TAG}
