#compdef omp

_omp() {
    local i flag
    if [[ "$PREFIX" == -* ]]; then
        _omp_generated "$@"
        return
    fi

    for ((i = 2; i <= $#words; i++)); do
        flag=$words[i-1]
        case $flag in
            --model|--smol|--slow|--plan)
                local -a items
                local line
                for line in "${(@f)$(command omp __complete models -- "$PREFIX" 2>/dev/null)}"; do
                    [[ -z $line ]] && continue
                    items+=( "${line//$'\t'/:}" )
                done
                _describe -t models models items
                return
                ;;
            --resume)
                local -a items
                local line
                for line in "${(@f)$(command omp __complete sessions -- "$PREFIX" 2>/dev/null)}"; do
                    [[ -z $line ]] && continue
                    items+=( "${line%%$'\t'*}" )
                done
                _describe -t sessions sessions items
                return
                ;;
        esac
    done
    _omp_generated "$@"
}

source "${CARAPACE_BRIDGE_CONFIG_HOME:-$HOME/.config}/carapace/bridge/zsh/_omp.generated"
compdef _omp omp

if [ "$funcstack[1]" = "_omp" ]; then
    _omp "$@"
else
    compdef _omp omp
fi
