function snake_game
figure;
set(gcf,'color','w');

XLIMs = [-25,25];
YLIMs = [-25,25];

bodies = [1,0;0,0]; % initializing the location of the body
drt = 'rightarrow'; % initializing the direction of the heado of a snake
speed = 1; % speed of a snake. speed for a single frame.
mem_len = 2;
set(gcf,'KeyPressFcn',@fun_key_stroke); % command window에서 key 입력을 기다리지 않게...

while(1)
    %% dying condition
    if bodies(1,1)>XLIMs(2) || bodies(1,1)<XLIMs(1)
        break;
    elseif bodies(1,2)>YLIMs(2) || bodies(1,2)<YLIMs(1)
        break;
    end
    
    %% memorizing the past
    past_bodies = bodies(1:end-1,:);
    
    %% moving
    drt = get(gcf,'CurrentKey');
    
    if strcmp(drt,'rightarrow')
        bodies(1,1) = bodies(1,1)+1;
    elseif strcmp(drt,'leftarrow')
        bodies(1,1) = bodies(1,1)-1;
    elseif strcmp(drt,'uparrow')
        bodies(1,2) = bodies(1,2)+1;
    elseif strcmp(drt,'downarrow')
        bodies(1,2) = bodies(1,2)-1;
    else
        bodies(1,1) = bodies(1,1)+1;
    end
    
    % connecting the head to the bodies of past
    bodies(2:end,:)=past_bodies;
    
    %% plotting
    plot(bodies(:,1), bodies(:,2),'s','markerfacecolor','b','markersize',15);
    xlim(XLIMs);
    ylim(YLIMs);
    
    pause(0.1);
    cla
end

end

function fun_key_stroke(src,event)
end

