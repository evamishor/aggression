clear

%%% Auto Generated User
meanUserResponseTime = .7;
respTimeUser = meanUserResponseTime * rand(1, 25);
respTimeUser(randperm(25, 2)) = 1.6;
%%%%%%%%
TOTAL_TRIALS = 25;

counterRatio = @(soundsSoFar, trialsSoFar)( (10 - soundsSoFar) / (25 - trialsSoFar));
userTookSoLong = @(userRespTime)(userRespTime > 1.5);
mustGive10Shocks = @(soundsSoFar, trialsSoFar)((10 - soundsSoFar) > (TOTAL_TRIALS - trialsSoFar));

respTimesComputer = zeros(1, 25);
successes = zeros(1, 25);

step = .7*meanUserResponseTime / 24;
timeFactor = [1.5*meanUserResponseTime: -step :.8*meanUserResponseTime]
counter = 0;


%Simulate Game
for ii = 1:25
    [(.5 / counterRatio(counter, ii - 1)) counterRatio(counter, ii - 1) ]
    respTimeComputer = ( (.5 / counterRatio(counter, ii - 1)) * timeFactor(ii))  * rand();
    if respTimeComputer < 0, respTimeComputer = 3; end;
    respTimesComputer(ii) = respTimeComputer;
    
    
    if respTimeComputer < respTimeUser(ii) || userTookSoLong(respTimeUser(ii)) || mustGive10Shocks(counter, ii - 1)
        counter = counter + 1;
        successes(ii) = 1;
    end    
end

figure, bar(2 * successes); hold on; plot(respTimesComputer, 'linewidth', 2); plot(respTimeUser, 'linewidth', 2)
title(sprintf('Sounds counter = %d', sum(successes)))