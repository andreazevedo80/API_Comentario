#/bin/bash
# Faz uma requisição para obter o conteúdo da URL
RESULT=$(wget -qO- http://192.168.10.5)

# Verifica se a requisição foi bem-sucedida
if [ $? -eq 0 ]; then
    echo 'ok - app no ar!'
else
    echo 'not ok - app não está acessível'
    exit 1
fi

# Verifica se o resultado da requisição contém a palavra "Number"
if [[ $RESULT == *"Number"* ]]; then
    echo 'ok - número de visitantes:'
    echo $RESULT
else
    echo 'not ok - número de visitantes não está presente na resposta'
    exit 1
fi