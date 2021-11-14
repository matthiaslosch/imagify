#!/bin/bash

positional=()
output=""
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -o|--output)
            output="$2"
            shift # past argument.
            shift # past value.
            ;;
        *) # unknown option
            positional+=("$1")
            shift # past argument
            ;;
    esac
done

if [ -z "$output" ]; then
    echo "Usage: $0 <--output OUTPUT> IMAGES..."
    exit 1
fi

for image in "${positional[@]}"; do
    echo "$arg"
    convert -depth 8 $image GRAY:- >> "$output"
done
