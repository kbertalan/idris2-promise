package=promise.ipkg
idris2=idris2

.PHONY: build clean repl install dev

build:
	bash -c 'time $(idris2) --build $(package)'

clean:
	rm -rf build

repl:
	rlwrap $(idris2) --repl $(package)

install:
	$(idris2) --install $(package)

dev:
	find src/ -name *.idr | entr make build

