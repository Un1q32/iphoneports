# shellcheck shell=sh disable=SC2123
case ":$PATH:" in
    *:/var/usr/share/ccache:*) ;;
    *) PATH="/var/usr/share/ccache${PATH:+:$PATH}" ;;
esac
