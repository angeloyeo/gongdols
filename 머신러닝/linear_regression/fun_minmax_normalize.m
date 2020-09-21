function [new_x, minx, maxx] = fun_minmax_normalize(x)

minx = min(x);
maxx = max(x);

new_x = (x - minx) / (maxx - minx);
