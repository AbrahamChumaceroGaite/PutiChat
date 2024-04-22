# Usar una imagen base
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Install aria2 (since it's not included in the Python image)
RUN apt-get update && apt-get install -y aria2

# Descargar los archivos del modelo usando aria2c
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/model-00001-of-00002.safetensors -d /models/Llama-2-7b-chat-hf -o model-00001-of-00002.safetensors && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/model-00002-of-00002.safetensors -d /models/Llama-2-7b-chat-hf -o model-00002-of-00002.safetensors && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/model.safetensors.index.json -d /models/Llama-2-7b-chat-hf -o model.safetensors.index.json && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/special_tokens_map.json -d /models/Llama-2-7b-chat-hf -o special_tokens_map.json && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/tokenizer.model -d /models/Llama-2-7b-chat-hf -o tokenizer.model && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/tokenizer_config.json -d /models/Llama-2-7b-chat-hf -o tokenizer_config.json && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/config.json -d /models/Llama-2-7b-chat-hf -o config.json && \
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/generation_config.json -d /models/Llama-2-7b-chat-hf -o generation_config.json

# Crear el archivo de configuración settings.yaml
RUN echo "dark_theme: true" > /settings.yaml && \
    echo "chat_style: wpp" >> /settings.yaml

EXPOSE 80

# Ejecutar el script Python con los parámetros necesarios
CMD ["python", "server.py", "--share", "--settings", "settings.yaml", "--model", "/models/Llama-2-7b-chat-hf"]
