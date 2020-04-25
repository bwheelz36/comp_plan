This folder allows you to keep a library of data which can be looked up later. 
The Gui can automatically search this directory for any matching data.

The easiest way to set up the library folder is to simply copy all the text
files from a previously set up base directory into this directory.
Next time you use the code it will search this directory for available data.

It is a good idea to make sure that all structures in this folder have as generic
a name as possible - i.e. if you have a structure call 'bladder_kl_1' rename it
to 'bladder' in all files. 
This is because the code will check if this name exists WITHIN any new structures.
So if you check for data for a structure called 'bladder_kl_1' and the Library
has a structure called 'bladder' it should find it - however, the reverse is NOT
true.

Finally, note that this process is not infallible
1) always check the values for each metric before proceeding
2) make sure that the structure names for all library names match - otherwise
the code will crash