import matplotlib.pyplot as plt
from matplotlib.widgets import Slider, Button

def draw(points):
    x = []
    y = []
    res = 30
    for I in range(0, res):
        i = I/res
        a = points[0][0]*(i*i-2*i+1)+points[1][0]*(-2*i*i+2*i)+points[2][0]*(i*i)
        b = points[0][1]*(i*i-2*i+1)+points[1][1]*(-2*i*i+2*i)+points[2][1]*(i*i)
        x.append(a)
        y.append(b)
    return (x, y)


def main():
    points = [ [1,1], [2,1], [3,2] ]
    (x, y) = draw(points)

    l, = plt.plot(x,y)
    xx = plt.axes(plt.axes([0.25, 0.15, 0.65, 0.03]))
    yy = plt.axes(plt.axes([0.25, 0.1, 0.65, 0.03]))

    x1 = Slider(xx, 'x1', 0.0, 4.0, 2.0, valstep=0.1)
    y1 = Slider(yy, 'y1', 0.0, 4.0, 1.0, valstep=0.1)

    x1.on_changed(update)
    y1.on_changed(update)


    plt.scatter(points[0][0], points[0][1])
    plt.scatter(points[1][0], points[1][1])
    plt.scatter(points[2][0], points[2][1])
    plt.show()

def update(val):
    mx1 = x1.val
    my1 = y1.val
    points = [ [1,1], [mx1,my1], [3,2] ]
    (x, y) = draw(points)
    
    l.set_data(x, y)

if __name__ == "__main__":
    main()
