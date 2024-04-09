/*
Made by sora_7672 (Discord)

5th script
all about events
*/

/*
Preface:
Events are such a huge topic, that it probably is impossible for me to explain
everything about every methode/property.
If you need some info on any event, let me know in discord/GitHub
and ill see what i can offer.
We will also use a lot event stuff in other scripts, so also check there!

==>Pro tip: Use the Github search function to easy find code over the whole
repo ;)
*/

/*
==>Pro tip: Think about when your files need to run
so make sure, they have access to all other scripts they need.
Like scripts that create custom functions, methodes, propertys
global and static vars.
You cant access stuff, thats not existing at that moment ;)
Code splitting is recommended.
*/
#priority 800

import crafttweaker.world.IFacing as face;
import crafttweaker.block.IBlock;
import crafttweaker.block.IBlockDefinition;
import crafttweaker.item.IItemStack;
import crafttweaker.item.IItemDefinition;
import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.entity.IEntity;
import crafttweaker.player.IPlayer;
import crafttweaker.entity.IEntityLivingBase;




/*
Most important for events is that you use this page to check:
https://docs.blamejared.com/1.12/en/Vanilla/Events/IEventManager

Because some of the event methodes are called different than their eventclass! Like: 
onAllowDespawn -> crafttweaker.event.EntityLivingSpawnEvent
Even if you see most are looking like this:
onAnimalTame -> crafttweaker.event.AnimalTameEvent

Allways check when using a new event.

Lets start with smth. "simple":
onEntityLivingDeath -> crafttweaker.event.EntityLivingDeathEvent
We create an event that starts an explosion when a player kills a living entity.
So far you should be able to read the docs a little.
We go to eventmanager, open the EntityLivingDeathEvent infos, where we see
we have directly access to "damageSource"(IDamageSource) only, but the event extends 
ILivingEvent & IEventCancelable so we also have access to.
Most events can be be stopped from happening by .cancel() and events can be checked 
if event.canceled == true.
ILivingEvent -> entityLivingBase & extends IEntityEvent
IEntityEvent -> IEntity
From all this accesses we can brachiate through to almost everything we need.
Even if its not obvious from the first looks.

Using event.entityLivingBase is possible, but also event.entity
and because IEntityLivingBase extends IEntity, we have from there more access
than from IEntity only.
Its still worth to check through the extensions till you know many.
Sometimes tehre are connections you dont have in you mind.

Try to read this event alone first. Explanation below.

*/


events.onEntityLivingDeath(function(event as crafttweaker.event.EntityLivingDeathEvent){

if(event.damageSource.getDamageType() =="player") {
	
	if(true){
	event.entityLivingBase.world.performExplosion(
	<entity:minecraft:ender_pearl>.spawnEntity(event.entityLivingBase.world, event.entityLivingBase.position)
	, event.entityLivingBase.x, event.entityLivingBase.y, event.entityLivingBase.z, 3, false, false);
	}else{
		<entity:minecraft:tnt>.spawnEntity(event.entityLivingBase.world, event.entityLivingBase.position);
	}
	
	}else{return;}

	
});

/*
So we call a event like above.
events.<eventmethode> (function(varName as crafttweaker.event.<eventClass>);
Thats why you should allways check the eventmanager, to ensure you use the right <eventmethode> and <eventClass>

Make sure that on every event you create, to check all conditions possible first!
Because it lets your code only run, if really needed. Some events work with ticks (20x per second)
and just imagine you would have to run complex calculations 20x per second...
And then maybe for 100 players on a server? That could really make problems based on how minimized your code is.

On many events you will check if the event runs on the clientside or the server side.
Because sometimes things could happen twice then (like giving items, spawning 2 entitys where one is a ghost entity and more)
Short reminder:
isRemote = world is client
! isRemote = world is server
In SP your PC autostarts a server for only you, so both are run on your machine.
Debugging and testing in MP can be a bit more complex.
(All this code is created& tested only in SP if not stated different)

We have here 2 ways to perform "an explosion" at the killing spot.
The first is really starting an explosion on teh position of the entity, the second is spawning a entity primedTNT,
which will explode after a few seconds.
On the real explosion we need to note, that there is a createExplosion and a startExplosion event,
which basically use the same parameters, but create does not "go boom" :D
Therefore, performExplosion(IExplosion) will just explode with a created IExplosion.
Maybe this can be used for timed explosions or such? Just an idea :)


Infos to IDamageSource:
world.isRemote -> getting right damage type, but cant perform things
! world.isRemote -> gets allways generic damage type but can perform stuff


*/

function createDropBlock ( pos as IBlockPos, world as IWorld) as void{
	
	if(world.getBlockState(pos).isReplaceable(world,pos)){ return;}
	//remove blocks that should not drop like spiderwebs, seeds/wheat, leafs,farmland, mushrooms, portals

	var tmpEntity as IEntity = itemUtils.getItem(world.getBlock(pos).definition.id, world.getBlock(pos).meta).createEntityItem(world, pos);
	world.setBlockState(<blockstate:minecraft:air>, pos);
	world.spawnEntity(tmpEntity);
	
}
/*
Above we tested to create a function that drops the blocks.
Because we could use it for later and more also, we started to extend the classes.
Thats why we now will split our code.
We will use a few extensions for classes, everytime we use it a first time,
we will tell you which it is and why we created it.
Therefore we have a minimum in the extensions.zs file explained.

Here we wanted a easy way to drop an item entity,
so we extended IBlockPos & Position3f with .spawnDrop(IWorld)
which "drops" the item at the position without jumping through 3 other classes each time.


Make sure you call the new functions correctly, else you will get errors like these:
ERROR: [crafttweaker]: Error executing {[800:crafttweaker]: easy_examples\aboutEvents.zs}: null, caused by java.lang.NullPointerException

Try to read the event yourself first and understand it.
Below you get the explanation (i do this now and then, so you get used to the calls&syntax :P)
*/

events.onBlockBreak(function(event as crafttweaker.event.BlockBreakEvent){
	
	
	if(event.isPlayer){
		if(isNull(event.player.currentItem)){return;}
		if (event.player.currentItem.definition.id == <minecraft:stone_pickaxe>.definition.id){
				
			var direction = event.player.getHorizontalFacing();

			
			event.position.getOffset(face.up(), 1).spawnDrop(event.world);
			event.position.getOffset(face.down(), 1).spawnDrop(event.world);
			
			if (direction == face.north() || direction == face.south()){
				event.position.getOffset(face.west(), 1).spawnDrop(event.world);
				event.position.getOffset(face.west(), 1).getOffset(face.up(), 1).spawnDrop(event.world);
				event.position.getOffset(face.west(), 1).getOffset(face.down(), 1).spawnDrop(event.world);
				event.position.getOffset(face.east(), 1).spawnDrop(event.world);
				event.position.getOffset(face.east(), 1).getOffset(face.up(), 1).spawnDrop(event.world);
				event.position.getOffset(face.east(), 1).getOffset(face.down(), 1).spawnDrop(event.world);
				
			}
			if (direction == face.east() || direction == face.west()){
				event.position.getOffset(face.south(), 1).spawnDrop(event.world);
				event.position.getOffset(face.south(), 1).getOffset(face.up(), 1).spawnDrop(event.world);
				event.position.getOffset(face.south(), 1).getOffset(face.down(), 1).spawnDrop(event.world);
				event.position.getOffset(face.north(), 1).spawnDrop(event.world);
				event.position.getOffset(face.north(), 1).getOffset(face.up(), 1).spawnDrop(event.world);
				event.position.getOffset(face.north(), 1).getOffset(face.down(), 1).spawnDrop(event.world);
			}	
			
		}
		
		if (event.player.currentItem.definition.id == <minecraft:golden_pickaxe>.definition.id){

			var direction = event.player.getHorizontalFacing();

			var left = face.north();
			var right = face.north();
			
			
			if (direction == face.north()){
				left = face.west();
				right = face.east();
			}
			if (direction == face.east()){
				left = face.north();
				right = face.south();
				
			}
			if (direction == face.south()){
				left = face.east();
				right = face.west();
			}
			if (direction == face.west()){
				left = face.south();
				right = face.north();
			}
			var startPos =event.position.getOffset(left,1).getOffset(face.up(), 1);//starting point top left position of cube
			var targetPos as IBlockPos;
			
			var lPMax = 5;
			var rPMax = 3;
			var hPMax =3;
			
			
			for heightP in 0 to hPMax{
				for rowP in 0 to rPMax{
					for lineP in 0 to lPMax {
						
						targetPos = startPos.getOffset(direction.opposite,lineP).getOffset(right,rowP).getOffset(face.down(),heightP);
						
						targetPos.spawnDrop(event.world);
					}	
				}	
			}//end of looping	
		}//end gold pick
		
	}
	else{
		//to much spam for the log so commented out
		//print("Smth. else broke the block ("+event.block.definition.id+") was broken at :"+event.x +" "+event.y +" "+event.z);
	}	
		
});

/*
Its important if you use events, that they only trigger under specific conditions,
otherwise players maybe able to spam stuff. So allways think about, when should smth happen and in which cases not.
Here we just want it to be when the player is breaker and the item they hold is gold pick or stone pick to do different things.

Important! Check for curentItem isNull before! Else nullpointer exceptions can occur
First checking with .matches() is not working properly in events! Reason, its an IItemStack and not IIngridient anymore.
Means you cant check if the item is damaged that way. Thats why we check only on the id of the mainhand item and compare it (its a string)

On the stone pick we get the direction player is looking at as var, to use for later positionings of blocks.
Then we spawnDrop (selfmade extension of IBlockPos that "fake breaks" a block) the blocks above and below the broken block.
After we check on the facing, so we can find out which blocks are left & right the event block and based on that we do the same. So we get a 3x3 area broken arround the event position.
getOffset(IFacing, int) is your best friend for IBlockPos  to
get access to other blocks in the world. What it does is basically adding
a int to the position XYZ based on waht the IFacing is (north,east,west,south, up or down). Because it returns also IBlockPos,
you can do: IBlockPos.getOffset().getOffset() to change the X&Z at the first and then the Y position on 2nd.

The Gold pick part is a lil more complex, because we need to really get the right and left directions as vars. We create a 3 dimensional area that should be dropped. Imagine now we do it 2d:
X Y Z
X Y Z
X Y Z
First we run through X, easy just one position change.
Then we run a loop to get to y&z, where we just add every loop one more to the side.
This is now the topdown view, but we need to go down, therefore we need a 3rd loop adding the height. Names should explain ebst waht does what.
And because if we just add stuff, we work with the integer inside the loop to have no errors in accessing each block without resetting.
Here its cruical to remember again CT is topdown scripting!
The wrong order of things happening could give different results.
Specially on loops its important to think it through.
*/


events.onClientTick	(function(event as crafttweaker.event.ClientTickEvent){
	
	
	if(isNull(client)){return;}
	if(isNull(client.player)){return;}
	if(isNull(client.player.world)){return;}
	if(!client.player.world.isRemote()){return;}
	var minsToCheck = 5;
	if(client.player.world.time % (20*60*minsToCheck) == 0){
		if(!(client.language == "en_us")){//change the value of string if you play english version to check
			print("client language: "~client.language);
			client.player.sendChat("Your clients language is not english.");
			client.player.sendChat("§c[BE AWARE]§f This modpack only is available in english");
		}
	}
		
});

/*
Again, dont forget to encapsulate your checks on TRUE/FALSE in parenthesis.
Otherwise you cant negate them like this:
if(!true){}
if(!(1+1 == 2)){}
like we did here with:
if(!(string == string)){}

I dont know what you want to do with clientTick, but you can do a few things with it,
when you just want to do smth with the players site (not sure how it handles with server/client environment for commands and such)
This is just a short example what i could imagine with it and how to use the "client" gloabl keyword :)
We check if your language is not english, because the modpack is only in one language (could maybe make problems with translated versions)
Dont know. You could check here on cheat mods and just "break" the client of the user so they cant join your server or so.
Maybe there is a way to check on ressourcepack loaded, have not seen so far. (DM me if you know a solution to check on it :D)

Important is that we check on the client -> player -> world objects if they exist, 
if not the game throws a lot errors if you dont stop in between.

*/



events.onLivingExperienceDrop(function(event as crafttweaker.event.LivingExperienceDropEvent){
	//event is even fired if no xp are dropped, like from player dieing with 0 exp
	//event only accurs if killed by player
	if(event.originalExperience == 0){return;} 
	if(isNull(event.player)||isNull(event.player.uuid)){return;}
	if(!(event.entity.definition.id == "minecraft:wither" || event.entity.definition.id =="minecraft:skeleton_horse")){return;}

	
	var playerArray = event.entity.server.commandManager.getTabCompletions(event.entity, "give ");

	var expAll = event.droppedExperience / playerArray.length;
	
	server.commandManager.executeCommand(server, "xp @a "~expAll);
	server.commandManager.executeCommand(server, "say You all gained EXP: "~expAll);
	server.commandManager.executeCommand(server, "say Someone slayed a boss!");
	event.droppedExperience = 0;

});

/*
*X*X* Needs a solution to just run the command tab complettion all 1-2 minutes
cuz it produces lag a lil :/

What we did on exp drop event is first checking if any xp are dropped,
then check if the entity is a player (if not, its just returning a EntityLivingBase /Entity)
if it is a player, we want to ignore it also.
Lastly checking on a specified entity (wither & skeleton horse here)


Now we need to do smth tricky. We want to get the number of players online.
We get a list of "usernames" by getTabCompletions with "give ", which will be normaly followed by playername
then we get the length of the array 

==> Pro tip: When you check the docs, you sometimes see: list <strings>
which is the same as [string] or string[].
If you do, you can try array opperations like .length or list[0] (array[0])

*/



/*
With the impact arrow event we can do a lot.
Basically its where your arrow stopped, if you shoot in the sky, it stops when hitting the groudn again (or a floating island :D)
This event works with IRayTrace and the result of it. You can imagine that like sending a laser in oen direction and
result with where it shows the red dot.

First we check if we hit a block and then get the block into a var to easy compare.
We created 3 conditions.
First condition is to check for a glass block, if we find it, we remove the glass (means in blockstate style allways ste it to air!)
and setDead the entity = removing it from the world aka killing it (no drops if its a monster or so)

the second and the third not only check the block, but also the arrows(entitys) conditon isBurning (when you shoot through lava for example)
and instead of removing the block, we place a water source there (like melting the ice or packed ice)
*/
events.onProjectileImpactArrow(function(event as crafttweaker.event.ProjectileImpactArrowEvent){

	if(event.rayTrace.isMiss){print("yeahii you missed");return;}
	if(event.rayTrace.isBlock){ 
		var hitBlock = event.arrow.world.getBlock(event.rayTrace.blockPos);
				
		if(hitBlock.definition.id == <minecraft:glass>.definition.id){
			event.arrow.setDead();
			event.arrow.world.setBlockState(<blockstate:minecraft:air>, event.rayTrace.blockPos);
		}
		
		if(hitBlock.definition.id == <minecraft:packed_ice>.definition.id){
			if(event.arrow.isBurning){
				event.arrow.setDead();
				event.arrow.world.setBlockState(<blockstate:minecraft:ice>, event.rayTrace.blockPos);		
			}
			
		}
		
		if(hitBlock.definition.id == <minecraft:ice>.definition.id){
			if(event.arrow.isBurning){
				event.arrow.setDead();
				event.arrow.world.setBlockState(<blockstate:minecraft:water>, event.rayTrace.blockPos);		
			}
			
		}
		
	}
});


/*
Sadly the zombie destroy nbt is so rare, its not worth coding smth for it, because bad to test without extra code.
So we just checked if the with is destroying,
then check if the definition id has the term "log" in it.
instead of "has" you can use "in" also, but for me thats to confusing :D
you can use "has" for checking in strings, lists or arrays.
We just cancel the event if wither trys to destroy mother nature.


*/
events.onLivingDestroyBlock	(function(event as crafttweaker.event.LivingDestroyBlockEvent){
	
	if(event.entityLivingBase.definition.id == <entity:minecraft:zombie>.id){
		//Zombie block breaking occurs ultra rarely because of the conditions that need to be set.
		// no need to use this.
	}
		
	if(event.entityLivingBase.definition.id == <entity:minecraft:wither>.id){
		if(event.state.block.definition.id has "log"){
			event.cancel();
		}
	}
});



events.onPlayerAnvilUpdate(function(event as crafttweaker.event.PlayerAnvilUpdateEvent){
	if(event.leftItem.definition.id == "minecraft:diamond_sword"){
		if(event.rightItem.definition.id == "minecraft:emerald"){
			if(event.leftItem.amount ==1){	
				event.outputItem = event.leftItem.withTag({diamerald: true}).withDisplayName("§3Diam§aerald§f SWORD").withLore(["line 1","line 2","this is a §3Di§6am§aer§dald§f SWORD"]);
				event.xpCost = 3;
			}
		}
	}
});

/*
Here we tryed to create new recipes with anvil, but sadly that wont work without another add on.
So we did the second best, create a interesting diamond sword.
Should be self explaining what we did there.

In the output of update (update runs every time the name is changed or an item is moved in the crafting grid)
we added some tag(nbt) and played a lil with lore and displayname and colors. So you know how to use this for lets say
an rpg setup or SP explore world.

The anvil repair event basically runs when you pull out the result.
You can then run randomizers (not in the above, because the update is like a recipe function and the repair like a recipe action)
and here we had a chance to give out a diamond and otherwise send a message to the player.
*/

events.onPlayerAnvilRepair(function(event as crafttweaker.event.PlayerAnvilRepairEvent){
	if(event.itemResult.tag.diamerald){
		if(!isNull(event.player)){
			if(!event.player.world.isRemote()){
				event.player.world.getRandom().nextInt(0,100) >=40 ?
				event.player.give(<minecraft:diamond>): event.player.sendChat("[ANVIL]:Better Luck next time");
			}
		}
	}
});



/*
We set here an if, because this could be annoying for further scripts. to test it just set the false to true :D

There was a question in the CT discord, how to make food heal based on saturation and dont heal over time.
Therefore we needed to disable the normal healing on player, only allow healign if the player has a specific nbt tag.
And when he eats smth we set the tag to true, which will be reset when he heals.
Also we use the heal function for living entitys, hwere we heal 10* the saturation, because its a 0.1-1.0 number,
and healt is a 1-10 number.

to set the Tag/NBT properly on entitys you need to know the exact spelling of each parameter. if you are usnure you can use:
print(entity.nbt as string);
when you set the NBT its automatically inside the "ForgeData" so you need to call the forge data and then the new keys.
.nbt.ForgeData.yourKey
also make sure you set the type for the nbt, it helps preventing big data in entitys and errors.
To disable the healing, we just set the amount healed to 0, we could also use the .cancel() methode of the event.
*/

if(false){
	
	
	events.onEntityLivingHeal(function(event as crafttweaker.event.EntityLivingHealEvent){
		if(event.entity instanceof IPlayer){
			var player as IPlayer= event.entity;
			if(isNull(player.nbt.ForgeData.healMe)){event.amount = 0; }
			else{
				if(player.nbt.ForgeData.healMe == 1){
					player.setNBT({healMe: 0 as byte});
				}else{event.amount = 0;}
			}
		}
	});
	
	events.onEntityLivingUseItemFinish(function(event as crafttweaker.event.EntityLivingUseItemEvent.Finish){	
		if(event.isPlayer){
			if(event.item.saturation >0){
				event.player.setNBT({healMe: 1 as byte});
				event.player.heal(event.item.saturation *10);	
			}
		}
	});
	

}//end if true




events.onLootingLevel(function(event as crafttweaker.event.LootingLevelEvent){
	if(event.damageSource.getDamageType() =="player"){
		if(event.damageSource.getImmediateSource() instanceof IPlayer){
			var player as IPlayer = event.damageSource.getImmediateSource();
			
			if(isNull(player.nbt.ForgeData.extraLootingExp)){player.setNBT({extraLootingExp: 1 as int});}
			else{
				var nExp = player.nbt.ForgeData.extraLootingExp +1;
				player.setNBT({extraLootingExp: nExp as int});}
			var lootLvl = 0;
			if(player.currentItem.isEnchanted){
				var enchs= player.currentItem.enchantments;
				for en in enchs{
					if(en.displayName has "Looting"){lootLvl = en.level;}
				}

			}
			
			event.lootingLevel = lootLvl +(
			(
				(player.nbt.ForgeData.extraLootingExp - 1) -
				(player.nbt.ForgeData.extraLootingExp - 1)%10
			)
			/10);
		
			print(event.lootingLevel);
			
		}
	}
	else{return;}
	
});
/*

==>Pro Tip: If you calculate and use - make sure you allway use space before numbers or you produce errors!
"500 -29" = error
"500 - 29" = all good!
Brackets are your friends to do stuff in right order!

This event is getting allways called when a entity dies and is about to drop smth.
based on the looting level and if it will drop smth, you can get more loot.
Here we just add +1exp ever kill and every 10exp give the killer 1 looting level more.
We work again with NBT data on the player here.
We also check on the hold item "Looting" enchantment, here we need to make sure on testing, 
that its case sensetive! so "looting" != "Looting" like we need it here.
Check the enchantment displayname to make sure you get it right, or work with string functions
to set all lower or all upper case ;)

The tricky part here is, that we need to get out of the entity object a player obeject.
But because the IPlayer is a upper class of IEntityLivingBase (which is a upper class of IEntity)
it is possible to say "var player as IPlayer", but before we need to test for it! 
with "instanceof IPlayer". This methode you can also use to check for other obejct types.
"vartype1 instanceof vartype2" is the syntax and returns a bool.

*/

events.onPlayerAdvancement(function(event as crafttweaker.event.PlayerAdvancementEvent){
	if(event.id == "minecraft:story/mine_diamond"){
		
	}
	
	if(event.id has "end"){
		var pos = event.player.position;
		var myFace= crafttweaker.world.IFacing.north();
		for i in 0 to event.player.world.getRandom().nextInt(10,20){
			
			var rand = event.player.world.getRandom().nextInt(0,3);
			if(rand == 0){myFace= crafttweaker.world.IFacing.north();}
			if(rand == 1){myFace= crafttweaker.world.IFacing.east();}
			if(rand == 2){myFace= crafttweaker.world.IFacing.south();}
			if(rand == 3){myFace= crafttweaker.world.IFacing.west();}
			<entity:minecraft:ender_pearl>.spawnEntity(event.player.world, 
			pos.getOffset(myFace, event.player.world.getRandom().nextInt(1,4))
			.getOffset(face.up(), event.player.world.getRandom().nextInt(0,3))
			);
		}
	}
	
});


/*
*X*X* on diamond add a diamond entity above player, unpickable and floating in air for 10 seconds
==> Pro Tip: Use this together with triumph to create a great stageing sytem ;)
Or let your imagination run wild with what you can do!


Here we check if any end advancement is done and spawn up to 20 ender pearls near the player floating around.
We randomize the facing with getOffset again and use a nextInt for getting one random direction its offset too.
*/

events.onItemFished(function(event as crafttweaker.event.ItemFishedEvent){
	if(10< event.fishHook.world.getRandom().nextInt(0,100)){
		
			var timeToKill = event.fishHook.world.getWorldTime() +100;
		    var guardian as IEntityLivingBase = <entity:minecraft:guardian>.createEntity(event.fishHook.world);
            guardian.setCustomName("MOBY DICK");
            guardian.setNBT({killTime: timeToKill});
            guardian.setPosition(event.fishHook.position);
            event.entityLivingBase.world.spawnEntity(guardian);
			
	}
	
	
});

events.onEntityLivingUpdate	(function(event as crafttweaker.event.EntityLivingUpdateEvent){
	if(!(event.entityLivingBase.world.getWorldTime() % 20 == 0)){return;}
	if(isNull(event.entityLivingBase.nbt)){return;}
	if(isNull(event.entityLivingBase.nbt.ForgeData)){return;}
	if(isNull(event.entityLivingBase.nbt.ForgeData.killTime)){return;}
	if(event.entityLivingBase.world.getWorldTime() >= event.entityLivingBase.nbt.ForgeData.killTime){
		print("it should die now..");
		event.entityLivingBase.setDead();
	}
	
	
});

/*
*X*X* Set the guardian to invulnable, move the player to the guardian

The fishing event happens when the player pulls a item in by clicking.
We just spawn at the hooks position (again random :D) a guardian with special stats.
Like new name and invulnable. We give that one also nbt data and basically created a timer with it.

On the second event we check on the time that the world has, if its higher then the timerdata in the nbt of
the entity, we just kill it again(setDead)
*/

/*
For more events check blocks and entitys.
Maybe here wont follow all events.

*/