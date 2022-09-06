head=`grep -nH 'LEXICON Root' apertium-azz.azz.lexc  | cut -f2 -d':'`

for tag in `cat apertium-azz.azz.lexc | grep -o '%<[^>]\+%>' | sort -u`;  do
	found=`head -n $head apertium-azz.azz.lexc | grep "$tag" | wc -l`
	if [[ $found -eq 0 ]]; then
		echo "$tag                         !";
	fi
done

for tag in `cat apertium-azz.azz.lexc | grep -o '%{[^}]\+%}' | sort -u`;  do
	found=`head -n $head apertium-azz.azz.lexc | grep "$tag" | wc -l`
	if [[ $found -eq 0 ]]; then
		echo "$tag                         !";
	fi
done
