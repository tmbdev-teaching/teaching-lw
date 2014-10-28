NBS := $(wildcard [012]??-*.ipynb)

slides: $(NBS:%.ipynb=%-slides.pdf)

all: $(NBS:%.ipynb=%-slides.pdf) lw.pdf

public: all
	mkindex > index.html
	rsync -v index.html lw.pdf $(NBS) $(NBS:%.ipynb=%-slides.pdf) iupr1.cs.uni-kl.de:public_html/lw/.


%.tex: %.ipynb
	nb2tex -n $^

%-slides.pdf: %.ipynb
	nb2tex -b $^
	pdflatex -file-line-error -interaction=batchmode $(^:%.ipynb=%-slides.tex) || true
	egrep ':[0-9]+:' $(^:%.ipynb=%-slides.log) | uniq

lw.pdf: lw.tex $(NBS:%.ipynb=%.tex)
	pdflatex -file-line-error -interaction=batchmode lw.tex || true
	pdflatex -file-line-error -interaction=batchmode lw.tex || true
	egrep ':[0-9]+:' $(^:%.ipynb=%.log) | uniq

clean:
	rm -f $(NBS:%.ipynb=%.tex)
	rm -f $(NBS:%.ipynb=%-slides.tex)
	rm -f $(NBS:%.ipynb=%-slides.pdf)
	rm -f *.log *.nav *.snm *.toc *.vrb *.aux *.out
	rm -rf _figs
