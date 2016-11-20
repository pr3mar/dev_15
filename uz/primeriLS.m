function primerLS()

% izberi metodo
% type = 'pseudoinverseDirect' ;  
% type = 'pseudoinverseSVD' ;  
% type = 'directAA' ; 
type = 'directA' ; 

% generiraj podatke
c = 0 ; d = 0 ; ep = 1  ;
a = [ 0 0; 1 1; 2 3 ; 3 2 ; 4 4  ]*ep ; 
% dt = 0.1 ; x = 0 :dt: 10 ; a = [x', x'+randn(size(x,2),1)*0.5]*ep ;
a(:,1) = a(:,1)+c ; a(:,2) = a(:,2)+d ;

figure(1) ; clf ;
plot(a(:,1),a(:,2),'.') ; 
axis equal ; axis tight ; ax = axis ;
axis( [ax(1)-1, ax(2)+1,ax(3)-1,ax(4)+1] ) ;
p11 = -1 ; p21 = 10 ;
p11 = p11*ep + c ; p21 = p21*ep + c ;
 
switch(type)
    case 'pseudoinverseDirect'
        A = [a(:,1), ones(size(a,1),1) ] ;
        b = a(:,2) ;
        
        At = inv(A'*A)*A' ; 
        
        x = At*b ;
        
        p12 = p11*x(1) + x(2) ;
        p22 = p21*x(1) + x(2) ;
        hold on ; plot([p11,p21],[p12,p22],'r') ;
 case 'pseudoinverseSVD'
        A = [a(:,1), ones(size(a,1),1) ] ;
        b = a(:,2) ;
 
        [U,S,V] = svd(A) ; 
        
        % mo?nost 1
        is = S ; is(1:2,1:2) = inv(is(1:2,1:2)) ;
        At = V*is'*U' ;
        
        % mo?nost 2
%         At = V*inv(S(1:2,1:2))*U(:,1:2)' ;
                
        x = At*b ;
        
        p12 = p11*x(1) + x(2) ;
        p22 = p21*x(1) + x(2) ;
        hold on ; plot([p11,p21],[p12,p22],'r') ;        
    case 'directAA'
        A = [a] ;
        s = mean(A) ;
        A = bsxfun(@minus, A, s) ;
        
        A2 = A'*A ;
        [U,S,V] = svd(A2) ;
         
        x = U(:,end) ;
        a = x(1) ; 
        b = x(2) ;
        d = s*[a,b]' ;
        
        p12 = -(p11*a - d)/b ;
        p22 = -(p21*a - d)/b  ;        
        
        hold on ; plot([p11,p21],[p12,p22],'r') ;
    case 'directA' 
        A = [a] ;
        s = mean(A) ;
        A = bsxfun(@minus, A, s) ;
   
        [U,S,V] = svd(A) ; 
        x = V(:,end) ;
         
        a = x(1) ; 
        b = x(2) ;
        d = s*[a,b]' ;
        
        p12 = -(p11*a - d)/b ;
        p22 = -(p21*a - d)/b  ; 
 
                
        hold on ; plot([p11,p21],[p12,p22],'r') ;        
end
title(['Metoda ', type]) ;
  
% axis equal ; axis tight
