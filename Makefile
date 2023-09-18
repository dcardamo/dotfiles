install:
	./bin/install.bash

update-nix:
	./bin/update.bash

update-mac:
	./bin/update-mac.bash

update: update-nix update-mac

format:
	alejandra .

backup:
	mackup backup

restore:
	mackup restore
