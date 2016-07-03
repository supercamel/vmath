#!/usr/bin/gjs

const Lang = imports.lang;
const vmath = imports.gi.vmath;


function test_cross_product()
{
    var v1 = vmath.Vector.three_d(1, 0, 0)
    var v2 = vmath.Vector.three_d(0, 1, 0)

    var v = vmath.Vector.three_d(0, 0, 1)
    var v3 = v1.cross(v2)
    if(v.compare(v3, 0.0001))
        return true;
    return false;
}

function test_sub_vector()
{
    var v = vmath.Vector.three_d(3, 2, 1)
    var d = v.sub_vector(2)

    var v2 = vmath.Vector.two_d(3, 2)

    if(v2.compare(d, 0.00001))
        return true;
    return false;
}

function test_scale_vector()
{
    var v = vmath.Vector.three_d(1, 2, 3)
    v.scale(5.0)

    var v2 = vmath.Vector.three_d(5, 10, 15)

    if(v2.compare(v, 0.001))
        return true;
    return false;
}

function run_tests()
{
    var test_name = "Vector\t\t\t\t"
    if(!test_cross_product())
    {
        print(test_name + "failed cross product")
        return;
    }

    if(!test_sub_vector())
    {
        print(test_name + "failed sub vector")
        return;
    }

    if(!test_scale_vector())
    {
        print(test_name + "failed scale vector")
        return;
    }
    print(test_name + "passed")
}

run_tests()
