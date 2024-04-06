/*
Made by sora_7672 (Discord)

If you are new with CT(crafttweaker) this is the file where you should start to understand some basics with!
(vars and fucntions and such more beginner stuff found in config.zs)
After that follow the priority, i create higher prio for easy scripts and lthe lower it goes for more complex stuff
which maybe is including stuff you learned in prior scripts.

And lastly! Never give up on a problem, split it to smaller problems parts and overall
HAVE FUN CODING!

Pro Tip:
You can open the github for the docs here:
https://github.com/CraftTweaker/CraftTweaker-Documentation
if you search then like this:
repo:CraftTweaker/CraftTweaker-Documentation path:/^docs\/1\.12\/content\//  mySearchWord

and exchange "mySearchWord" for smth. you need, like f.e. anvil
you can easyer find stuff ;)
(sadly i learned this 2 years after i started with 1.12.2 modpackdesign :D)

*/

#priority 900

/*
Importing the crafttweaker parts you need is important!
Otherwise in specific cases you can get nulpointer exceptions
or type unknown errors or similiars.

You can import your own .zs files like this
if you write "import x.y.z as myName" you are able to call them
with less text and easyer to read here we use "conf"
you can also access methodes/vars with import and call them with the name you give them
*/
import crafttweaker.item.IItemStack;

import scripts.easy_examples.config as conf;
import scripts.easy_examples.config.makeLine as ml;


/*
The 2 methode calls below do exactly the same
The first is accessing the script with its full path (no import needed)
the second is calling the script path as we declared above with less code

To make sure all works well i recommend importing what you need
also it helps for better readability


*/
scripts.easy_examples.config.makeLine();
conf.makeLine(); 


/*
Below first we access the diffset var,
which is accessiable because its a static
Its value can not be changed after the script is loaded

the var myDiff is nt accessiable! Thats why its commented out
to not result in an error. Normal vars are not accessiable

the var canBeChanged is an array. Accessing arrays work different then other vars.
var arr =["a","b","c"];
arr[0] -> is "a"
arr[1] -> is "b"
arr[2] -> is "c"
it starts allways with the 0s element not with 1st!

First we print the value manual,
below that we do a for loop to access every item in canBeChanged,
which we declare as number.
The loop basically does:
number = conf.canBeChanged[<number of times run -1>]
so first time run as arr example the result is "a"
second run result "b" and last(third) run "c"
(below t gives the values declared in config.zs

*/
print(conf.diffSet); 
//print(conf.myDiff);

print(conf.canBeChanged[0]);
print(conf.canBeChanged[1]);
print(conf.canBeChanged[2]);

print("Above is the same as the loop below: ");

for number in conf.canBeChanged {
	
	print(number);
}

conf.makeLine();

/*


Print is only accepting strings to write into the log
or numbers which will be auto converted to a string.

So for myMap, which is a map with a key(string) and a value as IItemStack
we need to get anyhow a string.
Because IItemStack has access to definition (IItemDefinition)
we can call the id which is a string.

conf -> the imported script
.myMap -> the static variable in the script
.dirt -> the key in the map which gives the value <minecraft:dirt>
 ^ above we could also use .sand or .gravel as declared in config.zs
then as we checked in the docs the zengetter(propertys/methodes)
.definition -> which returns another object of class IItemDefinition
.id -> which is a property of the IItemDefinition and gves a string value

==>Pro tip: You can also split a long call with property.property.property.methode().property 
in multiple lines ans we did with myMap starting with "." in the new line


below we access defMap, which is not itemstacks but allready definitions.
So we dont need to call them as above, we can just call them script.var.itemdef.id as below
where the key is used you can use "" for string, but its looking weird and recommend not doing it like this.
Just its possible :D


*/
print(conf.myMap.dirt 
.definition.id
as string);

print(conf.defMap."gold".id);
print(conf.defMap.iron.id);

ml();
ml();
ml();

/*
Calling functions or better methodes of other scripts with transfering values
can be a lil tricky at first. Its important, that you know from aynwhere 
which values/parameters the function/methode needs to get from you.
Both of our functions return a value, so we need to cast it into a variable
like the calcPlus function into numb

or directly use the value as we did with the print below.
As you saw in the print in log, the wool is only returning wool, no matter whcih wool.
Thats because our function dont return meta values or variants.
Thats intended, more to this later.


*/
var numb=conf.calcPlus(123,77);
print(numb);



val arrayOfItems as IItemStack[]= [<minecraft:stone>,<minecraft:iron_sword>, <minecraft:flint>, <minecraft:wool:0>, <minecraft:apple>, <minecraft:wool:7>];
print(conf.combineIItemStackToString(arrayOfItems));



/*


**** Here we can add some in deepth things with functions and more
*/