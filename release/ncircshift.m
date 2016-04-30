function Ip=ncircshift(Ip, s)
% circshift but fill zero instead of circulating 
  Ip=padarray(Ip, abs(s));
  Ip=circshift(Ip,s);
  Ip=Ip(abs(s(1))+1:end-abs(s(1)), abs(s(2))+1:end-abs(s(2)),:);

