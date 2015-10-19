

adistro\createvm.sh

adistro\run_recipe.sh

echo "Mapped network drives. It will take some time ( 2 minutes )"
@set /p IP_SMB=< adistro/ipsmb.txt
echo %IP_SMB%
@sleep 120 
@net use * /delete /yes 
@net use * \\%IP_SMB%\atg /PERSISTENT:YES /USER:developer developer
@net use * \\%IP_SMB%\jboss /PERSISTENT:YES /USER:developer developer


 
 
 