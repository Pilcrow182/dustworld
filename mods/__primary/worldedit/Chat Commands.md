Chat Commands
-------------
For more information, see the [README](README.md).

### //reset

Reset the region so that it is empty.

    //reset

### //mark

Show markers at the region positions.

    //mark

### //pos1

Set WorldEdit region position 1 to the player's location.

    //pos1

### //pos2

Set WorldEdit region position 2 to the player's location.

    //pos2

### //p set/set1/set2/get

Set WorldEdit region, WorldEdit position 1, or WorldEdit position 2 by punching nodes, or display the current WorldEdit region.

    //p set
    //p set1
    //p set2
    //p get

### //volume

Display the volume of the current WorldEdit region.

    //volume

### //set <node>

Set the current WorldEdit region to <node>.

    //set dirt
    //set default:glass
    //set mesecons:mesecon

### //replace <search node> <replace node>

Replace all instances of <search node> with <replace node> in the current WorldEdit region.

    //replace cobble stone
    //replace default:steelblock glass
    //replace dirt flowers:flower_waterlily
    //replace flowers:flower_rose flowers:flower_tulip

### //replaceinverse <search node> <replace node>

Replace all nodes other than <search node> with <replace node> in the current WorldEdit region.

    //replaceinverse air stone
    //replaceinverse water_source default:dirt
    //replaceinverse mesecons:mesecon air
    //replaceinverse default:steelblock default:glass

### //hollowsphere <radius> <node>

Add hollow sphere at WorldEdit position 1 with radius <radius>, composed of <node>.

    //hollowsphere 5 dirt
    //hollowsphere 12 default:glass
    //hollowsphere 17 mesecons:mesecon

### //sphere <radius> <node>

Add sphere at WorldEdit position 1 with radius <radius>, composed of <node>.

    //sphere 5 dirt
    //sphere 12 default:glass
    //sphere 17 mesecons:mesecon

### //hollowdome <radius> <node>

Add hollow dome at WorldEdit position 1 with radius <radius>, composed of <node>.

    //hollowdome 5 dirt
    //hollowdome 12 default:glass
    //hollowdome 17 mesecons:mesecon

### //dome <radius> <node>

Add dome at WorldEdit position 1 with radius <radius>, composed of <node>.

    //dome 5 dirt
    //dome 12 default:glass
    //dome 17 mesecons:mesecon

### //hollowcylinder x/y/z/? <length> <radius> <node>

Add hollow cylinder at WorldEdit position 1 along the x/y/z/? axis with length <length> and radius <radius>, composed of <node>.

    //hollowcylinder x +5 8 dirt
    //hollowcylinder y 28 10 default:glass
    //hollowcylinder z -12 3 mesecons:mesecon
    //hollowcylinder ? 2 4 stone

### //cylinder x/y/z/? <length> <radius> <node>

Add cylinder at WorldEdit position 1 along the x/y/z/? axis with length <length> and radius <radius>, composed of <node>.

    //cylinder x +5 8 dirt
    //cylinder y 28 10 default:glass
    //cylinder z -12 3 mesecons:mesecon
    //cylinder ? 2 4 stone
    
### //pyramid <height> <node>

Add pyramid at WorldEdit position 1 with height <height>, composed of <node>.

    //pyramid 8 dirt
    //pyramid 5 default:glass
    //pyramid 2 stone

### //spiral <width> <height> <spacer> <node>

Add spiral at WorldEdit position 1 with width <width>, height <height>, space between walls <spacer>, composed of <node>.

    //spiral 20 5 3 dirt
    //spiral 5 2 1 default:glass
    //spiral 7 1 5 stone

### //copy x/y/z/? <amount>

Copy the current WorldEdit region along the x/y/z/? axis by <amount> nodes.

    //copy x 15
    //copy y -7
    //copy z +4
    //copy ? 8

### //move x/y/z/? <amount>

Move the current WorldEdit positions and region along the x/y/z/? axis by <amount> nodes.

    //move x 15
    //move y -7
    //move z +4
    //move ? -1

### //stack x/y/z/? <count>

Stack the current WorldEdit region along the x/y/z/? axis <count> times.

    //stack x 3
    //stack y -1
    //stack z +5
    //stack ? 12

### //transpose x/y/z/? x/y/z/?

Transpose the current WorldEdit positions and region along the x/y/z/? and x/y/z/? axes.

    //transpose x y
    //transpose x z
    //transpose y z
    //transpose ? y

### //flip x/y/z/?

Flip the current WorldEdit region along the x/y/z/? axis.

    //flip x
    //flip y
    //flip z
    //flip ?

### //rotate x/y/z/? <angle>

Rotate the current WorldEdit positions and region along the x/y/z/? axis by angle <angle> (90 degree increment).

    //rotate x 90
    //rotate y 180
    //rotate z 270
    //rotate ? -90

### //orient <angle>

Rotate oriented nodes in the current WorldEdit region around the Y axis by angle <angle> (90 degree increment)

    //orient 90
    //orient 180
    //orient 270
    //orient -90

### //fixlight

Fixes the lighting in the current WorldEdit region.

    //fixlight

### //hide

Hide all nodes in the current WorldEdit region non-destructively.

    //hide

### //suppress <node>

Suppress all <node> in the current WorldEdit region non-destructively.

    //suppress dirt
    //suppress default:glass
    //suppress mesecons:mesecon

### //highlight <node>

Highlight <node> in the current WorldEdit region by hiding everything else non-destructively.

    //highlight dirt
    //highlight default:glass
    //highlight mesecons:mesecon

### //restore

Restores nodes hidden with WorldEdit in the current WorldEdit region.

    //restore

### //save <file>

Save the current WorldEdit region to "(world folder)/schems/<file>.we".

    //save some random filename
    //save huge_base

### //allocate <file>

Set the region defined by nodes from "(world folder)/schems/<file>.we" as the current WorldEdit region.

    //allocate some random filename
    //allocate huge_base

### //load <file>

Load nodes from "(world folder)/schems/<file>.we" with position 1 of the current WorldEdit region as the origin.

    //load some random filename
    //load huge_base

### //lua <code>

Executes <code> as a Lua chunk in the global namespace.

    //lua worldedit.pos1["singleplayer"] = {x=0, y=0, z=0}
    //lua worldedit.rotate(worldedit.pos1["singleplayer"], worldedit.pos2["singleplayer"], "y", 90)

### //luatransform <code>

Executes <code> as a Lua chunk in the global namespace with the variable pos available, for each node in the current WorldEdit region.

    //luatransform minetest.add_node(pos, {name="default:stone"})
    //luatransform if minetest.get_node(pos).name == "air" then minetest.add_node(pos, {name="default:water_source"})
