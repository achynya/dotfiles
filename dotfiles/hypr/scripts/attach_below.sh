#!/usr/bin/env bash
# Переместим мышку чуть ниже текущего окна
# Получим текущую позицию курсора
window_info=$(hyprctl activewindow -j)

# Извлекаем нужные координаты
x=$(echo "$window_info" | jq '.at[0]')
y=$(echo "$window_info" | jq '.at[1]')
w=$(echo "$window_info" | jq '.size[0]')
h=$(echo "$window_info" | jq '.size[1]')

# Координаты правого нижнего угла (чуть-чуть внутрь, чтобы не попасть за пределы)
target_x=$((x + w - 10))
target_y=$((y + h - 10))

# Переместим курсор
hyprctl dispatch movecursor "$target_x $target_y"
hyprctl dispatch movecursor "$x $new_y"
sleep 0.05

# Запустим окно
"$@" &
