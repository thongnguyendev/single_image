function A=get_k(h, w, dx, dy, c)
  all_ids = reshape([1:h*w], [h w]);

  self_ids=all_ids;
  negh_ids=ncircshift(all_ids, [dy dx]);
  negh_ids2=circshift(all_ids, [dy dx]);
  ind=ones(h,w);
  indc=ones(h,w)*c;
  indc(negh_ids==0)=0;

  S_plus=sparse(self_ids(:), self_ids(:), ind);
  S_minus=sparse(self_ids(:), negh_ids2(:), indc);
  A=S_plus+S_minus;


