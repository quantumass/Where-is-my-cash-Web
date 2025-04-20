#!/bin/bash

# Create WebP versions
for img in assets/images/**/*.{jpg,jpeg,png}; do
    cwebp -q 80 "$img" -o "${img%.*}.webp"
    
    # Create responsive sizes
    convert "$img" -resize 300x assets/images/$(basename "${img%.*}")-300.jpg
    convert "$img" -resize 600x assets/images/$(basename "${img%.*}")-600.jpg
    
    cwebp -q 80 assets/images/$(basename "${img%.*}")-300.jpg -o assets/images/$(basename "${img%.*}")-300.webp
    cwebp -q 80 assets/images/$(basename "${img%.*}")-600.jpg -o assets/images/$(basename "${img%.*}")-600.webp
done