.PHONY: test test-init local-init clean

## Run the init.sh test suite
test: test-init

## Run init.sh tests against the local working copy
test-init:
	@sh init/test-init.sh

## Run init.sh against a temp dir in dry-run mode (quick smoke test)
local-init:
	@REPO_RAW="file://$(PWD)" sh init/init.sh --type=simple --dest=/tmp/agent-config-test --dry-run

## Clean up test artifacts
clean:
	@rm -rf /tmp/agent-config-test /tmp/agent-config-test-*
