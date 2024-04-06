/*
Made by sora_7672 (Discord)

This is a multiline comment / * * /
no spaces.
You can also use // for comments
i recommend not using # for comments, because they can be used for preprocessor too!

Second script is newFunctions.zs, which is accessing this file to explain

*/


/*
At start of each file declare the preprocessor you need.
it starts with #, check wiki for all.
Most important are:
priority <number>
norun

priority 1000 should make sure this script runs before all others(scripts i write after will be 900 and below)
norun will disable this script completly. That also includes access to functions and vars in the script!


*/
#priority 1000

import crafttweaker.item.IItemStack;


/*
static vars can be accessed from other scripts (see newFunctions.zs)
Normal vars cant be accessed!

vars in CT are smart, but only if its obvious what they are, 
so play safe and declare them with var xyz as <type>
Either load the var<type> you need like IItemStack above
or load it in with full path like IItemDefinition

Some types like int, string, bool are allways available

[] decalre an array, as you see in can be changed you can declare the type
and that it is andled like an array "canBeChanged" f.e.

maps are a lil more complicated



*/
static diffSet as string = "easy"; 
var myDiff as string = "cant access!";
var selfTaught = "i know alone, that im a string, without beeing declared"; 
static canBeChanged  as int[]= [123, 456, 789] ;

/*
The "arrays" below are maps, also similiar to multi dimensional arrays like [type][type]
they start with a key which s a sring and then any value(same type on all)
in the examples below we use string & IItemstack
and string & IItemDefinition
There you also see, that you can access var types without importing them,
when you use the "long" call of it like ItemDefinition

strings are normaly indicated with "" or '' 
but its also possible in this case to declare them without the ticks

Here it could get tricky if you have a "var dirt",
on the lower one we declared it as string with "",
so we wont have a problem with declaring the 2nd  map

*/


//var dirt = "blubb";
static myMap as IItemStack[string] = 
{
	dirt : <minecraft:dirt>,
	sand : <minecraft:sand>,
	gravel : <minecraft:gravel>
	
} ;

var gold = "im shiny!";

static defMap as crafttweaker.item.IItemDefinition[string] =
{
	"gold" : <minecraft:gold_ingot>.definition,
	"iron" : <minecraft:iron_ingot>.definition
} ;


/*
Functions can either do smth. and end in a void (returning nothing)
or return a value.

Obviously the fundtion can do smth. and return a value too!
makeLine() is simple using a global keyword function to do smth and returns no value.
you can call it
makeLine();
but you cant
var a = makeLine();
because its not returning smth

calcPlus() takes in 2 integer vars and just simply adds them.
here its important to set the return type in the function declaration
function name(var as inputType,...) as returnType{stuff to do;}

combineIItemStackToString( ) returns strReturn which is declared as string, 
thats why you dont need to declare it on top of the function
you need to transfer a variable or array. You could transfer it like this:
combineIItemStackToString([item1,item2,item3]);
or
var arr =[item4,item5,item6];
combineIItemStackToString(arr);

because it returns a value, you call it like this:
var stringToPrint as string= combineIItemStackToString(arr);



*/

function makeLine() {
	print("---------------");
}


function calcPlus(intA as int, intB as int) as int{
	
	return intA+intB ;
}


function combineIItemStackToString (itemArr as IItemStack[]){
	
	var strReturn as string ="";
	
	for item in itemArr{
		if (strReturn ==""){strReturn = item.definition.id ; }
		else{
			strReturn = strReturn ~" + "~item.definition.id ;
		}
	}
	
	return strReturn;
	
}

/*
There are some infos on variables and functions here:
https://docs.blamejared.com/1.12/en/AdvancedFunctions/Arrays_and_Loops

https://docs.blamejared.com/1.12/en/AdvancedFunctions/Associative_Arrays

https://docs.blamejared.com/1.12/en/Vanilla/Variable_Types/Variable_Types

https://docs.blamejared.com/1.12/en/Vanilla/Variable_Types/Basic_Variables_Functions
*/