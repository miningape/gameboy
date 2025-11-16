emulator: resources FORCE
	odin build src -out:emulator

resources/opcodes.json:
	curl "https://raw.githubusercontent.com/gbdev/gb-opcodes/refs/heads/master/Opcodes.json" > resources/opcodes.json

resources: resources/opcodes.json

test-all:
	odin test test/ --all-packages 

test-only:
	odin test test/ --all-packages -define:ODIN_TEST_LOG_LEVEL=debug -define:ODIN_TEST_NAMES=$(test)

FORCE:
