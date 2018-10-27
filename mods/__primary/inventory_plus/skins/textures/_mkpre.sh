#!/bin/bash

_process () {
	rm -rf temp
	mkdir -p temp

	convert $@ -crop 8x8+8+8 +repage -filter point -resize 700% +repage temp/face.png
	convert $@ -crop 8x8+40+8 +repage -filter point -resize 800% +repage -crop 64x64+4+4 +repage temp/over.png
	convert $@ -crop 4x12+4+20 +repage -filter point -resize 700% +repage temp/leg_r.png
	convert $@ -crop 8x12+20+20 +repage -filter point -resize 700% +repage temp/chest.png
	convert $@ -crop 4x12+44+20 +repage -filter point -resize 700% +repage temp/arm_r.png

	convert temp/leg_r.png -flop temp/leg_l.png
	convert temp/arm_r.png -flop temp/arm_l.png

	montage -background transparent -mode concatenate -tile x1 temp/arm_r.png temp/chest.png temp/arm_l.png temp/torso.png
	montage -background transparent -mode concatenate -tile x1 temp/leg_r.png temp/leg_l.png temp/legs.png
	convert temp/face.png temp/over.png -compose over -composite temp/head.png

	convert temp/head.png -background transparent -gravity center -extent 112x +repage temp/head.png
	convert temp/legs.png -background transparent -gravity center -extent 112x +repage temp/legs.png

	montage -background transparent -mode concatenate -tile 1x temp/head.png temp/torso.png temp/legs.png temp/body.png
	convert temp/body.png -background transparent +level 0%,95% temp/body.png -compose copy_opacity -composite temp/body.png
	convert _overlay.png -background transparent temp/body.png -compose overlay -composite temp/preview.png

	convert temp/preview.png -background transparent -filter box -resize 108x241! +repage -gravity center -extent 128x256 +repage $@_preview.png

	rm -rf temp
}

rm -f *preview.png
for FILE in $(ls character_*.png | grep -v preview | sort); do
	echo "Processing $FILE"
	_process $FILE
done
