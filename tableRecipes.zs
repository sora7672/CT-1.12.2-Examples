/*
Made by sora_7672 (Discord)

3rd script
all about recipes (vanilla)

==>Pro tip: Write your scripts in smaller scale,
go/be ingame and use /ct syntax
to check for simple errors, which prevents you from restarting many times!
Shows you simple errors like missing signs or wrong spelled words :D

*/

#priority 850

/*
As in the scripts before, declaring the imports for types you want to use
happens at the top of file.
*/

import crafttweaker.item.IIngredient;
import crafttweaker.item.IItemStack;
import crafttweaker.data.IData;
import crafttweaker.world.IWorld as IW;




/*
Would be an overkill to remove all recipes, thats why just commented out the script as it would be used
*/
//recipes.removeAll();


/*
First we remove some recipes.
Simple by removing recipes that output the "wooden_sword" 

Then we remove the wool crafting out of 4x strings, which is a shaped recipe
If there would be another recipe to craft wool(in crafting table/inventory) it wont be affected!

We can also remove only shapeless recipes, like concrete_powder.
if there would be a shaped recipe for it, it wont be affected. Kind of the opposite of the wool removal.

Lastly we do smth. more complex, we search for a regular expression (like "_hoe" in our example)
where we use wildcard ".*" to say there can stay smth behind/before
and remove all recipes where this items are the result with one function.

*X*X* More detailed wildcard explanation missing *X*X*


As you see, the input on shaped recipes is allways 2 dimensional = a height and a width.
Normal arrays are called like this: array[index]
but here we have: array[indexA][indexB]
IndexA can be seen as height. Lets say we want to get these as result and the grid looks like this:

------
a b c
d e f 
g h i
------
a -> array[0][0]
b -> array[0][1]
c -> array[0][2]
d -> array[1][0]
e -> array[1][1]
f -> array[1][2]
g -> array[2][0]
h -> array[2][1]
i -> array[2][2]

As you remember from before, arrays start allways with index 0, because... reason :D


*/
recipes.remove(<minecraft:wooden_sword>);

recipes.removeShaped(<minecraft:wool>, [
[<minecraft:string>,<minecraft:string>,null],
[<minecraft:string>,<minecraft:string>,null],
[null,null,null]
]);

recipes.removeShapeless(<minecraft:concrete_powder>);

recipes.removeByRegex(".*_hoe.*");


/*
We also want to add some recipes.
We start with a shaped recipe for a wooden_hoe.
(meaning it has to be created in this order and air needs to be air)
To use air you use the null value in 1.12.2
We also dont take a single IIngridient, we use a ore dict called
"plankWood", which uses all things that are added to the ore (here everything with "_planks")


Please try to read the syntaxes from the offical docs paralell, 
so you better understand how to use the docs ;)


Belo we use a shapeless recipe, means it can be in any order
and be crafted in any crafting inventory that has enough slots for it
(up to 4 in playerinventory, 9 in crafting table and advanced ones from mods)
There we use a <liquid:XX>, which has a forge compatibility,
to check on any container that includes that liquid.
It should also be possible to change the ammount used,
but standard ammount is 1000millibuckets (mb) = 1 bucket full.
If you use it with smth. like thermal expansions liquid holders,
it will only substract 1 bucket per craft.

*/


recipes.addShaped("woodhoe2",<minecraft:wooden_hoe>, [
[<ore:plankWood>, <ore:plankWood>, null],
[null, <ore:plankWood>, null],
[null, <ore:plankWood>, null]
]);

recipes.addShapeless("obsiwater",<minecraft:obsidian>, [<liquid:lava>, <liquid:water>]);

/*
Note: We advance into more complex scripting the further you go! 

*X*X* Testing mirrored more *X*X*

Next we use ShapedMirrored recipes.
We create a shape like:
x o o
x o o 
x o o 

And mirrored it will be
o o x
o o x 
o o x 

As you see we dont just use a output, we rather give it some extra nbt data
you set NBT with ".withTag(IData)", if you are used to JSON, IData looks pretty familiar to you.
Basically what you create here is a map which can be buildup like this:
{	"key" : value,
	"key2" : value2,
	"keyMap" : {"key1": value1, "key2": value2}
}
and you can nest it further and further.
But be aware! Some things are saved allready from MC itself, so dont use keys like:
"displayname" or whatever minecraft is allready using. I recommend using a unique
prefix for your keys. Like
"prefix_key1" : value
or create a map for yourself:
"prefix": {"key1" : value1, "key" : value2}

The key is allways a string, you can either write it:
"key" : value
or
key : value
and the value can be anything, maybe need to be declared in the map for later nbt purposes
Also we set the display name with color codes (check below for more info)

Note: Use for enchantments the enchantment functionality from CT rather than setting nbt, because it makes less issues for later
*/

recipes.addShapedMirrored("clayhoeheadiron", 
<minecraft:clay>.withTag({
	head: "iron_hoe"
	} as IData).withDisplayName("§7Iron §fHoehead in Clay"), 
[
[null, <minecraft:clay>, <minecraft:clay>],
[null, <minecraft:iron_ingot>, <minecraft:iron_ingot>],
[null, <minecraft:clay>, <minecraft:clay>]
]);

/*

This is the same as above, but instead of bracket handlers,
we use vars and initlize them to make sure no wonkey stuff happens :D
var name as types
is initializing

Like this your recipes are much easyer to read.
*/

var gold as IIngredient = <minecraft:gold_ingot>;
var clay as IIngredient = <minecraft:clay>;

recipes.addShapedMirrored("clayhoeheadgold", 
<minecraft:clay>.withTag({
	head: "gold_hoe"
	} as IData).withDisplayName("§6Gold §fHoehead in Clay"), 
[
[null, clay, clay],
[null, gold, gold],
[null, clay, clay]
]);

/*
Useable color codes for strings in displayname and similiar:
§0	black
§1	dark_blue
§2	dark_green
§3	dark_aqua
§4	dark_red
§5	dark_purple
§6	gold
§7	gray
§8	dark_gray
§9	blue
§a	green
§b	aqua
§c	red
§d	light_purple
§e	yellow
§f	white

Note: There is also IFormattedText, which should be used where possible!
+ Make sure your file encoding of the .zs file you use is correct.
Else it can happen, that the special chars are not transfered properly and maybe break your script!
*/


//*X*X* adding hidden recipes! *X*X*


//<minecraft:iron_ingot>.withTag({head: "iron_hoe"} as IData).withDisplayName("§7Iron §fHoehead")

// *X*X* add a recipe for using the clay with nbt as hoe head only! *X*X*


/*
The betterGold recipe is using  lavabucket & waterbucket as reuse()
which means they stay after each craft in the grid and dont get used.
Also we use the function to check if a player is crafting (we dont want it to be a machine itself, 
which would be player == NULL )
and if thats correct we do smth after the craft, with the action.
(we check again for player to make sure no wonkey stuff happens)
then we get a random number the world -> getRandom() object with the nextInt(min, max) methode

We also make sure in the action, that its not executed 2 times.
Because CT scripts normaly run on client (world.isRemote())
and on server (!player.world.isRemote()).
The ! in front of a bool value negates it.
Saying smth like: if the world is NOT remote then its true.
That equals in saying "the world is server"
so isRemote = world is client

After that we use the crafttweaker functioniality to give items to the player.
Works similiar like
/give @p minecraft:dirt 2

but with the pro point, it should make no problems with permission levels on servers

cInfo is the ICrfatingInfo object which has access to inventory(ICraftingInventory), player and dimension
(https://docs.blamejared.com/1.12/en/Vanilla/Recipes/Crafting/ICraftingInfo)

*/

recipes.addShapeless("betterGold",<minecraft:gold_ingot>, [
<minecraft:gold_ore>,<minecraft:lava_bucket>.reuse(), <minecraft:water_bucket>.reuse(), <minecraft:clay>],
function(out,ins,cInfo){
	if(isNull(cInfo.player)){return null;}
	return out;
},
function(out,cInfo,player){

if(isNull(player)){return;}

	if(!player.world.isRemote()){
		var rndm = player.world.getRandom().nextInt(1,3);
		player.give(out*(rndm)); 
	}
});



/*
*X*X* Rewrite this *X*X*


Basically what we do below is this for all things  with "shovel" in name:
var shovel= <minecraft:stone_shovel>.anyDamage();
shovel= shovel | <minecraft:wooden_shovel>.anyDamage();
shovel= shovel | <minecraft:iron_shovel>.anyDamage();
...
and this calculates the minimum durability the tool needs to not break on crafting
(not needed but i find it smarter to not break tools accidently on craft :D)
	.onlyDamageAtMost(item.maxDamage - useDura - 1)

As the docs tell you, 
Transform is for changing the item in the recipeslot and also will let the item stay in the recipeslot(crafting inventory)
the null,null im just using to remember myself there is the function & action i could use.


We now want to have a recipe, that accepts all shovels as IIngriedient.
So we use the or operator " | " for creating a list.
First we try to get a list of all items that have "_shovel" in name.
This list we declare as a val, which is a variable that cant change its
content. example: 
val a =1; a=2;
is not possible! But
var b =10; b= 22;
is possible!

You allways need to decide what you need, a var, a val, a static or a global.
All these have different uses, but 95% of cases you need var or val.

after we declare a var listShovels we wanna fill with all items possible.
Before we set how much durability a shovel uses for the recipe (so we dont destroy the item in crafting,
also MC overuses durability. that means if you have 3 dura left and use up 10, the craft happens but hte item vanishes.

Then we run a for loop for every element found with _shovel and check
if its enchantable (because enchantable = tool/weapon/armor), this should be a sure indicator
together with _shovel that its a tool.
The first time we find smth (var once used for) we set the item as the var listShovels
after we are "or-ing" the other shovels behind the original (or later in loop connected) var

On the IIngredient we use the .anyDamage() , becuase wtihout t the ingridient does not
accept damaged tools. After we also make sure the damage on the tool is not to high!
So we check if maximum damage minus durabilityUsedForRecipe -1 (to make sure tool comes out with 1 durability minimum)

With transformDamage we damage the tool in the craftinggrid for the amount in parenthesis ()
The null,null is a placeholder which you dont need. Normaly there could be a function(on update craftgrid)
and the action (after item is taken out of result)
*/


val allShovels = itemUtils.getItemsByRegexRegistryName(".*_shovel.*"); 
val useDura =10;
var once as bool= true;
var listShovels= <minecraft:wooden_shovel>;


for item in allShovels{
	
	if(item.isEnchantable){

		if(once){ 
			once=false; 
			listShovels = item.anyDamage().onlyDamageAtMost(item.maxDamage - useDura - 1);}
		else{
			listShovels = listShovels | item.anyDamage().onlyDamageAtMost(item.maxDamage - useDura - 1);}
					
	}
	
}

recipes.addShapeless("UseToolForFlint",<minecraft:flint>,[<minecraft:gravel>, 
listShovels.transformDamage(useDura)]);

/*
Now we want to make this smarter than above.
We use a function to take specific var types in and give a specific otu, in this case taking in item and int
returning true or false (bool-ean)
We called the item we get "check" and the int "duraNeeded", which we now can use in the function.
This function returns true, if the item can be damaged (otherwiese the rest of the function wotn work)
and if it has enough durability left (durability is working the opposite in MC, its called damage here)
the maxDamage on wooden_shovel is f.e. 59, if you used it 15x it has a damage of 15 = in 44 dura left
We also subtract 1 from it, to make sure we always stay at 1 (we can also write the script a lil smarter,
excercise1 for you: How to make this smarter from mathwise?)

We now tell the IIngredient that it can have anyDamage, if we dont do that, we cant work with damaged items.
Then we use the more complex only(), where we can add a function inside the parenthesis and return true = item can be used
or false = item cant be used in recipe.

We also use another call for checks/ifs:
duraLeft >= duraNeeded ? true : false ;
value <comperator> compareValue ? <do this if true> : <do that if false>
a little bit less code for easy checks.

In the end, we want to damage the item, taht we do with transformDamage(<amount damage added>)
*/

function duraMinimumNeeded (check as IItemStack, duraNeeded as int) as bool {
	
	if(!check.isDamageable){return false;}
	var duraLeft = check.maxDamage - check.damage - 1 ;
	return duraLeft >= duraNeeded ? true : false ;
	
}
recipes.addShapeless("dirtToFlint",<minecraft:flint>,[<minecraft:dirt>, 
<minecraft:wooden_shovel>.anyDamage().only(function(item as IItemStack){
	return duraMinimumNeeded(item, useDura);
	}).transformDamage(useDura)]);


/*
We can even make the recipe above much smarter!

Instead of just shovel + 1 gravel = 1 flint
we want: shovel + x gravel = x flint (up to a normal crafting grid full 8 gravel)
and use then x times the damage on tool.

And we make it even more cool! We add to the class
IItemStack a new methode, that helps for further scripts too!

First we add the new function:
$expand changedClass$methodeName(variables_needed) as returnClass{doStuff; return class;}
If you want to change the same type/class, you need to have changedClass the same as returnClass

What we do here:
this stands for the object of the above declared class, which is calling the methode.
we basically return itself with changes.
we add anyDamage() so we dont need to type that again, cuz it only works with damageable items :D
then use the only function for checking its damage with the duraNeeded from the methode.


And then we just do the same for a test with sand to flint with wooden shovel.

excercise1 result:
remove the -1 and change it to this "duraLeft > duraNeeded"
*/

$expand IItemStack$hasEnoughDura( duraNeeded as int) as IItemStack {
	return this.anyDamage().only(function(item as IItemStack){
		if(!item.isDamageable){return false;}
		var duraLeft = item.maxDamage - item.damage - 1 ;
		return duraLeft >= duraNeeded ? true : false ;	
	});
	
}

recipes.addShapeless("sandToFlint",<minecraft:flint>,[<minecraft:sand>, 
<minecraft:wooden_shovel>.hasEnoughDura(useDura).transformDamage(useDura)]);

/*
Now we can easy with just a few lines add 7 more compley recipes.

We loop it 7 times, starting on 2 and ending with i = 8
we create each time a new var for the shovels, because we need to do oring each shovel
and check on dura and then transform damage in the end.
On the first time we cant or it with | , because this would error.
Therefore we have a bool as once, so we  set the var only the first time in the second loop.

Then we create a array where we have all ingredients, starting with ored shovellist and based
on which i loop we are in, we add multiple gravels (no we cant do gravel*2 or *3, that would
work only for one field in the crafting grid, thats why we need ot add it like this.


Oh and dont forget! 1.12.2 needs unique names! thats why we concat the string with ~ and the value of i(number of loop)
*/
for i in 2 .. 9 {
	
	once=true; 
	for item in allShovels{	
			if(once){ once=false; listShovels = item.hasEnoughDura(useDura *i).transformDamage(useDura *i);}
			else{listShovels = listShovels | item.hasEnoughDura(useDura *i).transformDamage(useDura * i);}		
	}
	
	var ingArr as IIngredient[] = [listShovels];
	for x in 0 .. i { ingArr += <minecraft:gravel>;}
		
	recipes.addShapeless("UseToolForFlintSmart" ~ i,<minecraft:flint> * i,ingArr);
	
}

/*

Here are also some examples on transforming items in crafting grid, but read the note.
The TransformMe is working properly, even adding flints above flints stack size.
But the second one is wonkey, sometimes not updating, sometimes duplicating items in grid.

transform is calling a function with IItemStack adn IPlayer objects, what it does is up to you,
probably you can even work with give or spawnings there ;)

Note: transforming into a different item in grid brakes the crafting output sometimes
and many times doubles the things inside = making it possible for players to cheat.
You can only reduce or icnrease the ammount of items in the grid, not chnage it completly
(except you ar ein for bugs & glitches)
If you are really in need of changeging stuff from inside crafting,
build an action that gives the player items and remove them from crafting grid.

For actions & functions you can use cinfo.inventory.getStack(index) and setStack(index) 
(if you want to check smth instead of transform) Check  ICraftingInventory
*/



recipes.addShapeless("TransformMe", <minecraft:dirt>.definition.makeStack(1),[<minecraft:dirt>,
<minecraft:flint>.transform(function (item, player){
	return IW.getFromID(0).getRandom().nextInt(1,100) <= 70 ? item *(item.amount + 1) : item *item.amount ;
	})
]);


recipes.addShapeless("TransformMeToo", <minecraft:dirt>,[<minecraft:sand>,
<minecraft:dirt>.transform(function (item, player){
	return player.world.getRandom().nextInt(1,100) <= 70 ? item : <minecraft:glass> ;
	})
]);


/*
But wait! You can even do more with crafting!
This is a short example, where we only show (recipe fucntion) the craft available
if we are in nether.
And if you craft it in nether, you can get exp... or...
some mean mobs near you!
Working with randomizing what happens and where the mobs spawn and also how much exp you get.

*/

recipes.addShapeless("netherXpTorch",<minecraft:torch>*16, [
<minecraft:blaze_powder>,<minecraft:stick>],
function(out,ins,cInfo){
	if(isNull(cInfo.player)){return null;}
	if(!cInfo.player.dimension == -1){return null;}
	return out;
},
function(out,cInfo,player){

if(isNull(player)){return;}
if(!player.dimension == -1){return ;}
	if(!player.world.isRemote()){
		var rndm = player.world.getRandom().nextInt(0,100);
		
		if(rndm >= 70 ){
			player.xp += rndm;
		}else{
			 
			 var horDirect = crafttweaker.world.IFacing.north();
			 var direct = player.world.getRandom().nextInt(1,4);
			 if (direct ==1 ){horDirect = crafttweaker.world.IFacing.north();}
			 if (direct ==2 ){horDirect = crafttweaker.world.IFacing.east();}
			 if (direct ==3 ){horDirect = crafttweaker.world.IFacing.south();}
			 if (direct ==4 ){horDirect = crafttweaker.world.IFacing.west();}
			 for i in 0 to player.world.getRandom().nextInt(1,3){
				<entity:minecraft:silverfish>.spawnEntity(player.world, player.position.getOffset(
					horDirect, player.world.getRandom().nextInt(2,4)));
			 }
			
		}
		
		
	}
});


/*
For more advanced use AFTER crafting happend see:
https://docs.blamejared.com/1.12/en/Vanilla/Events/Events/PlayerCrafted
*/



/*
Below we can find examples on how to use IOreDict and IOreDictEntry.

There are multiple ways to initialize a new oredict entry.
First example works with global keyword oreDict."newName"
After that it shows you how to test, if an oreDict entry exists.

Another way to create a oreDictEntry is <ore:yourName>
(btw a pretty good anime "Your Name" :D)

add can add coma seperated elements.
addItems on the other hand can DIRECTLY add a whole array into IOreDictEntry.
Helpful if you anyhow get an array like with regEx
AddAll accepts another IOreDictEntry, also helpful in secial cases

You can use IOreDictEntry either for testing for a recipe,because it expands IIngredient
or check like below into it for other cases, like later in events 
(you can also use arrays for that, but maybe you want to use the IOreDictEntry in another mod also ? like triumph)

*/
val shovelBlocks = oreDict.shovelBlocks;
if (!(oreDict has "shovelBlocks")) {
	print("shovelBlocks exist!");
}

var alsoOreDict = <ore:shovelBlocks>;
	
shovelBlocks.add(<minecraft:dirt>,<minecraft:sand>);

var otherBlocks as IItemStack[]=[<minecraft:soul_sand>,<minecraft:gravel>,<minecraft:sand>.definition.makeStack(1)];
shovelBlocks.addItems(otherBlocks);

val overGrownDirt = <ore:overGrownDirt>;
overGrownDirt.add(<minecraft:mycelium>,<minecraft:dirt>.definition.makeStack(1),<minecraft:dirt>.definition.makeStack(2),<minecraft:grass>,<minecraft:snow>);
shovelBlocks.addAll(overGrownDirt);

var blockBroken = <minecraft:sand>;

if(<ore:shovelBlocks> has blockBroken) {
	print("Block broken("~blockBroken.definition.id~") included in ore:shovelBlocks") ;
}else{ 
	print("Block broken("~blockBroken.definition.id~") is !!NOT!! in ore:shovelBlocks") ;
}
