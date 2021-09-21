% randomize subtraction

%                       ***********
%       DO NOT CHANGE IN THE MIDDLE OF A RUNNING EXPERIMENT!!!!!!
%                       ***********


number_of_trials = ceil(8*60/(State.monetary.deadline+4)); 
%max # of monetary rounds = 60, # of provocations for 2 runs = 20.

rng = num2str(28041986);%seed, for reproducability
provocation_vec1 = randperm(number_of_trials);%what is the numbe of events?
provocation_vec = provocation_vec1(1:14);
provocation_vec = sort(provocation_vec);
scatter(provocation_vec,repmat(5,[1 10]));xlim([0 35])

%DO NOT COMMENT OUT unless your name is eva
save ('provocation_vec1.mat','provocation_vec')

wait_for_provocation1 = wait_for_provocation1+1
wait_for_provocation2 = wait_for_provocation2-1
wait_for_provocation3 = wait_for_provocation3-1
wait_for_provocation4 = wait_for_provocation4-1
save ('wait_for_provocation.mat','wait_for_provocation1','wait_for_provocation2','wait_for_provocation3','wait_for_provocation4')