install-darwin:
	./bin/install-darwin.bash

update:
	./bin/update.bash

update-system:
	./bin/update-system.bash

update-all: update-system update

format:
	alejandra .

