git add .

git pull

echo 'Introduce el mensaje del Commit:'
read commitMessage

git commit -m "$commitMessage"

git push origin master

read
