# Use the official Python image as base
FROM python:3.9

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
COPY /app/content/requirements.txt .
RUN pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Install aria2 (since it's not included in the Python image)
RUN apt-get update && apt-get install -y aria2

# Download the models using aria2
RUN aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/model-00001-of-00002.safetensors -d /app/content/models/Llama-2-7b-chat-hf -o model-00001-of-00002.safetensors \
    && aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/model-00002-of-00002.safetensors -d /app/content/models/Llama-2-7b-chat-hf -o model-00002-of-00002.safetensors \
    && aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/model.safetensors.index.json -d /app/content/models/Llama-2-7b-chat-hf -o model.safetensors.index.json \
    && aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/special_tokens_map.json -d /app/content/models/Llama-2-7b-chat-hf -o special_tokens_map.json \
    && aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/resolve/main/tokenizer.model -d /app/content/models/Llama-2-7b-chat-hf -o tokenizer.model \
    && aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/tokenizer_config.json -d /app/content/models/Llama-2-7b-chat-hf -o tokenizer_config.json \
    && aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/config.json -d /app/content/models/Llama-2-7b-chat-hf -o config.json \
    && aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/Llama-2-7b-chat-hf/raw/main/generation_config.json -d /app/content/models/Llama-2-7b-chat-hf -o generation_config.json

# Create settings.yaml file
RUN echo "dark_theme: true" > /app/settings.yaml \
    && echo "chat_style: wpp" >> /app/settings.yaml

# Expose the necessary port
EXPOSE 80

# Start the server
CMD ["python", "/app/content/server.py", "--share", "--settings", "/app/settings.yaml", "--model", "/app/content/models/Llama-2-7b-chat-hf"]
