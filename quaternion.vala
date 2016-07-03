
using Math;

namespace vmath
{

public class Quaternion
{
    public Quaternion()
    {
        w = 1;
        x = 0;
        y = 0;
        z = 0;
    }

    public Quaternion.from_doubles(double ww, double xx, double yy, double zz)
    {
        w = ww; x = xx; y = yy; z = zz;
    }

    public Vector to_vector()
    {
        var ret = new Vector.n_dimensions(4);
        ret.set_dimension(0, w);
        ret.set_dimension(1, x);
        ret.set_dimension(2, y);
        ret.set_dimension(3, z);
        return ret;
    }

    public void normalize()
    {
        double mag = magnitude();
        if(mag == 0)
            return;
        w /= mag;
        x /= mag;
        y /= mag;
        z /= mag;
    }

    public Quaternion get_conjugate()
    {
        return new Quaternion.from_doubles(w, -x, -y, -z);
    }

    public void conjugate()
    {
        x = -x;
        y = -y;
        z = -z;
    }

    public double magnitude()
    {
        double r = w*w + x*x + y*y + z*z;
        return sqrt(r);
    }

    public Vector rotate_vector(Vector v)
    {
        var qv = new Vector.three_d(x, y, z);
        var t = qv.cross(v);
        t.scale(2.0);

        var st = new Vector.three_d(t.get_x(), t.get_y(), t.get_z());
        st.scale(w);

        v.add_vector(st);
        v.add_vector(qv.cross(t));

        return v;
    }


    public Quaternion multiply(Quaternion q)
    {
        var ret = new Quaternion();
        ret.w = ((w*q.w) - (x*q.x) - (y*q.y) - (z*q.z));
        ret.x = ((w*q.x) + (x*q.w) + (y*q.z) - (z*q.y));
        ret.y = ((w*q.y) - (x*q.z) + (y*q.w) + (z*q.x));
        ret.z = ((w*q.z) + (x*q.y) - (y*q.x) + (z*q.w));
        return ret;
    }

    public void from_euler(Vector euler)
    {
        var h = new Quaternion();
        var p = new Quaternion();
        var r = new Quaternion();

        var v = new Vector.three_d(0.0, 0.0, 1.0);
        h.from_axis_angle(v, euler.get_x());

        v = new Vector.three_d(0.0, 1.0, 0.0);
        p.from_axis_angle(v, euler.get_y());

        v = new Vector.three_d(1.0, 0.0, 0.0);
        r.from_axis_angle(v, euler.get_z());

        var end = new Quaternion();
        end = h.multiply(p);
        end = end.multiply(r);

        w = end.w;
        x = end.x;
        y = end.y;
        z = end.z;
    }

    public void from_axis_angle(Vector axis, double theta)
    {
        w = cos(theta/2.0);
        double sht = sin(theta/2.0);
        x = axis.get_x() * sht;
        y = axis.get_y() * sht;
        z = axis.get_z() * sht;
    }

    public void to_axis_angle(out Vector axis, out double angle)
    {
        normalize();

        axis = new Vector.three_d(0, 0, 0);
        angle = 0;

        //if w is 1, then this is a singularity (axis angle is zero)
        if(fabs(w-1.0) > 0.0001)
            return;

        double sqw = sqrt(1.0-(w*w));

        if(sqw == 0)
            return;

        angle = 2 * acos(w);
        axis.set_x(x / sqw);
        axis.set_y(y / sqw);
        axis.set_z(z / sqw);
    }

    public double w;
    public double x;
    public double y;
    public double z;
}

}
