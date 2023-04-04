all:
	cg-comp apertium-azz.azz.rlx azz.rlx.bin
#
	hfst-lexc --Werror apertium-azz.azz.lexc -o azz.lexc.hfst
	hfst-twolc apertium-azz.azz.twol -o azz.twol.hfst
	hfst-twolc apertium-azz.azz.mor.twol -o azz.mor.twol.hfst
	hfst-regexp2fst -S -o azz.spellrelax.hfst < apertium-azz.azz.spellrelax
	hfst-compose-intersect -1 azz.lexc.hfst -2 azz.twol.hfst | hfst-eliminate-flags | hfst-minimise | hfst-realign | hfst-remove-epsilons  -o azz.gen.seg.hfst
#
	hfst-compose-intersect -1 azz.gen.seg.hfst -2 azz.mor.twol.hfst | hfst-compose-intersect -1 - -2 azz.spellrelax.hfst  | hfst-invert | hfst-remove-epsilons -o azz.mor.hfst
	hfst-fst2fst -O azz.mor.hfst -o azz.automorf.hfst
	hfst-fst2txt azz.mor.hfst -o azz.mor.att
	gzip < azz.mor.att > azz.automorf.att.gz
#
	hfst-compose-intersect -1 azz.gen.seg.hfst -2 azz.mor.twol.hfst -o azz.gen.hfst
	hfst-fst2fst -O azz.gen.hfst -o azz.autogen.hfst
#
	hfst-compose -F -1 azz.mor.hfst -2 azz.gen.seg.hfst | hfst-realign | hfst-minimise | hfst-remove-epsilons -o azz.seg.hfst 
	hfst-fst2fst -O azz.seg.hfst -o azz.autoseg.hfst
#
	hfst-fst2txt azz.gen.hfst -o azz.gen.att
	lt-comp lr azz.gen.att azz.autogen.bin
#
	apertium-gen-modes modes.xml
