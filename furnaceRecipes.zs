/*
Made by sora_7672 (Discord)

4th script
all about recipes in furnace(vanilla)


*/

#priority 840



//overkill again thats why commented out
//furnace.removeAll();

/*

Furnace recipes are a lil wonkey,
they cant understand different nbt values or other indicators.
They can only use plain the item with meta maximum


The first remove works with the resulting item only to remove it
The second remove works with first result and after the inputs
But, because furnaces are so wonkey, it both does the same, there cant be one input with multiple results 
Also no oredict entries are allowed!
*/

furnace.remove(<minecraft:hardened_clay>);
furnace.remove(<minecraft:brick>, <minecraft:clay_ball>);

/*
You can add smelting recipes with or without xp given out.
The first added recipe returns 2 bricks as output, so you can change how much the output is

the second adds some exp on each crafting process,
note only works if a player takes out the items.

Note:
You can only set fix values as the exp! Dont try to work with variables or randomizing,
that wont work.
*/

furnace.addRecipe(<minecraft:brick>*2, <minecraft:clay_ball>);
furnace.addRecipe(<minecraft:hardened_clay>, <minecraft:clay>, 10.0);



/*
The only advance usage with furnaces is giving a input item
like  MC iron_ore and get the result of a smelting process.
Stuff like autosmelt enchants use this.

*/

var smeltResult = furnace.getSmeltingResult(<minecraft:iron_ore>);

