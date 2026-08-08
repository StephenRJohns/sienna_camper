.PHONY: all assets pdf clean open

all: pdf

assets:
	python src/make_assets.py

pdf:
	python build_guide.py

clean:
	rm -rf output src/assets

open: pdf
	@python -c "import sys,subprocess,os; f='output/Sienna_PowerFold_Mirror_Install_Guide.pdf'; \
subprocess.run(['open',f] if sys.platform=='darwin' else (['start','',f] if os.name=='nt' else ['xdg-open',f]), shell=(os.name=='nt'))"
