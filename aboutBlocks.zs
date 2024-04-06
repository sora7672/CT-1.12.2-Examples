/*
Made by sora_7672 (Discord)


WIP
feel free to DM me and contribute!
*/
//event.player.offHandHeldItem(i).mutable().shrink(event.player.offHandHeldItem(i).amount));

#norun
#priority 4

import crafttweaker.events.IEventManager;
import crafttweaker.util.Position3f;
import crafttweaker.world.IBlockPos;
import crafttweaker.block.IBlockState;
import crafttweaker.world.IVector3d;
import crafttweaker.entity.IEntity;
import crafttweaker.world.IFacing;




var airReplaceItem = <minecraft:flint>;


function getBlockInFrontOfLooking (ent as IEntity){
	
	var WF = 
	crafttweaker.world.IFacing ; //so we have EF.up() .down() .north() .east() .south() .west()
	var nearestBlock as IBlockPos;// return a IBlockPos object
	var ELD = ent.lookingDirection; //shorten varname
	var EP = ent.position;//shorten varname
	
	var EH = ent.gethorizontalFacing();// ERROR = entity has not scuh methode ???
	
	
	
	//get height entity is looking at
	if (ELD.y >= -1.0 && ELD.y > -0.75){//below feet (-1)	
		nearestBlock = EP.getOffset(WF.down(), 1);
	}
	if (ELD.y >= -0.75 && ELD.y > -0.5){//at feet (0)
		nearestBlock = EP;
	}
	if (ELD.y >= -0.5 && ELD.y > -0.25){//at face (+1)
		nearestBlock = EP.getOffset(WF.up(), 1);
	}
	if (ELD.y >= -0.25 && ELD.y > 0.5){	//above face (+2)
		nearestBlock = EP.getOffset(WF.up(), 2);
	}
	//--------------------
	//maybe adding on top of head, but need to get entity height before that to not suffocate it
	//--------------------
	
	
	nearestBlock = nearestBlock.getOffset(EH, 1);
	
	
	if(isNull(nearestBlock)){
		nearestBlock = EP.getOffset(WF.north(), 1).getOffset(WF.up(),1);
	}
	
	return nearestBlock;
	
}



events.onPlayerRightClickItem(function(event as crafttweaker.event.PlayerRightClickItemEvent){

	//script runnning 2x still

		if(event.player.world.isRemote()){return;}
		if(isNull(event.player.uuid)){return;}
		if(isNull(event.player.currentItem) || isNull(event.player.offHandHeldItem)){return;}
		
		if(!event.player.currentItem.matches(airReplaceItem)){return;}
		
		var playerOff =event.player.offHandHeldItem;
		

		if(!playerOff.isItemBlock){return;}
		if(!isNull(playerOff.tag.BlockEntityTag)){return;}
		if (event.player.getCooldown(playerOff) > 0){return;}
		
			var blockSt = playerOff.asBlock().definition.getStateFromMeta(playerOff.metadata);
			
			var pFace = event.player.lookingDirection.y;
			var blockP as IBlockPos = blockP = event.player.position.getOffset(crafttweaker.world.IFacing.up(), 1).getOffset(event.player.getHorizontalFacing(), 1);
			/*
			y between -1.00 to -0.75 = -1 block
			y between -0.75 to -0.5 = 0 block
			y between -0.5  to 0 = +1 block
			y between  0 to 0.5 = +2 block
			*/
			
			
			/*
			Use the new function to get the nearest block!
			*/
			blockP = getBlockInFrontOfLooking(event.player as IEntity);
			
			//check position replacebale before
			 if (event.player.world.getBlockState(blockP).isReplaceable(event.player.world, blockP)) {
				event.player.world.setBlockState(blockSt, blockP);
				event.player.setCooldown(playerOff,1);
				event.player.offHandHeldItem.mutable().shrink(1);
			 }
		
	}
);

//stop block place event if using airReplaceItem

events.onBlockPlace(function(event as crafttweaker.event.BlockPlaceEvent){
	
		if(event.player.world.isRemote()){return;}
		if(isNull(event.player.uuid)){return;}
		if(isNull(event.player.currentItem) || isNull(event.player.offHandHeldItem)){return;}
		
		if(event.player.currentItem.matches(airReplaceItem)){event.cancel(); return;}
});
