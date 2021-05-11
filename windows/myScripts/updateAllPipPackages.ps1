# create a requirement file with all installed packages
pip freeze > requirements.txt
# update all packages from requirements file
pip install --upgrade -r requirements.txt
# delete the file
del requirements.txt

# command below can only run in PowerShell
pip install --upgrade ((pip freeze) -replace '==.+','')
