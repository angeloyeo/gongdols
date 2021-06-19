clear; close all; clc;
% 공룡 게임: http://www.trex-game.skipser.com/
% 마우스 관련 참고: https://docs.oracle.com/javase/6/docs/api/java/awt/Robot.html
% 키보드 버튼 이름 참고: https://docs.oracle.com/javase/6/docs/api/java/awt/event/KeyEvent.html
% 스크린샷 참고: https://kr.mathworks.com/matlabcentral/fileexchange/31383-screenshotrgb-make-a-screenshot-using-robot-java-class

import java.awt.Robot;
import java.awt.event.*;
robot = Robot;

% Restart
robot.mouseMove(630, 450);
robot.mousePress(InputEvent.BUTTON1_MASK);
robot.mouseRelease(InputEvent.BUTTON1_MASK);
robot.keyPress(java.awt.event.KeyEvent.VK_SPACE)

while(1)
    % 공룡 앞에 점프해야 할 사물이 나타났는가?
    img1 = screenShotRGB(500,460,24,27);
    % 공룡 앞에 숙여야 할 사물이 나타났는가?
    img2 = screenShotRGB(550,430,24,27);
    
%     montage({img1, img2})
    %     temp = [temp sum(img(:))];
    if sum(img1(:)) < 4e5
        % spacebar 누르기
         robot.keyPress(java.awt.event.KeyEvent.VK_SPACE)
    elseif sum(img2(:)) < 4e5
        robot.keyPress(java.awt.event.KeyEvent.VK_DOWN)
        robot.keyRelease(java.awt.event.KeyEvent.VK_DOWN)
    end
    
end