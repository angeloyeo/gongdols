function neg_base_exponent(base)
%
%
%
global C
disp(C)
figure;
set(gcf,'position',[350 400 850 350])
subplot(1,2,1);
set(gcf,'windowButtonMotionFcn',@fun_mouseMove)
line([-3 3],[0 0],'color','k','linewidth',3)

subplot(1,2,2);
y = base.^C(1,1);
plot(real(y), imag(y));
end



function fun_mouseMove (object, eventdata)
global C

C = get(gca, 'CurrentPoint');
title(gca, ['(X,Y) = (', num2str(C(1,1)), ', ',num2str(C(1,2)), ')']);
end
