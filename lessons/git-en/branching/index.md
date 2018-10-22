# Větvení v Gitu

Takže, Git už znáš!
Teď to začne být trošičku složitější :)

Programáto{{ gnd('ři', 'rky', both='ři') }} občas potřebují pracovat na dvou
věcech zároveň.
V projektu do práce se objeví se chyba,
která musí být opravená
ještě dnes, tak programátor{{ gnd('', 'ka') }} opustí, co zrovna dělá,
vrátí se k nějaké “stabilní” verzi, opraví chybu
a odešle ji zákazníkům.
A pak se vrátí k tomu, co dělal{{a}} předtím – jen ještě
musí zakomponovat opravu chyby i do verze, na které
pracuje dlouhodobě.

Git na to má takzvané *větve* (angl. *branches*).
Na jedné “větvi” se pracuje, ale je možné se přepnout do
jiné (třeba starší) větve, udělat pár změn
a pak se zase přepnout do nové větve a
pokračovat dál nebo sloučit změny.

Větvení využijeme i při spolupráci více lidí – každý
dělá na vlastní větvi a když přijde čas,
tak se různé změny sloučí dohromady.

Podívej se, jaké máš větve ve svém repozitáři.
K tomu slouží příkaz `git branch`:

```ansi
␛[36m$␛[0m git branch
* ␛[32mmaster␛[m
```

Je tam jenom jedna a jmenuje se `master`
– to je tradičně jméno “hlavní” větve.

K vytvoření nové větve znovu použiješ
`git branch`, jen tomu příkazu dáš navíc
jméno nové větve.
Třeba budeš chtít k básničce doplnit jméno autora,
tak větev pojmenuješ `add-author`.

```ansi
␛[36m$␛[0m git branch add-author
␛[36m$␛[0m git branch
  add-author␛[m
* ␛[32mmaster␛[m
```

Tenhle příkaz sice udělal novou větev,
ale nepřepnul do ní.
Hvězdička ve výstupu z `git branch` ukazuje,
že stále pracuješ v `master`.
Na přepnutí budeš potřebovat další příkaz:

```ansi
␛[36m$␛[0m git checkout add-author
Switched to branch 'add-author'
␛[36m$␛[0m git branch
* ␛[32madd-author␛[m
  master␛[m
```

Tak. Teď jsi “ve” větvi `add-author`.
Doplň nějaké jméno do souboru `poem.txt`,
a pomocí `git add` a `git commit` udělej novou revizi.
Pak koukni na `gitk --all`, jak to vypadá:

{{ figure(
    img=static('branch1.png'),
    alt="Výstup programu `gitk` s větví add-author",
) }}

Aktuální větev – `add-author` – je
zvýrazněná tučně a starší `master` je stále
na původní revizi.

Opusťme teď na chvíli práci na doplňování autora.
Vrať se do větve `master` a vytvoř z ní
větev `add-name`.
Pak se na tuhle novou větev přepni.

```ansi
␛[36m$␛[0m git checkout master
Switched to branch 'master'
␛[36m$␛[0m git branch add-name
␛[36m$␛[0m git checkout add-name
Switched to branch 'add-name'
␛[36m$␛[0m git branch
  add-author␛[m
* ␛[32madd-name␛[m
  master␛[m
```

Doplň do souboru jméno básně a pomocí
`git add`, `git commit` ulož revizi.
Všechno zkontroluj přes `gitk --all`.

{{ figure(
    img=static('branches.png'),
    alt="Výstup programu `gitk` s větvemi add-author a add-name",
) }}


Takhle nějak se dá postupovat v situaci popsané v úvodu:
opuštění rozpracované verze, přechod na “stabilní”
verzi `master` a začátek práce v jiné
části projektu.

Mezi jednotlivými větvemi se dá podle libosti přepínat,
jen je vždycky dobré před přepnutím udělat novou revizi
(`git commit`) a pomocí `git status` zkontrolovat, jestli je všechno
uložené v Gitu.

Na stejném principu funguje i spolupráce několika lidí
na jednom projektu: je nějaký společný základ
(`master`) a každý dělá na vlastní větvi, dokud není se svými změnami spokojený.

A až je některá větev hotová, může se začlenit
zpátky do `master`. Podívejme se jak na to.


## Sloučení

Nedávalo by smysl historii projektu rozdvojovat,
kdyby pak jednotlivé větve nešly zase sloučit dohromady.
Naštěstí je v Gitu slučování poměrně jednoduché.

Přepni se zpátky na `master`
a použij příkaz `git merge`, který
sloučí jinou větev s tou aktuální.
Příkazu musíš dát jméno větve, kterou chceš sloučit.

```ansi
␛[36m$␛[0m git checkout master
Switched to branch 'master'
␛[36m$␛[0m git merge add-name
Updating e929fb0..c982a81
Fast-forward
 poem.txt | 6 ␛[32m+++++␛[m␛[31m-␛[m
 1 file changed, 5 insertions(+), 1 deletion(-)
```

Sloučeno! Ono “`Fast-forward`” znamená, že
vlastně nebylo co slučovat – jen se do větve
`master` přidaly nové změny.
Zkontroluj v `gitk --all`, jak to vypadá.

A pak zkus sloučit i druhou větev: `git merge add-author`.
Tady to bude složitější: Může se stát, že změny nepůjdou
automaticky sloučit a ve výstupu se objeví hláška
`merge conflict` (slučovací konflikt).
V tom případě se na soubor podívej v editoru: objeví
se v něm obsah z obou konfliktních verzí,
společně se značkami, které upozorňují na místo
kde konflikt nastal.
Soubor uprav ho tak, jak by měl vypadat, ulož a zadej
`git commit`.
 
Ať nastal konflikt nebo ne, vytvoří se “slučovací revize”
(angl. *merge commit*), které – jako každé revizi – můžeš dát popisek.

```ansi
␛[36m$␛[0m git merge add-author
Auto-merging poem.txt
Merge made by the 'recursive' strategy.
 poem.txt | 2 ␛[32m++␛[m
 1 file changed, 2 insertions(+)
```

Povedlo se?

{{ figure(
    img=static('merge.png'),
    alt="Výstup programu `gitk` s větvemi add-author a add-name sloučenými do master",
) }}

Pokud ano, můžeš staré větve vymazat – všechny jejich
změny jsou v `master` a nemá na nich cenu
pracovat dál.

```ansi
␛[36m$␛[0m git branch -d add-author
Deleted branch add-author (was 0e213cd).
␛[36m$␛[0m git branch -d add-name
Deleted branch add-name (was c982a81).
␛[36m$␛[0m git branch
* ␛[32mmaster␛[m
```

Gratuluji, už umíš větvení a slučování!
