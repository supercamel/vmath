#!/usr/bin/gjs

const Lang = imports.lang;
const vmath = imports.gi.vmath;


function print_vector(vec)
{
    var s = ""
    for(var i = 0; i < vec.get_dimensions(); i++)
        s += vec.dim(i) + " "
    print(s)
}

var vec = vmath.Vector.three_d(1, 0, 0)
var v2 = vmath.Vector.three_d(1, 0, 0)
