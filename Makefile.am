###############################################################################
## Makefile for apertium-azz
###############################################################################

LANG1=azz
BASENAME=apertium-$(LANG1)
VAR1=SEP

TARGETS_COMMON =			\
	$(LANG1).automorf.hfst		\
	$(LANG1).automorf.bin		\
	$(LANG1).automorf.att.gz	\
	$(LANG1).autogen.hfst		\
	$(LANG1).autogen.bin		\
	$(LANG1).autogen.att.gz		\
	$(LANG1).autoseg.hfst		\
	$(LANG1).autoseg.bin		\
	$(LANG1).prob		\
	$(LANG1).rlx.bin

#	$(LANG1).autophon.hfst		
#	$(LANG1).autophon_$(VAR1).hfst		
#	$(LANG1)-$(LANG1)_$(VAR1).autoconv.hfst 

TARGETS_INTERMEDIATE = $(LANG1).mor.hfst $(LANG1).seg.hfst $(LANG1).gen.hfst $(LANG1).phon.hfst

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################

# nimahtlapaltzin:<s_sg1>mahtlapal<n><dim>
.deps/azz.mor.hfst: .deps/azz.LR.gen.hfst .deps/azz.mor.twol.hfst
	hfst-compose-intersect -1 .deps/azz.LR.gen.hfst -2 .deps/azz.mor.twol.hfst | hfst-minimise | hfst-invert -o $@

# amatl<n><dim><pl>:ama>tzi>tzin
.deps/azz.gen.hfst: .deps/azz.RL.lexc.hfst .deps/azz.twol.hfst
	hfst-compose-intersect -1 .deps/azz.RL.lexc.hfst -2 .deps/azz.twol.hfst | hfst-minimise  -o $@

.deps/azz.LR.gen.hfst: .deps/azz.lexc.hfst .deps/azz.twol.hfst
	hfst-compose-intersect -1 .deps/azz.lexc.hfst -2 .deps/azz.twol.hfst | hfst-minimise  -o $@

.deps/azz.twol.hfst: apertium-azz.azz.twol
	hfst-twolc $< -o $@

# <px2sg>metztli<n><pl>:m{o}>metz>huan
.deps/azz.lexc.hfst: apertium-azz.azz.lexc .deps/.d
	hfst-lexc -A --Werror $< -o $@

.deps/azz.RL.lexc: apertium-azz.azz.lexc .deps/.d
	cat $< | grep -v "Dir/LR" > $@

.deps/azz.RL.lexc.hfst: .deps/azz.RL.lexc .deps/.d
	hfst-lexc -A --Werror $< -o $@

.deps/azz.mor.twol.hfst: apertium-azz.azz.mor.twol
	hfst-twolc apertium-azz.azz.mor.twol -o .deps/azz.mor.twol.hfst

# notipehuan:no>tipe>huan
.deps/azz.seg.hfst: .deps/azz.mor.hfst .deps/azz.gen.hfst
	hfst-compose -F -1 .deps/azz.mor.hfst -2 .deps/azz.gen.hfst -o .deps/azz.seg.hfst 

.deps/azz.phon.hfst: apertium-azz.azz.phon
	hfst-lexc apertium-azz.azz.phon -o $@

.deps/azz.phon_$(VAR1).hfst: apertium-azz.azz_$(VAR1).phon
	hfst-lexc apertium-azz.azz_$(VAR1).phon -o $@

.deps/azz.spellrelax.hfst: apertium-azz.azz.spellrelax 
	hfst-regexp2fst -S -o $@ < $<

.deps/azz-azz_$(VAR1).phon.hfst: .deps/azz.phon.hfst .deps/azz.phon_$(VAR1).hfst
	hfst-invert .deps/azz.phon_$(VAR1).hfst | hfst-compose -F -1 .deps/azz.phon.hfst -2 - -o $@

$(LANG1)-$(LANG1)_$(VAR1).autoconv.hfst: .deps/azz-azz_$(VAR1).phon.hfst
	hfst-fst2fst -w $< -o $@

$(LANG1).autophon.hfst: .deps/azz.phon.hfst
	hfst-fst2fst -w $< -o $@

$(LANG1).autophon_$(VAR1).hfst: .deps/azz.phon_$(VAR1).hfst
	hfst-fst2fst -w $< -o $@

$(LANG1).automorf.hfst: .deps/azz.mor.hfst .deps/azz.spellrelax.hfst
	hfst-invert $< |  hfst-compose -F -1 - -2 .deps/azz.spellrelax.hfst  | hfst-invert | hfst-fst2fst -w -o $@

$(LANG1).autogen.hfst: .deps/azz.gen.hfst
	hfst-compose-intersect -1 .deps/azz.gen.hfst -2 .deps/azz.mor.twol.hfst | hfst-fst2fst -w -o $@

$(LANG1).autoseg.hfst: .deps/azz.seg.hfst 
	hfst-fst2fst -w $< -o $@

$(LANG1).rlx.bin: apertium-azz.azz.rlx
	cg-comp $< $@

$(LANG1).autogen.att.gz: .deps/$(LANG1).gen.hfst
	hfst-compose-intersect -1 .deps/azz.gen.hfst -2 .deps/azz.mor.twol.hfst | hfst-eliminate-flags  | hfst-fst2txt | gzip -9 -c > $@ 

$(LANG1).automorf.att.gz: .deps/$(LANG1).mor.hfst .deps/azz.spellrelax.hfst
	hfst-invert $< |  hfst-compose -F -1 - -2 .deps/azz.spellrelax.hfst  | hfst-eliminate-flags | hfst-invert | hfst-fst2txt | gzip -9 -c > $@

$(LANG1).autoseg.att.gz: .deps/$(LANG1).seg.hfst
	hfst-fst2txt $< | gzip -9 -c > $@

$(LANG1).autogen.bin: $(LANG1).autogen.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autogen.att
	lt-comp lr .deps/$(LANG1).autogen.att $@

$(LANG1).automorf.bin: $(LANG1).automorf.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).automorf.att
	lt-comp lr .deps/$(LANG1).automorf.att $@

$(LANG1).autoseg.bin: $(LANG1).autoseg.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autoseg.att
	lt-comp lr .deps/$(LANG1).autoseg.att $@

$(LANG1).prob: $(BASENAME).$(LANG1).tagged $(LANG1).rlx.bin
	cat $< | cg-proc $(LANG1).rlx.bin | apertium-tagger -s 0 -u 2 $@ /dev/stdin

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(LANG1).lexc		\
		$(BASENAME).$(LANG1).twol	\
		$(BASENAME).$(LANG1).phon \
		$(BASENAME).$(LANG1).spellrelax \
		$(BASENAME).$(LANG1).rlx	\
		modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_azz_dir: This is where the compiled binaries go
#   apertium_azz_srcdir: This is where the source files go

apertium_azzdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_azz_srcdir=$(prefix)/share/apertium/$(BASENAME)/

EXTRA_TARGETS=

if HAVE_HFSTOSPELL
EXTRA_TARGETS += $(LANG1).zhfst
endif # HAVE_HFSTOSPELL

apertium_azz_DATA=$(TARGETS_COMMON) $(EXTRA_TARGETS) 

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
	$(INSTALL_DATA) $(BASENAME).$(LANG1).lexc $(DESTDIR)$(apertium_azz_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).twol $(DESTDIR)$(apertium_azz_srcdir)
	$(INSTALL_DATA) $(BASENAME).$(LANG1).rlx $(DESTDIR)$(apertium_azz_srcdir)


###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON) $(TARGETS_INTERMEDIATE)
clean-local:
	-rm -rf .deps modes

###############################################################################

test: all
	apertium-regtest test
