#!/bin/env bash

#rofi_pos

DEPENDENCIES+=(wtype noto-fonts-emoji)

emojiData="${HOME}/.local/share/bin/emoji.db"
#recentData="${HOME}/.local/share/bin/show_emoji.recent"
roFile="${HOME}/.config/rofi/emoji.rasi"

# Loop through all arguments
while (($# > 0)); do
    case $1 in
    --style | -s)
        if (($# > 1)); then
            emoji_style="$2"
            shift # Consume the value argument
        else
            print_prompt +y "[warn] " "--style needs argument"
            emoji_style=1
            shift
        fi
        ;;
    --rasi)
        [[ -z ${2} ]] && print_prompt +r "[error] " +y "--rasi requires a .rasi config file" && exit 1
        useRofile=${2}
        shift
        ;;
    --deps)
        resolve_deps
        exit 0
        ;;
    -*)
        cat <<HELP
Usage: 
--style [1 | 2]     Change Emoji style
                    Add 'emoji_style=[1|2]' variable in ./hyde.conf'
                        1 = list
                        2 = grid
HELP

        exit 0
        ;;
    esac
    shift # Shift off the current option being processed
done

#recent_entries=$(cat "${recentData}")
main_entries=$(<"${emojiData}")

unique_entries=$(echo -e "${main_entries}")

if [[ -n ${useRofile} ]]; then
    dataEmoji=$(echo "$main_entries" | rofi -dmenu -i -config "${useRofile}")
else
    case ${emoji_style} in
    2 | grid)
        dataEmoji=$(echo "$main_entries" | rofi -dmenu -i  -theme-str "listview {columns: 8;}" -theme-str "entry { placeholder: \" 🔎 Emoji\";}" -config "${roFile}")
        ;;
    *)
        dataEmoji=$(echo "$main_entries" | rofi -dmenu -i -theme-str "entry { placeholder: \" 🔎 Emoji\";}"  -config "${roFile}")
        ;;
    esac
fi

# Get the selected emoji and copy it
trap EXIT
selEmoji=$(printf "%s" "${dataEmoji}" | cut -d' ' -f1 | tr -d '\n\r')
[ -z "${selEmoji}" ] && exit 0
wl-copy "${selEmoji}"
