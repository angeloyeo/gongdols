function blackjack(action)
% BLACKJACK.  Use random numbers in Monte Carlo simulation to play
% the game of Blackjack.
%
% In Blackjack, face cards count 10 points, aces count one or 11 points,
% all other cards count their face value.  The objective is to reach,
% but not exceed, 21 points.  If you go over 21, or "bust", before the
% dealer, you lose your bet on that hand.  If you have 21 on the first
% two cards, and the dealer does not, this is "blackjack" and is worth
% 1.5 times the bet.  If your first two cards are a pair, you may "split"
% the pair by doubling the bet and use the two cards to start two
% independent hands.  You may "double down" after seeing the first two
% cards by doubling the bet and receiving just one more card.
% "Hit" and "draw" mean take another card.  "Stand" means stop drawing.
% "Push" means the two hands have the same total.
%
% The first mathematical analysis of Blackjack was published in 1956
% by Baldwin, Cantey, Maisel and McDermott. Their basic strategy, which
% is also described in many more recent books, makes Blackjack very
% close to a fair game.  With basic strategy, the expected win or loss
% per hand is less than one percent of the bet.  The key idea is to
% avoid going bust before the dealer.  The dealer must play a fixed
% strategy, hitting on 16 or less and standing on 17 or more.  Since
% almost one-third of the cards are worth 10 points, you can compare
% your hand with the dealer's under the assumption that the dealer's
% hole card is a 10.  If the dealer's up card is a six or less, she
% must draw.  Consequently, the strategy has you stand on any total over
% 11 when the dealder is showing a six or less.  Split aces and split 8's.
% Do not split anything else.  Double down with 11, or with 10 if the
% dealer is showing a six or less.  The complete basic strategy is
% defined by three arrays, HARD, SOFT and SPLIT, in the code.
%
% A more elaborate strategy, called "card counting", can provide a
% definite mathematical advantage.  Card counting players keep track
% of the cards that have appeared in previous hands, and use that
% information to alter both the bet and the play as the deck becomes
% depleated.  Our simulation does not involve card counting.
%
% See also: blackjacksim.

% Cleve Moler
% MathWorks, Inc.
% Copyright 2012 The MathWorks, Inc.

   basebet = 10;
   if nargin == 0
      P1 = [];
      P2 = [];
      D = [];
      bet1 = 0;
      bet2 = 0;
      count = 0;
      total = 0;
      who = 1;
      buttons = initbuttons;
      setbuttons({'Double','Stand','Hit'})
      set(gcf,'userdata',{P1,P2,D,bet1,bet2,count,total,who,buttons})
      action = 'Deal';
   end
   
   userdata = get(gcf,'userdata');
   [P1,P2,D,bet1,bet2,count,total,who,buttons] = deal(userdata{:});
   switch action
      case 'Deal'
         setup;
      case 'Hit'
         hit
      case 'Stand'
         stand
      case 'Keep'
         keep
      case 'Double'
         double
      case 'Split'
         split
      case 'Close'
         close(gcf)
         return 
   end
   set(gcf,'userdata',{P1,P2,D,bet1,bet2,count,total,who,buttons})
  
   % ------------------------
     
   function c = card
      % Deal one card from a continuous shuffling machine
      c = ceil(52*rand);
   end
      
   % ------------------------

   function setup;
      delete(get(gca,'children'))
      bet1 = basebet;
      bet2 = 0;
      who = 1;
      P1 = card;         % Player's hand
      D = card;          % Dealer's hand
      P1 = [P1 card];
      D = [D -card];     % Hide dealer's hole card
      P2 = [];
      show(1,P1,false)
      show(3,D,false)
      if value(P1) == 21
         twentyone
      elseif mod(P1(1),13)==mod(P1(2),13);
         % Option to split pairs.
         setbuttons({'','Keep','Split'})
         strategy(P1,D,false)
      else
         setbuttons({'Double','Stand','Hit'})
         strategy(P1,D,false)
      end
      if total >= 0, sig = '+'; else, sig = '-'; end
      total_str = sprintf('%6.0f hands,  $ %c%d',count,sig,abs(total));
      text(-2.0,4.5,total_str,'tag','total','fontsize',20);
   end
   
   % ------------------------

   function hit
      if who == 1
         P1 = [P1 card];
         show(1,P1,false)
         if value(P1) >= 21
            stand
            return
         end
         if length(P1) > 2
            set(buttons(1),'enable','off')
         end
         strategy(P1,D,false)
      else
         P2 = [P2 card];
         show(2,P2,false)
         if value(P2) >= 21
            finish
            return
         end
         if length(P2) > 2
            set(buttons(1),'enable','off')
         end
         strategy(P2,D,false)
      end
   end

   % ------------------------

   function double
      if who == 1
         bet1 = 2*bet1;
         P1 = [P1 card];
         show(1,P1,~isempty(P2))
         if ~isempty(P2)
            P2 = [P2 card];
            show(2,P2,false)
            strategy(P2,D,false)
         end
         finish
         return
      else
         bet2 = 2*bet2;
         P2 = [P2 card];
         show(2,P2,false)
         finish
         return
      end
   end

   % ------------------------

   function split
      bet2 = bet1;
      P2 = P1(2);
      P1(2) = card;
      show(1,P1,false);
      show(2,P2,true);
      setbuttons({'Double','Stand','Hit'})
      if value(P1) >= 21
         stand
         return
      end
      strategy(P1,D,false)
   end

   % ------------------------

   function keep
      setbuttons({'Double','Stand','Hit'})
      strategy(P1,D,true)
   end

   % ------------------------

   function stand
      % Start to play second hand, if any
      if who == 1 && ~isempty(P2)
         who = 2;
         P2 = [P2 card];
         show(1,P1,true)
         show(2,P2,false)
         if value(P2) >= 21
            finish
            return
         end
         strategy(P2,D,false)
      else
         finish
         return
      end
   end

   % ------------------------
   
   function buttons = initbuttons
      clf
      shg
      rng('shuffle')
      axes('pos',[0 0 1 1])
      axis([-5 5 -5 5])
      axis off
      for k = 1:3
         buttons(k) = uicontrol('units','normal','style','pushbutton', ...
            'pos',[.23+.18*k .02 .16 .08],'fontweight','bold', ...
            'callback','blackjack(get(gco,''string''))');
      end
   end
   
   % ------------------------
     
   function setbuttons(B)
      % B is a cell array of strings.
      for k = 1:length(B)
         if isempty(B{k})
            set(buttons(k),'vis','off')
         else
            set(buttons(k),'string',B{k},'vis','on','enable','on', ...
               'foreground','black')
         end
      end
   end
   
   % ------------------------
     
   function strategy(P,D,kept)
      if length(P) == 2 && ~kept && mod(P(1),13) == mod(P(2),13)
         s = pair(value(P(1)),value(D(1)));
      elseif any(mod(P,13) == 1)
         s = soft(value(P)-11,value(D(1)));
      else
         s = hard(value(P),value(D(1)));
      end
      set(buttons,'foreground','black')
      k = mod(s+1,3)+1;
      set(buttons(k),'foreground','red')
   end

   % ------------------------
      
   function v = value(X)
      % Evaluate hand
      X = mod(X-1,13)+1;
      X = min(X,10);
      v = sum(X);
      % Promote soft ace
      if any(X==1) & v<=11
         v = v + 10;
      end
   end
      
   % ------------------------

   function twentyone
      if value(D) < 21
         pay1 = 1.5*bet1;
         result(1,P1,'BLACKJACK',pay1)
         update_total(pay1,0)
      else
         finish
         return
      end
   end
      
   % ------------------------
      
   function finish

      if who == 1 && ~isempty(P2)
         who = 2;
         return
      end

      if value(P1) <= 21 || (~isempty(P2) && value(P2) <= 21)
         % Play dealer's hand
         D(2) = -D(2);     % Reveal dealer's hole card
         while value(D) <= 16
            D = [D card];
         end
         show(3,D,false)
         result(3,D)
      end
      valD = value(D);
   
      pay1 = settle(1,P1,bet1,valD);

      if isempty(P2)
         pay2 = 0;
      else
         pay2 = settle(2,P2,bet2,valD);
      end

      update_total(pay1,pay2)
   end
      
   % ------------------------

   function result(w,P,str,pay)
      x = min(1.5*length(P)-4.5,2.6);
      y = 2.5*(2-w);
      if w == 3
         t = sprintf(' %2d',value(D));
      elseif pay > 0
         t = sprintf('%2d,  %s +%2d',value(P),str,pay);
      elseif pay < 0
         t = sprintf('%2d,  %s -%2d',value(P),str,-pay);
      else
         t = sprintf('%2d,  %s',value(P),str);
      end
      text(x,y,t,'fontsize',20)
   end
      
   % ------------------------
      
   function pay = settle(w,P,bet,valD)
      show(w,P,false)
      valP = value(P);
      if valP > 21
         pay = -bet;
         result(w,P,'BUST',pay)
      elseif valD > 21 || valP > valD
         pay = bet;
         result(w,P,'WIN',pay)
      elseif valD > valP
         pay = -bet;
         result(w,P,'LOSE',pay)
      else
         pay = 0;
         result(w,P,'PUSH',pay)
      end
   end
      
   % ------------------------

   function update_total(pay1,pay2)
      total = total + pay1 + pay2;
      count = count+1;
      if total >= 0, sig = '+'; else, sig = '-'; end
      if count == 1
         total_str = sprintf('%6.0f hand,  $ %c%d',count,sig,abs(total));
      else
         total_str = sprintf('%6.0f hands,  $ %c%d',count,sig,abs(total));
      end
      set(findobj('tag','total'),'string',total_str)
      setbuttons({'','Deal','Close'})
   end
      
   % ------------------------
      
   function show(who,H,gray)
      % Displays who = 1, 2 or 3.
      x = -4;
      y = 2.5*(2-who);
      for j = 1:length(H)
         pcard(x,y,H(j),gray)
         x = x + 1.5;
      end
      drawnow
   end
      
   % ------------------------
      
   function pcard(x,y,v,gray)
      % pcard(x,y,v) plots v-th card at position (x,y).
      z = exp((0:16)/16*pi/2*i)/16;
      edge = [z+1/2+7*i/8 i*z-1/2+7*i/8 -z-1/2-7*i/8 -i*z+1/2-7*i/8 9/16+7*i/8];
      pips = {'A','2','3','4','5','6','7','8','9','10','J','Q','K'};
      if v <= 0
         % Hole card
         patch(real(edge)+x,imag(edge)+y,[0 0 2/3])
      else
         fs = 20;
         s = ceil(v/13);
         v = mod(v-1,13)+1;
         x1 = x;
         if v==10, x1 = x1-.2; end
         if gray
            offwhite = [.6 .6 .6];
         else
            offwhite = [1 1 1];
         end
         patch(real(edge)+x,imag(edge)+y,offwhite)
         switch s
            case {1,4}, redblack = [0 0 0];
            case {2,3}, redblack = [2/3 0 0];
         end
         text(x1-.2,y,pips{v},'fontname','courier','fontsize',fs, ...
            'fontweight','bold','color',redblack)
         text(x,y+.025,char(166+s),'fontname','symbol','fontsize',fs, ...
            'color',redblack)
      end
   end
      
   % ------------------------
      
   function strat = hard(p,d)
      % Strategy for hands without aces.
      % strategy = hard(player's_total,dealer's_upcard)
      
      % 0 = stand
      % 1 = hit
      % 2 = double down
      
      persistent HARD
      if isempty(HARD)
         x = NaN; % Not possible
         % Dealer shows:
         %      2 3 4 5 6 7 8 9 T A
         HARD = [ ...
            1   x x x x x x x x x x
            2   1 1 1 1 1 1 1 1 1 1
            3   1 1 1 1 1 1 1 1 1 1
            4   1 1 1 1 1 1 1 1 1 1
            5   1 1 1 1 1 1 1 1 1 1
            6   1 1 1 1 1 1 1 1 1 1
            7   1 1 1 1 1 1 1 1 1 1
            8   1 1 1 1 1 1 1 1 1 1
            9   2 2 2 2 2 1 1 1 1 1
           10   2 2 2 2 2 2 2 2 1 1
           11   2 2 2 2 2 2 2 2 2 2
           12   1 1 0 0 0 1 1 1 1 1
           13   0 0 0 0 0 1 1 1 1 1
           14   0 0 0 0 0 1 1 1 1 1
           15   0 0 0 0 0 1 1 1 1 1
           16   0 0 0 0 0 1 1 1 1 1
           17   0 0 0 0 0 0 0 0 0 0
           18   0 0 0 0 0 0 0 0 0 0
           19   0 0 0 0 0 0 0 0 0 0
           20   0 0 0 0 0 0 0 0 0 0];
      end
      strat = HARD(p,d);
   end
      
   % ------------------------
      
   function strat = soft(p,d)
      % Strategy array for hands with aces.
      % strategy = soft(player's_total-11,dealer's_upcard)
      
      % 0 = stand
      % 1 = hit
      % 2 = double down
      
      persistent SOFT
      if isempty(SOFT)
         % Dealer shows:
         %      2 3 4 5 6 7 8 9 T A
         SOFT = [ ...
            1   1 1 1 1 1 1 1 1 1 1
            2   1 1 2 2 2 1 1 1 1 1
            3   1 1 2 2 2 1 1 1 1 1
            4   1 1 2 2 2 1 1 1 1 1
            5   1 1 2 2 2 1 1 1 1 1
            6   2 2 2 2 2 1 1 1 1 1
            7   0 2 2 2 2 0 0 1 1 0
            8   0 0 0 0 0 0 0 0 0 0
            9   0 0 0 0 0 0 0 0 0 0];
      end
      strat = SOFT(p,d);
   end
      
   % ------------------------
      
   function strat = pair(p,d)
      % Strategy for splitting pairs
      % strategy = pair(paired_card,dealer's_upcard)
      
      % 0 = keep pair
      % 1 = split pair
      
      persistent PAIR
      if isempty(PAIR)
         x = NaN; % Not possible
         % Dealer shows:
         %      2 3 4 5 6 7 8 9 T A
         PAIR = [ ...
            1   x x x x x x x x x x
            2   1 1 1 1 1 1 0 0 0 0
            3   1 1 1 1 1 1 0 0 0 0
            4   0 0 0 1 0 0 0 0 0 0
            5   0 0 0 0 0 0 0 0 0 0
            6   1 1 1 1 1 1 0 0 0 0
            7   1 1 1 1 1 1 1 0 0 0
            8   1 1 1 1 1 1 1 1 1 1
            9   1 1 1 1 1 0 1 1 0 0
           10   0 0 0 0 0 0 0 0 0 0
           11   1 1 1 1 1 1 1 1 1 1];
      end
      strat = PAIR(p,d);
   end
end  % blackjack
