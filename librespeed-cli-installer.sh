#!/bin/sh

URL="https://github.com/librespeed/speedtest-cli/releases/download/v1.0.11/librespeed-cli_1.0.11_linux_amd64.tar.gz"
TEMP_DIR=$(mktemp -d)
DEST_DIR="/usr/bin"
BIN_NAME="librespeed-cli"

LINKS="librespeed speedtest-cli speedtest"

echo "Скачиваем $URL..."
curl -L "$URL" -o "$TEMP_DIR/$BIN_NAME.tar.gz" || { echo "Ошибка скачивания"; exit 1; }

echo "Распаковываем архив..."
tar -xzf "$TEMP_DIR/$BIN_NAME.tar.gz" -C "$TEMP_DIR" || { echo "Ошибка распаковки"; exit 1; }

if [ ! -f "$TEMP_DIR/$BIN_NAME" ]; then
    echo "Файл $BIN_NAME не найден после распаковки"
    exit 1
fi

echo "Перемещаем $BIN_NAME в $DEST_DIR"
sudo mv "$TEMP_DIR/$BIN_NAME" "$DEST_DIR/$BIN_NAME" || { echo "Ошибка перемещения файла"; exit 1; }

for link in $LINKS; do
    echo "Создаем символическую ссылку $link"
    sudo ln -sf "$DEST_DIR/$BIN_NAME" "$DEST_DIR/$link" || { echo "Ошибка создания символической ссылки $link"; exit 1; }
done

echo "Удаляем временные файлы..."
rm -rf "$TEMP_DIR"

echo "Установка завершена. Доступные команды: $BIN_NAME $LINKS"
