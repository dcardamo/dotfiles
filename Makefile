install-darwin:
	./bin/install-darwin.bash

update:
	./bin/update.bash

update-system:
	./bin/update-system.bash

update-all: update-system update

format:
	alejandra .

# Identify dead code in nix files
deadnix:
	nix run github:astro/deadnix
