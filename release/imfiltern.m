function out=imfiltern(I, k)
  out=imfilter(I, k(end:-1:1, end:-1:1));
  %out=imfilter(I, k(end:-1:1, end:-1:1), 'replicate');
