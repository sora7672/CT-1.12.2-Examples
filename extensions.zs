/*
Made by sora_7672 (Discord)



This script will be cross used over multiple examples.
Starting with the 4th script aboutEvents.zs

Priority will be set to 1000, like any config we will do.
*/


#priority 1000


/*
We will have to import a lot of scripts,
because every init of a classtype/vartype we need the 
corresponding main script.
*/




import crafttweaker.block.IBlock;
import crafttweaker.block.IBlockDefinition;

import crafttweaker.item.IItemStack;
import crafttweaker.item.IItemDefinition;
import crafttweaker.item.IIngredient;

import crafttweaker.world.IWorld;
import crafttweaker.world.IBlockPos;
import crafttweaker.world.IFacing;

import crafttweaker.entity.IEntity;

import crafttweaker.data.IData;
import crafttweaker.util.Position3f;





$expand IItemStack$hasEnoughDura( duraNeeded as int) as IItemStack {
	return this.anyDamage().only(function(item as IItemStack){
		if(!item.isDamageable){return false;}
		var duraLeft = item.maxDamage - item.damage - 1 ;
		return duraLeft >= duraNeeded ? true : false ;	
	});
	
}


$expand IBlockPos$spawnDrop (world as IWorld) as void{
	if(world.getBlockState(this).isReplaceable(world,this)){ return;}
	if(!isNull(world.getBlock(this).fluid)){ return;}
	if(!(world.getBlock(this).definition.creativeTab.tabLabel == "buildingBlocks")){return;}
	
	
	var noDropArray as string[] = [ "minecraft:leaves", "minecraft:leaves2", "minecraft:brown_mushroom_block", "minecraft:red_mushroom_block", "minecraft:glass", "minecraft:stained_glass" ];
	if(noDropArray has world.getBlock(this).definition.id){return;}
	
	var tmpEntity as IEntity = itemUtils.getItem(world.getBlock(this).definition.id, world.getBlock(this).meta).createEntityItem(world, this);
	world.setBlockState(<blockstate:minecraft:air>, this);
	world.spawnEntity(tmpEntity);
	
	
	
}

$expand Position3f$spawnDrop (world as IWorld) as void{
	this.asBlockPos().spawnDrop(world);	
}

