# Jlesage'in hazır GUI altyapısını kullanıyoruz (Ubuntu tabanlı)
FROM jlesage/baseimage-gui:ubuntu-24.04-v4

ENV APP_NAME="MEGAync"

# 1. Temel araçları ve varlığı kesin olan kütüphaneleri yükle
RUN apt-get update && apt-get install -y \
    wget \
    libnss3 \
    # t64 ekini alanlar (libc6 ve temel Qt çekirdeği)
    libqt5core5t64 \
    libqt5dbus5t64 \
    libqt5network5t64 \
    libqt5widgets5t64 \
    libqt5gui5t64 \
    # t64 eki ALMAYANLAR (hata veren paketler)
    libqt5svg5 \
    libqt5x11extras5 \
    && rm -rf /var/lib/apt/lists/*

# 2. MEGA paketini kopyala
COPY mega.deb /tmp/mega.deb

# 3. Direkt apt üzerinden kur (apt, bağımlılıkları gdebi'den bazen daha iyi çözer)
RUN apt-get update && \
    apt-get install -y /tmp/mega.deb || apt-get install -f -y && \
    rm -rf /var/lib/apt/lists/*

# 4. Başlatma komutu
RUN echo "#!/bin/sh" > /startapp.sh && \
    echo "exec /usr/bin/megasync" >> /startapp.sh && \
    chmod +x /startapp.sh