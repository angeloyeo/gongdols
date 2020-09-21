function new_x = fun_restore_minmax_normalization(x, minx, maxx)

new_x = (maxx - minx) * x + minx;
