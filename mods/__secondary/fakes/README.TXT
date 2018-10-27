---------------------------
    Pilcrow's Fakes mod
     (License: WTFPL)
---------------------------

At the moment, this mod requires a pretty hacky fix in order to function as intended.

Basically, this mod needs to wait until every other node is registered before trying to register fake versions of them,
but minetest.register_node() causes the game to freeze on item definitions when wrapped within a minetest.after() function.
The only solution I could find to this problem was to add every other mod you use as optional dependancies, so that their
nodes would be registered first. I've listed the names of all mods that I personally use, but obviously your selection may
differ. You must manually edit this mod's depends.txt if you play with any mods I do not already have in the list. If you
use linux, the following command may help you to create a new depends.txt from scratch if needed, but please bear in mind
that 'default' and 'wool' are not optional, and should be changed accordingly after the list is built. Also, 'fakes'
should manually be taken out of the list, or this mod will fail to load due to the cyclical dependancy on itself...


build a new modlist with the following linux command (from within the mods directory):

for i in $(find ./ -type d); do if [ -f $i/init.lua ]; then echo ${i##*/}?; fi; done | sort > depends.txt
