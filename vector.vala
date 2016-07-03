/*
	Vala Ground Control Station
    Copyright (C) 2016 Samuel Cowen

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


using Math;
using Gee;

namespace vmath
{

public class Vector : Object
{
    public Vector()
    {
        d = new Gee.ArrayList<double?>();
    }

    public Vector.n_dimensions(int sz)
    {
        d = new Gee.ArrayList<double?>();
        for(int i = 0; i < sz; i++)
            d.add(0.0);
    }

    public Vector.two_d(double x, double y)
    {
        d = new Gee.ArrayList<double?>();
        d.add(x);
        d.add(y);
    }

    public Vector.three_d(double x, double y, double z)
    {
        d = new Gee.ArrayList<double?>();
        d.add(x);
        d.add(y);
        d.add(z);
    }

    public Vector.from_vector(Vector v)
    {
        d = new Gee.ArrayList<double?>();
        foreach(double? f in v.d)
            d.add(f);
    }

    public double dim(int n)
    {
        return d[n];
    }

    public int get_dimensions()
    {
        return d.size;
    }

    public Vector cross(Vector v)
    {
        if(d.size != 3)
            return new Vector.n_dimensions(0);
        if(d.size != 3)
            return new Vector.n_dimensions(0);

        var ret = new Vector.n_dimensions(3);

        ret.d[0] = (this.d[1] * v.d[2]) - (this.d[2] * v.d[1]);
        ret.d[1] = (this.d[2] * v.d[0]) - (this.d[0] * v.d[2]);
        ret.d[2] = (this.d[0] * v.d[1]) - (this.d[1] * v.d[0]);

        return ret;
    }

    public void scale(double scalar)
    {
        int count = 0;
        foreach (double? n in d)
            d[count++] = n*scalar;
    }

    public void add_vector(Vector v)
    {
        int min = int.min(this.d.size, v.d.size);

        for(int i = 0; i < min; i++)
            this.d[i] += v.d[i];
    }

    public double magnitude()
    {
        double t = 0.0;
        for(int i = 0; i < d.size; i++)
            t += d[i]*d[i];

        return sqrt(t);
    }

    public void subtract(Vector v)
    {
        for(int i = 0; i < int.min(this.d.size, v.d.size); i++)
            this.d[i] -= v.d[i];
    }

    public void from_polar(double mag, double angle)
    {
        while(this.d.size < 2)
            d.add(0);

        d[0] = mag*cos(angle);
        d[1] = mag*sin(angle);
    }

    public double theta()
    {
        if(this.d.size >= 2)
            return atan2(d[1], d[0]);
        return 0;
    }

    public void normalize()
    {
        double mag = magnitude();
        if(mag == 0)
            return;

        for(int i = 0; i < d.size; i++)
            d[i] /= mag;
    }

    public Vector normalized()
    {
        Vector v = new Vector.from_vector(this);
        v.normalize();
        return v;
    }

    public double dot(Vector v)
    {
        double ret = 0;
        for(int i = 0; i < int.min(this.d.size, v.d.size); i++)
            ret += d[i] * v.d[i];

        return ret;
    }

    public void invert()
    {
        for(int i = 0; i < d.size; i++)
        {
            double f = d[i];
            d[i] = -f;
        }
    }

    public Vector sub_vector(int n)
    {
        if(n > d.size)
            n = d.size;

        Vector v = new Vector();
        for(int i = 0; i < n; i++)
            v.d.add(d[i]);
        return v;
    }

    public bool compare(Vector v, double precision = 0.001)
    {
        if(v.d.size != d.size)
            return false;

        for(int i = 0; i < d.size; i++)
        {
            if(fabs(d[i]-v.d[i]) > precision)
                return false;
        }
        return true;
    }

    public void set_dimension(int dim, double val)
    {
        while(dim >= d.size)
            d.add(0);
        d[dim] = val;
    }

    public void to_degrees()
    {
        for(int i = 0; i < d.size; i++)
            d[i] *= (180.0/Math.PI);
    }

    public void to_radians()
    {
        for(int i = 0; i < d.size; i++)
            d[i] *= (Math.PI/180.0);
    }

    public double get_x()
    {
        return d[0];
    }

    public void set_x(double x)
    {
        d[0] = x;
    }

    public double get_y()
    {
        return d[1];
    }

    public void set_y(double y)
    {
        d[1] = y;
    }

    public double get_z()
    {
        return d[2];
    }

    public void set_z(double z)
    {
        d[2] = z;
    }

    public double squared_norm()
    {
        return dot(this);
    }

    public void print()
    {
        for(int i = 0; i < d.size; i++)
            stdout.printf("%0.2f ", d[i]);
        stdout.printf("\n");
    }

    private Gee.ArrayList<double?> d;
}

}
