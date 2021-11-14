#!/bin/bash

if [[ ! -e $1 ]]; then
    echo "Usage: $0 FILE"
    exit 1
fi

binary_size=$(stat -c %s $1)

# Image dimesions: 512 x 512.
bytes_per_image=$((262144))
number_of_images=$((binary_size / bytes_per_image))
remainder=$((binary_size % bytes_per_image))

for (( i = 0; i < $number_of_images; ++i )); do
    dd bs=512 if=$1 skip=$((512 * i)) count=512 | convert -depth 8 -size 512x512 -format GRAY GRAY:- "img_${i}.png"
done

if [[ $remainder > 0 ]]; then
    dd bs=512 if=$1 skip=$((512 * number_of_images)) count=512 if=$1 of=imagify_temp

    # Fill up the rest of the file with null values.
    temp_size=$(stat -c %s imagify_temp)
    dd if=/dev/zero bs=1 count=$((bytes_per_image - temp_size)) >> imagify_temp

    convert -depth 8 -size 512x512 -format GRAY GRAY:imagify_temp "img_${number_of_images}.png"
    rm imagify_temp
fi
