IMAGE_TAG ?= patrickdappollonio/terraform-gendocs
BIN_NAME = terraform-gendocs

default: release

build:
	CGO_ENABLED=0 go build -a -tags netgo -ldflags '-s -w' -o $$(pwd)/$(BIN_NAME)

generate:
	go generate

remove-gen:
	rm -rf $$(pwd)/*_gen.go

clean:
	rm -rf $$(pwd)/$(BIN_NAME)

docker:
	docker build --pull=true --rm=true -t $(IMAGE_TAG) .

release:
	@$(MAKE) clean
	@$(MAKE) generate
	@$(MAKE) build
	@$(MAKE) remove-gen

ci:
	@$(MAKE) generate
	@$(MAKE) build
	@$(MAKE) remove-gen
	@$(MAKE) docker
	@$(MAKE) clean

.NOTPARALLEL:
