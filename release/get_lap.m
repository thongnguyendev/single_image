function A=get_lap(h, w)
  all_ids = reshape([1:h*w], [h w]);

  self_ids=all_ids;
  ind=ones(h,w);
  S_plus=sparse(self_ids(:), self_ids(:), 4*ind);

  negh_ids=circshift(all_ids, [0 -1]);
  ind2=ind; ind2(:,end)=0; %Ignore the last column
  S_minus_1=sparse(self_ids(:), negh_ids(:), ind2);

  negh_ids=circshift(all_ids, [0 1]);
  ind2=ind; ind2(:,1)=0; %Ignore the first column
  S_minus_2=sparse(self_ids(:), negh_ids(:), ind2);

  negh_ids=circshift(all_ids, [-1 0]);
  ind2=ind; ind2(end,:)=0; %Ignore the last row
  S_minus_3=sparse(self_ids(:), negh_ids(:), ind2);

  negh_ids=circshift(all_ids, [1 0]);
  ind2=ind; ind2(1,end)=0; %Ignore the first  row
  S_minus_4=sparse(self_ids(:), negh_ids(:), ind2);



  A=S_plus-S_minus_1 - S_minus_2 - S_minus_3 - S_minus_4;


