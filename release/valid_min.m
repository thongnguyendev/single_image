
function out = valid_min(I, padding)
  Is  = I(padding+1:end-padding-1, padding+1:end-padding);
  out = min(Is(:));
