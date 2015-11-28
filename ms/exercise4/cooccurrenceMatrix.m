function [C, In] = cooccurrenceMatrix(I,d,max_val)

% get number of levels for the coocurance matrix
if nargin < 3
    max_val = max(I(:)) ;  
end
nlevels = max_val + 1 ;

% generate a larger matrix
I_lr = fliplr(I) ;
I_ud = flipud(I) ;
I_lrud = flipud(I_lr) ;
In = [I_lrud, I_ud, I_lrud; I_lr, I, I_lr; I_lrud, I_ud, I_lrud ] ;

% calculate the size
h = size(I,1) ;
w = size(I,2) ;

% extract the shifted 
x_s = (w+1:2*w) + d(1);
y_s = (h+1:2*h) + d(2);
Is = In(y_s, x_s) ;

% calculate the coocurance matrix
C = zeros(nlevels,nlevels) ;
for val_vert = 1 : size(C,1)
    for val_hor = 1 : size(C,2)
        num_occ = sum(((I(:) == (val_vert-1)) .* (Is(:) == (val_hor-1)))) ;
        C(val_vert, val_hor) = num_occ ;        
    end
end
C = C / sum(C(:)) ;

if nargout < 2
    In = [] ;
end
