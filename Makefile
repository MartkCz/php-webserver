REPO:=martkcz/php-webserver
VERSION:=1.0.0

all: build release

build:
	docker build -t $(REPO):${VERSION} .

build-force:
	docker build --no-cache -t $(REPO):${VERSION} .

release:
	docker push $(REPO):${VERSION}

test:
	sh tests/run.sh "${REPO}:${VERSION}"

test-server:
	sh tests/webserver.sh "${REPO}:${VERSION}"
