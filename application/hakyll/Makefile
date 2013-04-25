.PHONY: all rel deploy

all: rel deploy

rel:
	./site build

rebuild:
	./site rebuild

deploy:
	./site deploy

build:
	ghc --make site.hs

prev:
	./site preview
