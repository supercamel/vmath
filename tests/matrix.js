#!/usr/bin/gjs

const Lang = imports.lang;
const vmath = imports.gi.vmath;


function test_triangles()
{
    var m = vmath.Matrix.new(3, 3)
    m.vector_to_row(vmath.Vector.three_d(1,2,3), 0)
    m.vector_to_row(vmath.Vector.three_d(4,5,6), 1)
    m.vector_to_row(vmath.Vector.three_d(7,8,9), 2)

    var lt = m.lower_triangle()

    m.vector_to_row(vmath.Vector.three_d(1,0,0), 0)
    m.vector_to_row(vmath.Vector.three_d(4,5,0), 1)
    m.vector_to_row(vmath.Vector.three_d(7,8,9), 2)

    if(!m.compare(lt, 0.001))
        return false;

    return true;
}

function test_determinant()
{
    var m = vmath.Matrix.new(2, 2)
    m.vector_to_row(vmath.Vector.two_d(3, 8), 0)
    m.vector_to_row(vmath.Vector.two_d(4, 6), 1)

    if(Math.abs(m.determinant()+14) > 0.001)
        return false;
    return true;
}

function test_invert()
{
    var m = vmath.Matrix.new(2, 2)
    m.vector_to_row(vmath.Vector.two_d(4, 7), 0)
    m.vector_to_row(vmath.Vector.two_d(2, 6), 1)

    var inv_m = m.invert()

    m.vector_to_row(vmath.Vector.two_d(0.6, -0.7), 0)
    m.vector_to_row(vmath.Vector.two_d(-0.2, 0.4), 1)

    if(!m.compare(inv_m, 0.001))
        return false;
    return true;
}

function test_identity()
{
    var m = vmath.Matrix.new(3,3)
    m.load_identity()

    var i = vmath.Matrix.new(3,3)
    i.set_cell(0, 0, 1)
    i.set_cell(1, 1, 1)
    i.set_cell(2, 2, 1)

    if(!m.compare(i, 0.001))
        return false;
    return true;
}

function run_tests()
{
    var test_name = "Matrix\t\t\t\t"
    if(!test_triangles())
    {
        print(test_name + "failed triangles")
        return;
    }
    if(!test_determinant())
    {
        print(test_name + "failed determinant")
        return;
    }
    if(!test_invert())
    {
        print(test_name + "failed invert")
        return;
    }
    if(!test_identity())
    {
        print(test_name + "failed identity")
        return;
    }

    print(test_name + "passed")
}

run_tests()
