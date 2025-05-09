# Usa uma imagem base mínima compatível com o Raspberry Pi OS
FROM debian:bookworm

# Define variáveis do ambiente para evitar prompts durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza pacotes e instala dependências essenciais
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    unzip \
    pkg-config \
    libopencv-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libcurl4-openssl-dev \
    libjsoncpp-dev \
    uuid-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Instala Drogon manualmente
RUN git clone --branch v1.8.3 https://github.com/drogonframework/drogon.git && \
    cd drogon && mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr && \
    make -j$(nproc) && make install && \
    cd ../.. && rm -rf drogon

# Copia o código-fonte para o contêiner
COPY . .

# Compila o código
RUN g++ -std=c++17 -o video_stream video_stream_rpi.cpp \
    -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_videoio -lopencv_imgcodecs -ldrogon -lpthread

# Expõe a porta do servidor
EXPOSE 5000

# Comando de execução
CMD ["./video_stream"]
