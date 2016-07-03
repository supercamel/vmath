using Math;
using Gee;

namespace vmath
{


public class Matrix : Object
{
    public Matrix(int rows, int cols)
    {
        max_x = cols;
        max_y = rows;
        cells = new Gee.ArrayList<double?>();
        for(int x = 0; x < rows; x++)
        {
            for(uint32 y = 0; y < cols; y++)
            {
                cells.add(0.0);
            }
        }
    }

    public Matrix.from_matrix(Matrix m)
    {
        max_x = m.max_x;
        max_y = m.max_y;
        cells = new Gee.ArrayList<double?>();
        foreach(double? v in m.cells)
            cells.add(v);
    }

    public void print()
    {
        for(int row = 0; row < max_y; row++)
        {
            for(int col = 0; col < max_x; col++)
                stdout.printf("%0.2f ", get_cell(row, col));
            stdout.printf("\n");
        }
    }

    public double get_cell(int row, int col)
    {
        if(row > max_x)
            return 0.0;
        if(col > max_y)
            return 0.0;

        return cells[row*max_x + col];
    }

    public void set_cell(int row, int col, double val)
    {
        if((row > max_x) || (col > max_y))
            return;

        cells[row*max_x + col] = val;
    }

    public Vector row_to_vector(int row)
    {
        var ret = new Vector();
        for(int i = 0; i < max_x; i++)
            ret.set_dimension(i, get_cell(row, i));
        return ret;
    }

    public Vector col_to_vector(int col)
    {
        var ret = new Vector();
        for(int i = 0; i < max_y; i++)
            ret.set_dimension(i, get_cell(i, col));
        return ret;
    }

    public void vector_to_row(Vector v, int row)
    {
        int mx = max_x;
        if(v.get_dimensions() < mx)
            mx = v.get_dimensions();

        for(int i = 0; i < mx; i++)
            set_cell(row, i, v.dim(i));
    }

    public void vector_to_col(Vector v, int col)
    {
        int my = max_y;
        if(v.get_dimensions() < my)
            my = v.get_dimensions();

        for(int i = 0; i < my; i++)
            set_cell(i, col, v.dim(i));
    }

    public Matrix multiply(Matrix m)
    {
        var ret = new Matrix(m.max_x, max_y);
        for(int x = 0; x < max_y; x++)
        {
            for(int y = 0; y < m.max_x; y++)
            {
                var row = row_to_vector(x);
                var col = m.col_to_vector(y);
                ret.set_cell(x, y, row.dot(col));
            }
        }
        return ret;
    }

    public Matrix transpose()
    {
        var ret = new Matrix(max_y, max_x);
        for(int x = 0; x < max_x; x++)
        {
            for(int y = 0; y < max_y; y++)
                ret.set_cell(y, x, get_cell(x, y));
        }
        return ret;
    }

    public Matrix minor_matrix(int row, int col)
    {
        int colCount = 0, rowCount = 0;
        if((max_x == 1) || (max_y == 1))
        {
            var ret = new Matrix(1, 1);
            return ret;
        }

        var ret = new Matrix(max_y-1, max_x-1);
        for(int i = 0; i < max_x; i++ )
        {
            if( i != row )
            {
                for(int j = 0; j < max_y; j++ )
                {
                    if( j != col )
                    {
                        ret.set_cell(rowCount, colCount, get_cell(i, j));
                        colCount++;
                    }
                }
                rowCount++;
            }
        }
        return ret;
    }

    public double determinant()
    {
        if((max_x == 1) || (max_y == 1))
            return get_cell(0, 0);
		else
		{
		    double det = 0.0;
		    for(int i = 0; i < max_x; i++ )
		    {
		        var minor = minor_matrix(0, i);
                double p = 1.0;
                if((i%2) == 1)
                    p = -1.0;
		        det += p * get_cell(0, i) * minor.determinant();
		    }
		    return det;
        }

        return 0.0;
    }

    public Matrix invert()
    {
        var ret = new Matrix(max_y, max_x);
        double det = determinant();

        for(int x = 0; x < max_x; x++)
        {
            for(int y = 0; y < max_y; y++)
            {
                var minor = minor_matrix(y, x);
                ret.set_cell(x, y, minor.determinant()/det);
                if((x+y)%2 == 1)
                    ret.set_cell(x, y, -ret.get_cell(x, y));
            }
        }
        return ret;
    }

    public void load_identity()
    {
        for(int x = 0; x < max_x; x++)
        {
            for(int y = 0; y < max_y; y++)
            {
                set_cell(x, y, 0.0);
            }
        }

        for(int i = 0; i < double.min(max_x, max_y); i++)
            set_cell(i, i, 1.0);
    }

    public Matrix lower_triangle()
    {
        var m = new Matrix.from_matrix(this);
        for(int x = 0; x < max_x; x++)
        {
            for(int y = x+1; y < max_y; y++)
                m.set_cell(x, y, 0);
        }
        return m;
    }

    Matrix upper_triangle()
    {
        var m = new Matrix.from_matrix(this);
        for(int x = 0; x < max_x; x++)
        {
            for(int y = max_x-x; y < max_y; y++)
                m.set_cell(x, max_y-y-1, 0);
        }
        return m;
    }

    public Matrix llt()
    {
        //LLT cholesky decomposition
        var A = new Matrix.from_matrix(this);
        var L = lower_triangle();
        for (int i = 0; i < max_x; i++)
        {
            for (int j = 0; j < (i+1); j++)
            {
                double s = 0;
                for (int k = 0; k < j; k++)
                    s += L.get_cell(i,k) * L.get_cell(j,k);

                double v = 0;
                if(i == j)
                    v = sqrt(A.get_cell(i,i)-s);
                else
                    v = (1.0 / L.get_cell(j,j) * (A.get_cell(i,j) - s));
                if(Math.isnan(v) != 0)
                    return L;
                L.set_cell(i,j,v);
            }
        }

        return L;
    }

    public bool compare(Matrix m, double precision=0.001)
    {
        if(cells.size != m.cells.size)
            return false;
        int count = 0;
        for(int i = 0; i < cells.size; i++)
        {
            if(fabs(cells[i]-m.cells[i]) > precision)
                return false;
        }
        return true;
    }

    private Gee.ArrayList<double?> cells;
    private int max_x;
    private int max_y;
}

}
