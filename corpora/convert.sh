#!/bin/bash 
echo -n "" >/tmp/azz.conllu
echo -n "" >/tmp/azz-conv.log
for i in *.dep; do 
	echo "== @@@ $i @@@ ===================================================================="
	python3 ../scripts/conllise.py ../apertium-azz.azz.udx $i $(echo $i | sed 's/dep/seg/g') 2>>/tmp/azz-conv.log >> /tmp/azz.conllu
	tail -1 /tmp/azz-conv.log
done 
d2=$(date +%d-%m-%Y)
targ=$(cat targets.txt | grep "^${d2}")
targn=$(cat targets.txt | grep "^${d2}" | cut -f3)
sents=$(cat /tmp/azz.conllu | grep '# sent_id' | wc -l)
toks=$(cat /tmp/azz.conllu | grep '^[0-9]\+	' | wc -l)
d=$(date)
compl=$(echo "(${toks}/10000)*100" | calc -p)
win=""
res=$(echo "${compl}>${targn}" | bc -l)
if [[ $res -eq 1 ]]; then
	win="✔"
fi
tsegs=$(for i in *.seg; do python3 ../scripts/extract-seg.py < $i; done | grep -v '^#' | grep '\/'  | wc -l)
ssegs=$(for i in *.seg; do python3 ../scripts/extract-seg.py < $i; done | grep '^$'  | wc -l)
echo "================================================================================================="
echo -e "${d}\t${ssegs}\t${tsegs}\t${sents}\t${toks}\t${compl}%\t${targ}\t${win}"
echo "================================================================================================="
udapy -s ud.SetSpaceAfterFromText ud.FixPunct < /tmp/azz.conllu  > /tmp/azz2.conllu
mv /tmp/azz2.conllu azz_itml-ud-test.conllu 
