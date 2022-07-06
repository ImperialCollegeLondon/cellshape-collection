function [data]=fill_holes3D(data)
       
data_f=regionprops(data,'FilledImage','BoundingBox');
   
    for i=1:length(data_f)
       
    
        x=ceil(data_f(i).BoundingBox(1)); 
    
        y=ceil(data_f(i).BoundingBox(2));
    
        z=ceil(data_f(i).BoundingBox(3));
    
        xl=data_f(i).BoundingBox(4);
    
        yl=data_f(i).BoundingBox(5);
    
        zl=data_f(i).BoundingBox(6);
 
        data(y:y+yl-1,x:x+xl-1,z:z+zl-1)= or(data(y:y+yl-1,x:x+xl-1,z:z+zl-1),data_f(i).FilledImage);
    
    end


end

