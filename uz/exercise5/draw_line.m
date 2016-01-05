function draw_line( l, w, h, color)
% l ... line (l = [a , b, c])
% w ... image width
% h ... image height
% color ... line color (e.g. col = 'g')

y1 = 0 ; y2 = h+1 ;
x1 = 0 ; x2 = w+1 ;
if l(2) < l(1)    
    x1 = (-l(3)-l(2)*y1)/l(1) ;
    x2 = (-l(3)-l(2)*y2)/l(1) ; 
else
    y1 = (-l(3)-l(1)*x1)/l(2) ;
    y2 = (-l(3)-l(1)*x2)/l(2) ;
end
% x1 = check_coord(x1, w);
% x2 = check_coord(x2, w);
% y1 = check_coord(y1, h);
% y2 = check_coord(y2, h);
% [x1, x2]
% [y1, y2]
plot([x1, x2], [y1, y2], color) ;
% a = l(1);
% b = l(2);
% c = l(3);
% x = [0, w];
% y = (c - a*x)/b;
% plot(x, y, color);