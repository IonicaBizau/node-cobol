rm -rf $1/bin
mkdir $1/bin
cobc -free -x -o $1/bin/app $1/app.cbl
