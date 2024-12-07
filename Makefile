install-darwin:
	./bin/install-darwin.bash

sudo:
	sudo echo "authenticated"

backup:
	./bin/backup-dotfiles.sh

update:
	./bin/update.sh

update-system:
	./bin/update-system.sh

update-docker-services:
	./bin/update-docker-services.sh

update-all: sudo backup update-system update update-docker-services

format:
	alejandra .

# Identify dead code in nix files
deadnix:
	nix run github:astro/deadnix
