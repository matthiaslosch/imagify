#!/bin/bash

positional=()
image_name_prefix="img_"
format="png"
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -n|--name)
            image_name_prefix="$2"
            shift # past argument.
            shift # past value.
            ;;
        -f|--format)
            format="$2"
            shift # past argument.
            shift # past value.
            ;;
        *) # unknown option
            positional+=("$1")
            shift # past argument
            ;;
    esac
done

if [ -z "$positional" ]; then
    echo "Usage: $0 <--name NAME> <--format FORMAT> FILE"
    exit 1
fi

binary_size=$(stat -c %s ${positional[0]})

# Image dimesions: 512 x 512.
bytes_per_image=$((262144))
number_of_images=$((binary_size / bytes_per_image))
remainder=$((binary_size % bytes_per_image))

for (( i = 0; i < $number_of_images; ++i )); do
    dd bs=512 if=${positional[0]} skip=$((512 * i)) count=512 | convert -depth 8 -size 512x512 -format GRAY GRAY:- "${image_name_prefix}${i}.${format}"
done

if [[ $remainder > 0 ]]; then
    dd bs=512 if=${positional[0]} skip=$((512 * number_of_images)) count=512 if=${positional[0]} of=imagify_temp

    # Fill up the rest of the file with null values.
    temp_size=$(stat -c %s imagify_temp)
    dd if=/dev/zero bs=1 count=$((bytes_per_image - temp_size)) >> imagify_temp

    convert -depth 8 -size 512x512 -format GRAY GRAY:imagify_temp "${image_name_prefix}${number_of_images}.${format}"
    rm imagify_temp
fi
