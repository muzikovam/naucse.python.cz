git init

git status

cat > poem.txt << END
Holka modrooká, nesedávej u potoka
Holka modrooká, nesedávej tam

V potoce je hastrmánek
Zatahá tě za copánek
Holka modrooká, nesedávej tam
END

git status
git add poem.txt
git status
GIT_EDITOR='echo "First revision" >' git commit

git status
git show

cat > poem.txt << END
Holka modrooká
Nesedávej u potoka
Holka modrooká
Nesedávej tam

V potoce je hastrmánek
Zatahá tě za copánek
Holka modrooká
Nesedávej tam
END

git status
git diff
git add poem.txt
git status

GIT_EDITOR="echo \"$second_msg\" >" git commit

git show
git log

git config -l

take_screenshot $OUTFILE.gitk.png gitk --all

git add poem.txt
GIT_EDITOR="echo \"$second_msg\" >" git commit

git branch
git branch add-author
git branch
git checkout add-author
git branch

cat > poem.txt << END
Holka modrooká
Nesedávej u potoka
Holka modrooká
Nesedávej tam

V potoce je hastrmánek
Zatahá tě za copánek
Holka modrooká
Nesedávej tam

- Lidová
END

git add poem.txt
GIT_EDITOR='echo "Doplnění autora" >' git commit

take_screenshot $OUTFILE.branch1.png gitk --all

git checkout master
git branch add-name
git checkout add-name
git branch

cat > poem.txt << END
Holka modrooká
=========

Holka modrooká
Nesedávej u potoka
Holka modrooká
Nesedávej tam

V potoce je hastrmánek
Zatahá tě za copánek
Holka modrooká
Nesedávej tam
END

git add poem.txt
GIT_EDITOR='echo "Doplnění jména" >' git commit

take_screenshot $OUTFILE.branches.png gitk --all

git checkout master
git merge add-name
git merge add-author
git branch

take_screenshot $OUTFILE.merge.png gitk --all

git branch -d add-author
git branch -d add-name
git branch
