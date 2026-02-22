.PHONY: bootstrap try try-keep docs test check

bootstrap:
	python3 install.py

try:
	./scripts/try.sh

try-keep:
	./scripts/try.sh --keep

docs:
	$(MAKE) -C docs html

test:
	pytest -q

check:
	nvim --headless -i NONE "+qa"
	./scripts/try.sh --headless "+qa"
