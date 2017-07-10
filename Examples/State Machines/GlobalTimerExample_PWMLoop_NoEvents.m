% Example state matrix: A global timer in "loop mode" blinks port2 LED in an infinite loop. 
% It is triggered in the first state. Next, the state machine goes into a state
% where it waits for two events:
% 1. Port1In momentarily enters a state that stops the global timer. Port 2 will stop blinking.
% 2. Exits the state machine.

sma = NewStateMachine;
sma = SetGlobalTimer(sma, 'TimerID', 1, 'Duration', 0.1, 'OnsetDelay', 1,...
                     'Channel', 'PWM1', 'PulseWidthByte', 255, 'PulseOffByte', 0,...
                     'Loop', 1, 'SendGlobalTimerEvents', 0, 'LoopInterval', 0.1); 
sma = SetGlobalTimer(sma, 'TimerID', 2, 'Duration', 0.2, 'OnsetDelay', 1,...
                     'Channel', 'PWM2', 'PulseWidthByte', 255, 'PulseOffByte', 0,...
                     'Loop', 1, 'SendGlobalTimerEvents', 0, 'LoopInterval', 0.2); 
sma = SetGlobalTimer(sma, 'TimerID', 3, 'Duration', 0.2, 'OnsetDelay', 1,...
                     'Channel', 'PWM3', 'PulseWidthByte', 255, 'PulseOffByte', 0,...
                     'Loop', 1, 'SendGlobalTimerEvents', 0, 'LoopInterval', 0.2); 
sma = AddState(sma, 'Name', 'TimerTrig1', ...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'WaitForPoke'},...
    'OutputActions', {'GlobalTimerTrig', 3});
sma = AddState(sma, 'Name', 'WaitForPoke', ...
    'Timer', 0,...
    'StateChangeConditions', {'Port1In', 'StopGlobalTimer', 'Port2In', 'exit'},...
    'OutputActions', {});
sma = AddState(sma, 'Name', 'StopGlobalTimer', ...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'WaitForPoke'},...
    'OutputActions', {'GlobalTimerCancel', 3});
