% emotionalCuing.m
%
%        $Id$
%      usage: emotionalCuing
%         by: cassie joynes, lanie bachmann, tina liu 
%       date: 04/01/2022
%    purpose: behavioral experiment to investigate emotional engagement & disengangement  
%             https://www.sr-research.com/visual-angle-calculator/


% addpath(genpath('~/proj/mrTools'))
% addpath(genpath('~/proj/cnapStim'))
% addpath(genpath('~/Desktop/mgl_Cassie'))

function myscreen = emotionalCuing(varargin) 

% check arguments
if ~any(nargin == [0 1 2])
  help taskTemplate
  return
end

if nargin > 0, getArgs(varargin, [], 'verbose=0'); end 
if ieNotDefined('eyeTracking'), eyeTracking = 0;end
if ieNotDefined('displayName'), displayName = 'Laptop';end

% initalize the screen
myscreen.background = [106 106 106];
myscreen.keyboard.nums = [127 126]; % 127 = up 
myscreen.displayName = displayName;
myscreen = initScreen(myscreen);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run the eye calibration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if eyeTracking == 1, 
    displayNumber = mglGetParam('displayNumber');
    if displayNumber == 2
        myscreen = eyeCalibDisp(myscreen); 
    else
        disp('UHOH: MGL thinks there is not a second screen open');
        mglClose();
        return;        
    end
end


% define task parameters
task{1}.waitForBacktick = 1; 
% task{1}.waitForBacktick = 0;
% timing is in seconds 
task{1}.segmin = [.6 .22 nan .06 1]; %[.9 .25 nan .1 1.9]
task{1}.segmax = [.9 .22 nan .06 1]; %[1.2 .25 nan .1 1.9]
% task{1}.segmin = [.2 .25 nan .1 .2];
% task{1}.segmax =  [.2 .25 nan .1 .2];
task{1}.segquant = [.1 0 0 0 0];
task{1}.segdur{3} = [0.03 0.05]
task{1}.getResponse = [0 0 0 1 1];
task{1}.numBlocks = 10; % 6 trials per "block" so each run will have 60 trials 
task{1}.randVars.calculated.correctness = nan; 

% each set of parameters is shown once per block 
task{1}.parameter.gender = [1 2]; % 1 = male
task{1}.parameter.emotion = [3 4 5]; % 3 = happy 4 = angry 5 = neutral
% index this array using gender and emotion as defined on each trial to get the name of the vector to use 
task{1}.strings = {'AM', 'AF', 'HAS', 'ANS', 'NES'}; 

% uniform random vars are randomly selected each trial
task{1}.randVars.uniform.dotX = [11 -11]; %[3.54 -3.54];[6.47 -6.47] 
task{1}.randVars.uniform.dotY = [0.6 -0.6]; %[0.8, -0.8]; %[1.11, -1.11]
% block random are blocked independently of the main expt
% so every 10 trials will contain 4 invalid and 6 valid 
task{1}.randVars.block.isValid = [zeros(1, 4), ones(1, 6)]; 
% calculated rand var
task{1}.parameter.facePos = 6.47; 
task{1}.randVars.calculated.faceX = nan; 
task{1}.randVars.calculated.whichFace = nan; 

task{1}.random = 1;

% initialize the task
for phaseNum = 1:length(task)
  [task{phaseNum} myscreen] = initTask(task{phaseNum},myscreen,@startSegmentCallback,@screenUpdateCallback,@responseCallback);
end

% init the stimulus
global stimulus;
myscreen = initStimulus('stimulus',myscreen);
stimulus.faceSeg = 2; 
stimulus.dotSeg = 4; 
if ~isfield(stimulus, 'AFHAS')
    stimulus = initShuffle(stimulus);
    disp('initializing face vectors')
else
    disp('continuing previous shuffle')
    disp(stimulus.AFNES.counter)
end
stimulus.AFHAS.faces = {};
stimulus.AFNES.faces = {};
stimulus.AFANS.faces = {};
stimulus.AMHAS.faces = {};
stimulus.AMNES.faces = {};
stimulus.AMANS.faces = {};
stimulus = myInitStimulus(stimulus,myscreen);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main display loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phaseNum = 1;
while (phaseNum <= length(task)) && ~myscreen.userHitEsc
  % update the task
  [task myscreen phaseNum] = updateTask(task,myscreen,phaseNum);
  % flip screen
  myscreen = tickScreen(myscreen,task);
end

% if we got here, we are at the end of the experiment
myscreen = endTask(myscreen,task);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function that gets called at the start of each segment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [task myscreen] = startSegmentCallback(task, myscreen)

global stimulus;
if (task.thistrial.thisseg == 1 )
    % Where should the face be?
    if task.thistrial.isValid
        disp('valid')
        if task.thistrial.dotX > 0
            task.thistrial.faceX = task.thistrial.facePos; % positive value
        elseif task.thistrial.dotX < 0
            task.thistrial.faceX = -1 * task.thistrial.facePos;
        end
    else
        disp('invalid')
        if task.thistrial.dotX > 0
            task.thistrial.faceX = -1 * task.thistrial.facePos; % positive value
        elseif task.thistrial.dotX < 0
            task.thistrial.faceX = task.thistrial.facePos;
        end
    end
    % display correctness 
    score = 0;
    if task.trialnum > 1 && isfield('task','correctness') % would ideally be nice to use isfield. But for some reason matlab is being annoying  
        temp = ~isnan(task{1}.correctness);
        for i = 1:length(task{1}.correctness)
            if temp(i)
                score = score + task{1}.correctness(i);
            end
        end
        disp(sprintf('Percent correct %0.2f', score/(task.trialnum-1)))
        disp(sprintf('--------------------------'))
    end
elseif (task.thistrial.thisseg == stimulus.faceSeg + 1)
    % update the counter and check to see if we're at the end of the vector
    whichVector = strcat(task.strings{task.thistrial.gender}, task.strings{task.thistrial.emotion}); 
    eval(sprintf('stimulus.%s.counter = stimulus.%s.counter + 1;', whichVector, whichVector));
    if eval(sprintf('stimulus.%s.counter > 96', whichVector))
        eval(sprintf('stimulus.%s.faceID = [randperm(32) randperm(32) randperm(32)];', whichVector)) 
        eval(sprintf('stimulus.%s.counter = 1;', whichVector))  
    end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function that gets called to draw the stimulus each frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [task myscreen] = screenUpdateCallback(task, myscreen)

global stimulus
mglClearScreen;
mglFixationCross(1, 1, [1 1 1]); %white fixation up the whole time 
if (task.thistrial.thisseg == stimulus.faceSeg)
    % draw face 
    whichVector = strcat(task.strings{task.thistrial.gender}, task.strings{task.thistrial.emotion}); 
    whichIndex = eval(sprintf('stimulus.%s.faceID(stimulus.%s.counter)', whichVector, whichVector));
    task.thistrial.whichFace = whichIndex; 
    eval(sprintf('mglBltTexture(stimulus.%s.faces{%i}, [task.thistrial.faceX 0 3.6 5.2], 0, 0, 180);', whichVector, whichIndex));
elseif task.thistrial.thisseg == stimulus.dotSeg
   mglFillOval(task.thistrial.dotX, task.thistrial.dotY, [.3 .3], [1 1 1]);
end 




%%%%%%%%%%%%%%%%%%%%%%%%%%
%    responseCallback    %
%%%%%%%%%%%%%%%%%%%%%%%%%%
function [task myscreen] = responseCallback(task,myscreen)

global stimulus
if task.thistrial.gotResponse < 1
    if (task.thistrial.whichButton == 1 & task.thistrial.dotY > 0) | (task.thistrial.whichButton == 2 & task.thistrial.dotY < 0)
        disp('correct')
        task.correctness(task.trialnum) = 1;
    elseif (task.thistrial.whichButton == 1 & task.thistrial.dotY < 0) | (task.thistrial.whichButton == 2 & task.thistrial.dotY > 0) 
        disp ('incorrect')
        task.correctness(task.trialnum) = 0;
    end
    % disp(sprintf('Subject response: %i Reaction time: %0.2fs',task.thistrial.whichButton,task.thistrial.reactionTime));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to init the stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function stimulus = myInitStimulus(stimulus,myscreen)
s = dir('/Users/bachmannhp/Box/MTurk_proposal/Spatial Cueing/SpatialCue Bitmaps/images_resized1.25/*.png');
for iDir = 1:size(s, 1)
    im = imread(fullfile(s(iDir).folder,s(iDir).name));
    if strfind(s(iDir).name, 'AM')
        if strfind(s(iDir).name, 'HAS')
            stimulus.AMHAS.faces{end+1} = mglCreateTexture(double(im));
        elseif strfind(s(iDir).name, 'ANS')
            stimulus.AMANS.faces{end+1} = mglCreateTexture(double(im));
        elseif strfind(s(iDir).name, 'NES')
            stimulus.AMNES.faces{end+1} = mglCreateTexture(double(im));
        end
    elseif strfind(s(iDir).name, 'AF')
        if strfind(s(iDir).name, 'HAS')
            stimulus.AFHAS.faces{end+1} = mglCreateTexture(double(im));
        elseif strfind(s(iDir).name, 'ANS')
            stimulus.AFANS.faces{end+1} = mglCreateTexture(double(im));
        elseif strfind(s(iDir).name, 'NES')
            stimulus.AFNES.faces{end+1} = mglCreateTexture(double(im));
        end
    end
end

function stimulus = initShuffle(stimulus) 
for iShuffle = 1:6
    tempPerm = [randperm(32) randperm(32) randperm(32)]; 
    switch iShuffle 
        case 1
            stimulus.AMHAS.counter = 1; 
            stimulus.AMHAS.faceID = tempPerm; 
        case 2 
            stimulus.AMANS.counter = 1; 
            stimulus.AMANS.faceID = tempPerm;
        case 3 
            stimulus.AMNES.counter = 1; 
            stimulus.AMNES.faceID = tempPerm; 
        case 4
            stimulus.AFHAS.counter = 1; 
            stimulus.AFHAS.faceID = tempPerm; 
        case 5 
            stimulus.AFANS.counter = 1; 
            stimulus.AFANS.faceID = tempPerm;
        case 6 
            stimulus.AFNES.counter = 1; 
            stimulus.AFNES.faceID = tempPerm; 
    end 
end 
 
% function stimulus = continueShuffle(stimulus, myscreen)
% keyboard

% for fun :) 
% for i = 1:10:360
% mglClearScreen; mglBltTexture(stimulus.AMHAS{7}, [-3.54 0 3.6 5.2], 0, 0, i); mglFixationCross(1, 1, [0 0 0]); mglFlush;
% pause(.1)
% end
