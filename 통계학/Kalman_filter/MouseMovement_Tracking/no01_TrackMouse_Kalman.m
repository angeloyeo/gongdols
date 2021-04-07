clear; close all; clc;
%{
Kalman filter를 이용한 Mouse Position Tracking

2021년 4월 7일 여동훈
%}


%% DEFINITION
global C

%%
figure;
set(gcf,'WindowButtonMotionFcn', @mouseMove);
history_C = [];
history_C_pred = [];

while(1)
    history_C = [history_C, [C(1,1); C(1,2)]];
    plot(history_C(1,:), history_C(2,:),'color',[0, 0.447, 0.741]); hold on;
    plot(C(1,1), C(1,2), 'o','markerfacecolor','g','markeredgecolor','k');
    
    [C_pred(1,1), C_pred(1,2)] = TrackKalman(C(1,1), C(1,2));
    history_C_pred = [history_C_pred, [C_pred(1,1); C_pred(1,2)]];
    
    plot(history_C_pred(1,:), history_C_pred(2,:),'color',[0.85, 0.325, 0.098]); hold on;
    plot(C_pred(1,1), C_pred(1,2), 'o','markerfacecolor','r','markeredgecolor','k');
    
    xlim([0, 1])
    ylim([0, 1])
    pause(0.001);
    
    % history가 너무 길어지면 화면이 지저분해지므로 shift 해줄 것.
    if size(history_C, 2) > 500
        history_C = history_C(:, end-499:end);
    end
    
    if size(history_C_pred, 2) > 500
        history_C_pred = history_C_pred(:, end-499:end);
    end
    
    cla;
end

function mouseMove (object, eventdata)
global C
C = get(gca, 'CurrentPoint');
end

function [xh, yh] = TrackKalman(xm, ym)
%
%
persistent A H Q R
persistent x P
persistent firstRun


if isempty(firstRun)
  dt = 1;
  
  A = [ 1  dt  0   0
        0  1   0   0
        0  0   1  dt
        0  0   0   1 ];
  
  H = [ 1  0  0  0
        0  0  1  0 ];
 
  Q = 0.0001*eye(4); % 작아질 수록 예측값이 true 값을 천천히 따라감.
  R = 200 * eye(2);

  x = [0, 0, 0, 0]';
  P = 100*eye(4);
  
  firstRun = 1;
end


xp = A*x;
Pp = A*P*A' + Q;

K = Pp*H'*inv(H*Pp*H' + R);

z = [xm ym]';
x = xp + K*(z - H*xp);
P = Pp - K*H*Pp;


xh = x(1);
yh = x(3);
end