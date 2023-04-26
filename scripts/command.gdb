set debuginfod enabled on
lay src
break r_data.cpp:473
r -file wads/DOOM.WAD

display {i,j}
display *mtexture
display *texture
display *mpatch
display *patch
n
