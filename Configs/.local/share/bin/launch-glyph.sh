#!/bin/env bash

# Eğer rofi açıksa kapat ve scriptten çık
pkill -x rofi && exit

# Gerekli bağımlılıkları tanımla
DEPENDENCIES+=(wtype)
[[ $* == *"--deps"* ]] && resolve_deps && exit 0   

# Glyph verisi dosyasını tanımla
glyphDATA="${HOME}/.local/share/bin/glyph.db"
roFile="${HOME}/.config/rofi/glyph.rasi"

# glyph.db dosyasını oku ve içeriklerini unique hale getir
main_entries=$(cat "${glyphDATA}")
unique_entries=$(echo -e "${main_entries}" | awk '!seen[$0]++')

# rofi menüsünde kullanıcıya unique glyphleri göster ve seçilen glyph'i al
dataGlyph=$(echo "${unique_entries}" | rofi -dmenu -multi-select -i -theme-str "entry { placeholder: \" 🔣 Glyph\";} ${pos} ${r_override}" -theme-str "${fnt_override}" -config "${roFile}")

# Seçilen glyph'i al ve kopyala
selGlyph=$(printf "%s" "${dataGlyph}" | cut -d' ' -f1 | tr -d '\n\r')
wl-copy "${selGlyph}"
