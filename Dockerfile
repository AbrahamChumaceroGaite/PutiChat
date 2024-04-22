# Usar una imagen base
FROM ubuntu:latest

# Actualizar el sistema e instalar dependencias
RUN apt-get update && \
    apt-get -y install aria2 python3 python3-pip

# Copiar el archivo requirements.txt
COPY requirements.txt /requirements.txt

# Instalar las dependencias del proyecto
RUN pip install -r /requirements.txt

# Descargar los archivos del modelo usando aria2c
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/model-00001-of-00002.safetensors -d /content/models/Llama-2-7b-chat-hf -o model-00001-of-00002.safetensors && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/model-00002-of-00002.safetensors -d /content/models/Llama-2-7b-chat-hf -o model-00002-of-00002.safetensors && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/model.safetensors.index.json -d /content/models/Llama-2-7b-chat-hf -o model.safetensors.index.json && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/special_tokens_map.json -d /content/models/Llama-2-7b-chat-hf -o special_tokens_map.json && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/tokenizer.model -d /content/models/Llama-2-7b-chat-hf -o tokenizer.model && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/tokenizer_config.json -d /content/models/Llama-2-7b-chat-hf -o tokenizer_config.json && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/config.json -d /content/models/Llama-2-7b-chat-hf -o config.json && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/generation_config.json -d /content/models/Llama-2-7b-chat-hf -o generation_config.json

# Crear el archivo de configuración settings.yaml
RUN echo "dark_theme: true" > /content/settings.yaml && \
    echo "chat_style: wpp" >> /content/settings.yaml

# Cambiar al directorio /content
WORKDIR /content

# Ejecutar el script Python con los parámetros necesarios
CMD ["python", "server.py", "--share", "--settings", "/content/settings.yaml", "--model", "/content/models/Llama-2-7b-chat-hf"]
