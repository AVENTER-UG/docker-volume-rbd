#Dockerfile vars

#vars
PROJECTNAME=docker-volume-rbd
DESCRIPTION=Docker volume driver for rbd
UNAME_M=`uname -m`
TAG=$(shell git describe)
BRANCH=`git rev-parse --abbrev-ref HEAD`
BUILDDATE=`date -u +%Y-%m-%dT%H:%M:%SZ`
LICENSE=MIT
VERSION_TU=$(subst -, ,$(TAG:v%=%))
BUILD_VERSION=$(word 1,$(VERSION_TU))


FPM_OPTS= -s dir -n $(PROJECTNAME) -v $(BUILD_VERSION) \
	--architecture $(UNAME_M) \
	--url "https://www.aventer.biz" \
	--license $(LICENSE) \
	--description "$(DESCRIPTION)" \
	--maintainer "AVENTER Support <support@aventer.biz>" \
	--vendor "AVENTER UG (haftungsbeschraenkt)"

CONTENTS= usr/bin etc usr/lib

help:
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo "build"
	    @echo "all"
			@echo ${TAG}

.DEFAULT_GOAL := all

build-bin:
	@echo ">>>> Build binary"
	@GOOS=linux go build -tags pacific -o build/$(PROJECTNAME) -a -installsuffix cgo -ldflags "-X main.BuildVersion=${BUILDDATE} -X main.GitVersion=${TAG} " .

deb: build-bin
	@echo ">>>> Build DEB"
	@mkdir -p /tmp/toor/usr/bin
	@mkdir -p /tmp/toor/etc/docker-volume/
	@mkdir -p /tmp/toor/usr/lib/systemd/system
	@cp build/$(PROJECTNAME) /tmp/toor/usr/bin
	@cp build/$(PROJECTNAME).service /tmp/toor/usr/lib/systemd/system
	@cp build/rbd.env /tmp/toor/etc/docker-volume/rbd.env
	@fpm -t deb -C /tmp/toor/ --config-files etc $(FPM_OPTS) $(CONTENTS)

rpm: build-bin
	@echo ">>>> Build RPM"
	@mkdir -p /tmp/toor/usr/bin
	@mkdir -p /tmp/toor/etc/docker-volume/
	@mkdir -p /tmp/toor/usr/lib/systemd/system
	@cp build/$(PROJECTNAME) /tmp/toor/usr/bin
	@cp build/$(PROJECTNAME).service /tmp/toor/usr/lib/systemd/system
	@cp build/rbd.env /tmp/toor/etc/docker-volume/rbd.env
	@fpm -t rpm -C /tmp/toor/ --config-files etc $(FPM_OPTS) $(CONTENTS)

all: build-bin
