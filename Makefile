all:
	hfst-lexc --Werror apertium-azz.azz.lexc -o azz.lexc.hfst
	hfst-twolc apertium-azz.azz.twol -o azz.twol.hfst
	hfst-twolc apertium-azz.azz.mor.twol -o azz.mor.twol.hfst
	hfst-compose-intersect -1 azz.lexc.hfst -2 azz.twol.hfst | hfst-compose-intersect -1 - -2 azz.mor.twol.hfst | hfst-invert | hfst-fst2fst -O -o azz.automorf.hfst
