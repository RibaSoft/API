cd /d/Documents/GitHubPublico/API
rm -r bkp
rm *.lps
rm *.res
rm *.exe
clear
git status
read -p "Precione enter para mandar para o GitHub"
data_hora=$(date +"%Y%m%d_%H%M")
git add .
git commit -m "$data_hora"
git push -u origin main 
read -p "Comandos executados com sucesso!!!"