set debuginfod enabled on
lay src
break r_data.cpp:473

display {i,j}
display *mtexture
display *texture
display *mpatch
display *patch
n
