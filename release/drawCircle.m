function I = drawCircle(h,w, x, y, r)
  I=zeros(h,w);
  for i = 1 : h
    for j = 1 : w
      if (i-y)^2+(j-x)^2<r*r
        I(i,j)=1;
      end
    end
  end
