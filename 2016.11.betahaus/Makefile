.venv:
	virtualenv .venv
	.venv/bin/pip install landslide==1.1.3

index.html: .venv index.rst
	.venv/bin/landslide -c config.cfg
