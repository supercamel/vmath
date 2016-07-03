
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

    public Vector to_euler()
    {
        var ret = Vector.three_d(0, 0, 0);
        double sqw = w*w;
        double sqx = x*x;
        double sqy = y*y;
        double sqz = z*z;

        ret.set_x(atan2((2.0*(_x*_y+_z*_w)),(sqx-sqy-sqz+sqw)));
        ret.set_y(asin((-2.0*(_x*_z-_y*_w))/(sqx+sqy+sqz+sqw)));
        ret.set_z(atan2((2.0*(_y*_z+_x*_w)),(-sqx-sqy+sqz+sqw)));

        return ret;
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

    public void from_matrix(Matrix m)
    {
        if((m.n_rows() != 3) || (m.n_cols() != 3))
            return;

        w = sqrt(double.max( 0, 1 + m.get_cell(0,0) + m.get_cell(1,1) + m.get_cell(2,2))) / 2.0f;
        x = sqrt(double.max( 0, 1 + m.get_cell(0,0) - m.get_cell(1,1) - m.get_cell(2,2))) / 2.0f;
        y = sqrt(double.max( 0, 1 - m.get_cell(0,0) + m.get_cell(1,1) - m.get_cell(2,2))) / 2.0f;
        z = sqrt(double.max( 0, 1 - m.get_cell(0,0) - m.get_cell(1,1) + m.get_cell(2,2))) / 2.0f;
        x = copysign_zero(x, m.get_cell(2,1) - m.get_cell(1,2));
        y = copysign_zero(y, m.get_cell(0,2) - m.get_cell(2,0));
        z = copysign_zero(z, m.get_cell(1,0) - m.get_cell(0,1));
    }

    private double copysign_zero(double x, double y)
    {
        double precision = 0.00001;
        if((y < precision) && (y > -precision))
            return 0;
        return copysign(x, y);
    }

    public Matrix to_matrix()
    {
        var ret = new Matrix(3, 3);
        ret.set_cell(0, 0, 1-(2*(_y*_y))-(2*(_z*_z)));
        ret.set_cell(0, 1, (2*_x*_y)-(2*_w*_z));
        ret.set_cell(0, 2, (2*_x*_z)+(2*_w*_y));

        ret.set_cell(1, 0, (2*_x*_y)+(2*_w*_z));
        ret.set_cell(1, 1, 1-(2*(_x*_x))-(2*(_z*_z)));
        ret.set_cell(1, 2, (2*(_y*_z))-(2*(_w*_x)));

        ret.set_cell(2, 0, (2*(_x*_z))-(2*_w*_y));
        ret.set_cell(2, 1, (2*_y*_z)+(2*_w*_x));
        ret.set_cell(2, 2, 1-(2*(_x*_x))-(2*(_y*_y)));
        return ret;
    }

    public void from_angular_velocity(Vector w, double dt)
    {
        double theta = w.magnitude() * dt;
        w.normalize();

        from_axis_angle(w, theta);
    }

    public Vector to_angular_velocity(double dt)
    {
        var ret = Vector.three_d(0, 0, 0);
        if(dt == 0)
            return ret;

        double angle = 0;
        to_axis_angle(out ret, out angle);

        ret.scale(angle); //finds angular displacement
        ret.scale(1.0/dt); //over dt to find angular velocity

        return ret;
    }

    Quaternion slerp(Quaternion b, float pc) const
    {
        var qm = new Quaternion();

        real_t cosHalfTheta = w * b.w + x * b.x + y * b.y + z * b.z;
        if (cosHalfTheta < 0)
        {
            b.w = -b.w;
            b.x = -b.x;
            b.y = -b.y;
            b.z = -b.z;
            cosHalfTheta = -cosHalfTheta;
        }

        if(fabs(cosHalfTheta) >= 1.0)
        {
            qm = *this;
            return qm;
        }

        double halfTheta = acos(cosHalfTheta);
        double sinHalfTheta = sqrt(1.0 - cosHalfTheta*cosHalfTheta);

        if(fabs(sinHalfTheta) < 0.001)
        {
            qm.w = (w * 0.5 + b.w * 0.5);
            qm.x = (x * 0.5 + b.x * 0.5);
            qm.y = (y * 0.5 + b.y * 0.5);
            qm.z = (z * 0.5 + b.z * 0.5);
            return qm;
        }

        double ratioA = sin((1 - pc) * halfTheta) / sinHalfTheta;
        double ratioB = sin(pc * halfTheta) / sinHalfTheta;

        qm.w = (w * ratioA + b.w * ratioB);
        qm.x = (x * ratioA + b.x * ratioB);
        qm.y = (y * ratioA + b.y * ratioB);
        qm.z = (z * ratioA + b.z * ratioB);
        return qm;
    }


    public double w;
    public double x;
    public double y;
    public double z;
}

}
