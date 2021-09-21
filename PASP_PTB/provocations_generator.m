% randomize subtraction

%                       ***********
%       DO NOT CHANGE IN THE MIDDLE OF A RUNNING EXPERIMENT!!!!!!
%                       ***********


number_of_trials = ceil(8*60/(State.monetary.deadline+waitTime)); 
%max # of monetary rounds = 60, # of provocations for 2 runs = 20.

rng = num2str(28041986);%seed, for reproducability
provocation_vec_temp = randperm(number_of_trials);%what is the numbe of events?
provocation_vec = provocation_vec_temp(1:16);
provocation_vec = sort(provocation_vec);

scatter(provocation_vec,repmat(5,[1 16]));xlim([0 number_of_trials])

%DO NOT COMMENT OUT unless your name is eva
% save ('provocation_vec1.mat','provocation_vec')
% save ('provocation_vec2.mat','provocation_vec')
% save ('provocation_vec3.mat','provocation_vec')
% save ('provocation_vec4.mat','provocation_vec')
% save ('provocation_vec_trial.mat','provocation_vec')