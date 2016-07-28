.venv:
	virtualenv .venv
	.venv/bin/pip install landslide==1.1.3

index.html: .venv
	.venv/bin/landslide -c config.cfg