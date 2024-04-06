/*
Made by sora_7672 (Discord)

4th script
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
events.<zenmethode> (function(varName as crafttweaker.event.<eventClass>);
Thats why you should allways check the eventmanager, to ensure you use the right <zenmethode> and <eventClass>

Make sure that on every event you create, to check all conditions possible first!
Because it lets your code only run, if really needed. Some events ork with ticks (20x per second)
and just imagine you would have to run complex calculations 20x per second...
And then maybe for 100 players on a server? That could really make problems based on how minimized your code is.

On many events you will check if the event runs on the clientside or the server side.
Because sometimes things could happen twice then (like giving items, spawning 2 entitys where one is a ghost entity and more)
Short reminder:
isRemote = world is client
! isRemote = world is server
In SP your PC autostarts a server for only you, so both are run on your machine.
Debugging and testing in MP can be a bit more complex.


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
From here on we will split our code.
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
	else{return;}
	
	
	
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

=> Pro tip: When you check the docs, you sometimes see: list <strings>
which is the same as [string] or string[].
If you do, try array opperations like .length or list[0] (array[0])

*/


events.onProjectileImpactArrow(function(event as crafttweaker.event.ProjectileImpactArrowEvent){

	if(event.rayTrace.isMiss){print("yeahii you missed");}
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
			else{return;}
		}
		
		if(hitBlock.definition.id == <minecraft:ice>.definition.id){
			if(event.arrow.isBurning){
				event.arrow.setDead();
				event.arrow.world.setBlockState(<blockstate:minecraft:water>, event.rayTrace.blockPos);		
			}
			else{return;}
		}
		
	}else{return;}
});




/*
TO DO EVENTS:


https://docs.blamejared.com/1.12/en/Vanilla/Events/Events/ItemFished
???

https://docs.blamejared.com/1.12/en/Vanilla/Events/Events/LivingDestroyBlock
only triggers on zombies( breaking doors) i think when zombie does
maybe spawn angry villager, immun to zombie attacking the zombie?
Or golem?


https://docs.blamejared.com/1.12/en/Vanilla/Events/Events/LootingLevel
???

https://docs.blamejared.com/1.12/en/Vanilla/Events/Events/PlayerAdvancement
???

*/