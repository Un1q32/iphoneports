# shellcheck shell=sh disable=SC2123
case ":${PATH:-}:" in
    *:/usr/lib64/ccache:*) ;;
    *) PATH="/usr/lib64/ccache${PATH:+:$PATH}" ;;
esac
