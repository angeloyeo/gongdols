function S = blackjacksim(n)
%BLACKJACKSIM  Simulate blackjack.
% S = blackjacksim(n)
% Play n hands of blackjack. 
% Returns an n-by-1 vector of cumulative stake.
% See also: blackjack.
      
   S = cumsum(arrayfun(@blackjack_hand,zeros(n,1)));

end
   
% ------------------------
   
function s = blackjack_hand(varargin)
   %BLACKJACK_HAND  Play one hand of blackjack.
   %   s = blackjack_hand returns payoff from one hand.
   
   bet = 10;
   bet1 = bet;
   P = deal;         % Player's hand
   D = deal;         % Dealer's hand
   P = [P deal];
   D = [D -deal];    % Hide dealer's hole card
      
   % Split pairs
   split = (P(1) == P(2));
   if split 
      split = pair(value(P(1)),value(D(1)));
   end
   if split
      P2 = P(2);
      P = [P(1) deal];
      bet2 = bet1;
   end
      
   % Play player's hand(s)
   [P,bet1] = playhand('',P,D,bet1);
   if split
      P2 = [P2 deal];
      [P2,bet2] = playhand('',P2,D,bet2);
   end
      
   % Play dealer's hand
   D(2) = -D(2);     % Reveal dealer's hole card
   while value(D) <= 16
      D = [D deal];
   end
      
   % Payoff
   s = payoff(P,D,split,bet1);
   if split
      s = s + payoff(P2,D,split,bet2);
   end
end
   
% ------------------------
   
function c = deal
   % Simulate continuous shuffling machine with infinite deck.
   % c = deal returns a random integer between 1 and 13.
   c = ceil(13*rand);
end
   
% ------------------------
   
function v = valuehard(X)
   % Evaluate hand
   X = min(X,10);
   v = sum(X);
end
   
% ------------------------
   
function v = value(X)
   % Evaluate hand
   X = min(X,10);
   v = sum(X);
   % Promote soft ace
   if any(X==1) & v<=11
      v = v + 10;
   end
end
   
% ------------------------
   
function [P,bet] = playhand(hand,P,D,bet)
   % Play player's hand
   
   while value(P) < 21
      % 0 = stand
      % 1 = hit
      % 2 = double down
      if any(P==1) & valuehard(P)<=10
         strat = soft(value(P)-11,value(D(1)));
      else
         strat = hard(value(P),value(D(1)));
      end
      if length(P) > 2 & strat == 2
         strat = 1;
      end
      switch strat
          case 0
             break
          case 1
             P = [P deal];
          case 2
             % Double down.
             % Double bet and get one more card
             bet = 2*bet;
             P = [P deal];
             break
          otherwise
             break
      end
   end
end
   
% ------------------------
   
function s = payoff(P,D,split,bet)
   % Payoff
   fs = 20;
   valP = value(P);
   valD = value(D);
   if valP == 21 & length(P) == 2 & ...
      ~(valD == 21 & length(D) == 2) & ~split
      s = 1.5*bet;
   elseif valP > 21
      s = -bet;
   elseif valD > 21
      s = bet;
      str = ['WIN: +' int2str(s)];
   elseif valD > valP
      s = -bet;
   elseif valD < valP
      s = bet;
   else
      s = 0;
   end
end
   
% ------------------------
   
function strat = hard(p,d)
   % Strategy for hands without aces.
   % strategy = hard(player's_total,dealer's_upcard)
   
   % 0 = stand
   % 1 = hit
   % 2 = double down
   
   n = NaN; % Not possible
   % Dealer shows:
   %      2 3 4 5 6 7 8 9 T A
   HARD = [ ...
      1   n n n n n n n n n n
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
   strat = HARD(p,d);
end
   
% ------------------------
   
function strat = soft(p,d)
   % Strategy array for hands with aces.
   % strategy = soft(player's_total,dealer's_upcard)
   
   % 0 = stand
   % 1 = hit
   % 2 = double down
   
   n = NaN; % Not possible
   % Dealer shows:
   %      2 3 4 5 6 7 8 9 T A
   SOFT = [ ...
      1   n n n n n n n n n n
      2   1 1 2 2 2 1 1 1 1 1
      3   1 1 2 2 2 1 1 1 1 1
      4   1 1 2 2 2 1 1 1 1 1
      5   1 1 2 2 2 1 1 1 1 1
      6   2 2 2 2 2 1 1 1 1 1
      7   0 2 2 2 2 0 0 1 1 0
      8   0 0 0 0 0 0 0 0 0 0
      9   0 0 0 0 0 0 0 0 0 0];
   strat = SOFT(p,d);
end
   
% ------------------------
   
function strat = pair(p,d)
   % Strategy for splitting pairs
   % strategy = pair(paired_card,dealer's_upcard)
   
   % 0 = keep pair
   % 1 = split pair
   
   n = NaN; % Not possible
   % Dealer shows:
   %      2 3 4 5 6 7 8 9 T A
   PAIR = [ ...
      1   n n n n n n n n n n
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
   strat = PAIR(p,d);
end
