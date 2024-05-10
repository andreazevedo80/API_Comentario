# imagem base leve do Python
FROM python:3.7-slim

# diretório de trabalho na imagem
WORKDIR /app

# Copia os arquivos necessários para o diretório de trabalho na imagem
COPY . .

# Instala as dependências da aplicação
RUN pip install --no-cache-dir -r requirements.txt

# Expõe a porta em que a aplicação estará escutando
EXPOSE 80

# Comando para executar a aplicação quando o contêiner for iniciado
CMD ["gunicorn", "--log-level", "debug", "api:app"]
