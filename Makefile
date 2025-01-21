##
# build the deb file and place it in ./debfile
# 

all: build

build:
	rm -f ./debfile/*.deb
	docker compose build --pull multimon
	docker compose run --rm --entrypoint '/bin/bash -c "cp /root/multimon_*.deb /debfile/;chmod 666 /debfile/*.deb"' multimon
	if [ -e ./debfile/multimon_1.0-7.1_amd64.deb ]; then cp ./debfile/multimon_*.deb ./soxtest/; fi
	docker compose build --pull oldsox
	docker compose build --pull soxtest
run:
	docker compose run --rm -i multimon /bin/bash

help: man

man:
	docker compose run --rm -i oldsox man sox
test:
	docker compose run --build --rm -i --user $(shell id -u):$(shell id -g) -v /home/$(shell whoami):/home/$(shell whoami) soxtest

clean:
	docker rmi kd2qar/multimon kd2qar/soxtest kd2qar/oldsox
	rm -rf *.deb

