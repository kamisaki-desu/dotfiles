#!/usr/bin/env sh

#! under development

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
TgtScr="$scrDir/globalcontrol.sh"
rofiConf="${confDir}/rofi/anim.rasi"
HyprConfig="$HOME/.config/hypr"
AnimationConfigs="$HyprConfig/animations"

wallbashModes=($(find "$AnimationConfigs" -type f -name "*.conf" -exec basename {} .conf \;) "Disable Animations")

select_wallbash_mode() {
    [[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
    r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
    elem_border=$(( hypr_border * 4 ))
    r_override="window{border-radius:${elem_border}px;} element{border-radius:${elem_border}px;}"
    
    rofiSel=$(parallel echo {} ::: "${wallbashModes[@]}" | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${wallbashModes[${enableWallDcol}]}")
    
    if [ ! -z "${rofiSel}" ] ; then
        # Seçilen metni alıp, ".conf" ekleyerek animasyon dosyasını buluyoruz
        selected_name="${rofiSel}"
        selected_animation="$AnimationConfigs/${selected_name}.conf"
        apply_animation "$selected_animation"
    else
        exit 0
    fi
}

apply_animation() {
    animationconf="$HyprConfig/animations.conf"

    if [ "${selected_name}" == "Disable Animations" ] ; then
		echo "animation = global, 0" > "$animationconf"
		notify-send "Animations Disabled"
		exit 0
    fi
    cat "$1" > "$animationconf"  # Animasyon dosyasını aktarıyor
    [ "$1" ] && notify-send "Selected $selected_name Animation Style"  # Seçilen animasyon için bildirim
}

#// apply wallbash mode

case "${1}" in
    m|-m|--menu) select_wallbash_mode ;;   # Menü seçimi yapılırsa
    n|-n|--next) apply_animation "$(find "$AnimationConfigs" -type f -name "*.conf" | head -n 1)" ;;  # Sonraki animasyon
    p|-p|--prev) apply_animation "$(find "$AnimationConfigs" -type f -name "*.conf" | tail -n 1)" ;;   # Önceki animasyon
    *)  select_wallbash_mode ;;  # Varsayılan: Menü
esac
