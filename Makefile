AWS_PROFILE := default
AWS_REGION := ap-northeast-1
AWS_ACCOUNT_ID := $(shell aws --profile $(AWS_PROFILE) sts get-caller-identity --query Account --output text)
PYTHON_VERSION := 3.11
PIP_COMAND := pip$(PYTHON_VERSION)
ARCHITECTURE := arm64
PLATFORM := linux/$(ARCHITECTURE)
LAYER_NAME := psycopg2-binary-$(PYTHON_VERSION)-$(ARCHITECTURE)
CONTAINER_IMAGE := public.ecr.aws/lambda/python:$(PYTHON_VERSION)

.PHONY: push deploy

build:
	docker run --rm \
		--platform=$(PLATFORM) \
		-v $(PWD):/work \
		-w /work \
		--entrypoint $(PIP_COMAND) \
		$(CONTAINER_IMAGE) \
		install -r requirements.txt -t python
	find python/ -name '*.pyc' -delete
	find python/ -name '__pycache__' -type d  -delete
	zip -r layer.zip python/
	unzip -l layer.zip

deploy: build
	aws --profile $(AWS_PROFILE) --region $(AWS_REGION) \
		lambda publish-layer-version --layer-name $(subst .,-,$(LAYER_NAME)) \
		--description "psycopg2-binary $(PYTHON_VERSION) $(ARCHITECTURE)" \
		--zip-file fileb://layer.zip \
		--compatible-runtimes python$(PYTHON_VERSION) \
		--compatible-architectures $(ARCHITECTURE)
	rm -rf python/ layer.zip
