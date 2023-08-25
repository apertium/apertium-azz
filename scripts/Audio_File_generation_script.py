# All the files to be worked with should be in the same directory as the python file
# The below script is for a particular eaf and wav file. The label, dual and file names will change according to the files to be worked with
from pydub import AudioSegment
from bs4 import BeautifulSoup
# The below list label contains all the sentence labels whose audio correspond to a single parse tree 
label = ['a9','a147','a10','a12','a15','a16','a20','a27','a36','a45','a46','a77','a87','a88','a97','a101','a114','a126','a129','a141','a142','a145','a152','a153','a157','a159','a163','a164']
# The below list label as each element as a tuple. The concatination of audio for each label in a tuple corresponds to a single parse tree
dual = [('a18','a19'),('a21','a22'),('a43','a44'),('a47','a48'),('a84','a85','a86'),('a94','a95'),('a118','a119'),('a127','a128'),('a134','a135'),('a150','a151'),('a157','a158')]

st = [] #start time
et = [] #end time


 
 

with open('Tzina_Botan_AND308_waawkilit-Amaranthaceae_2012-07-16-n_ed-2017-10-12_trad-HSO_FORM.eaf', 'r') as f:
    data = f.read()

Bs_data = BeautifulSoup(data, "xml")
 
# Finding all instances of tag
# `unique`

# Below loop fetches start and end time for each tag in the label list
for id_ in label:
    b_name = Bs_data.find('ALIGNABLE_ANNOTATION', {'ANNOTATION_ID':id_})
    val = b_name.get('TIME_SLOT_REF1')
    bt1 = Bs_data.find('TIME_SLOT',{'TIME_SLOT_ID':val})
    val = b_name.get('TIME_SLOT_REF2')
    bt2 = Bs_data.find('TIME_SLOT',{'TIME_SLOT_ID':val})
    st.append(int(bt1.get('TIME_VALUE')))
    et.append(int(bt2.get('TIME_VALUE')))
    

    


song = AudioSegment.from_wav("Tzina_Botan_AND308_waawkilit-Amaranthaceae_2012-07-16-n.wav")

# The below loop creates audio file for each label in the label list.
for i in range(len(label)):
    sub = song[st[i]:et[i]]
    sub.export('Tzina_Botan_AND308_waawkilit-Amaranthaceae_2012-07-16-n_ed-2017-10-12_trad-HSO_FORM/Tzina_Botan_AND308_waawkilit-Amaranthaceae_2012-07-16-n-'+label[i]+'.wav', format="wav")
       
# The below loop creates audio file for each element in the dual list.
for tup in dual:
    b_name = Bs_data.find('ALIGNABLE_ANNOTATION', {'ANNOTATION_ID':tup[0]})
    val = b_name.get('TIME_SLOT_REF1')
    bt1 = Bs_data.find('TIME_SLOT',{'TIME_SLOT_ID':val})
    val = b_name.get('TIME_SLOT_REF2')
    bt2 = Bs_data.find('TIME_SLOT',{'TIME_SLOT_ID':val})
    t1 = bt1.get('TIME_VALUE')
    t2 = bt2.get('TIME_VALUE')
    sub = song[int(t1):int(t2)]
    for i in range(1,len(tup)):
        b_name = Bs_data.find('ALIGNABLE_ANNOTATION', {'ANNOTATION_ID':tup[i]})
        val = b_name.get('TIME_SLOT_REF1')
        bt1 = Bs_data.find('TIME_SLOT',{'TIME_SLOT_ID':val})
        val = b_name.get('TIME_SLOT_REF2')
        bt2 = Bs_data.find('TIME_SLOT',{'TIME_SLOT_ID':val})
        t1 = bt1.get('TIME_VALUE')
        t2 = bt2.get('TIME_VALUE')
        sub = sub +  song[int(t1):int(t2)]
        
    sub.export('Tzina_Botan_AND308_waawkilit-Amaranthaceae_2012-07-16-n_ed-2017-10-12_trad-HSO_FORM/Tzina_Botan_AND308_waawkilit-Amaranthaceae_2012-07-16-n-'+tup[0]+'.wav', format="wav")
        
    
               
               
               
