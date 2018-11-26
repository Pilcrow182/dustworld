# schemsave

This mod lets you mark two positions and save everything inside as a lua schematic file.
Node names and rotation data are included, and air is automatically set to prob = 0, so
that it won't overwrite anything else. The format is reasonably compact:

```
local n1 = { name = "default:sand" }
local n2 = { name = "default:river_water_source" }
local n3 = { name = "default:river_water_flowing", param2 = 7 }
...

local schem = {
	yslice_prob = {

	},
	size = {
		y = 14,
		x = 15,
		z = 11
	}
	,
	data = {
		n1, n1, n1, n1, n1, n1, n2, n2, n2, n2, n2, n2, n2, n2, n2, n3, n3, 
		n4, n4, n4, n4, n4, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, 
		n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, n5, 
		...
	}
}
```

The code is almost entirely lifted from WorldEdit, and marking positions works almost the
same way. Go to a spot and type "//spos1", then another and type "//spos2". Then type in
"//ssave <file>". The schematic will be saved in your world directory, with a ".txt"
suffix. You can then copy it to an appropriate file and add register_decoration code.
