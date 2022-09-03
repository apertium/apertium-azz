all:
	hfst-lexc --Werror apertium-azz.azz.lexc -o azz.lexc.hfst
	hfst-twolc apertium-azz.azz.twol -o azz.twol.hfst
	hfst-twolc apertium-azz.azz.mor.twol -o azz.mor.twol.hfst
	hfst-regexp2fst -S -o azz.spellrelax.hfst < apertium-azz.azz.spellrelax
	hfst-compose-intersect -1 azz.lexc.hfst -2 azz.twol.hfst | hfst-compose-intersect -1 - -2 azz.mor.twol.hfst | hfst-compose-intersect -1 - -2 azz.spellrelax.hfst  | hfst-invert -o azz.mor.hfst
	hfst-invert azz.mor.hfst -o azz.gen.hfst
	hfst-fst2fst -O azz.mor.hfst -o azz.automorf.hfst
	hfst-fst2fst -O azz.gen.hfst -o azz.autogen.hfst
	cg-comp apertium-azz.azz.rlx azz.rlx.bin
	apertium-gen-modes modes.xml
