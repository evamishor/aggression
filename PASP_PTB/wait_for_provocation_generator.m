number_of_provocation_events_per_run = 16;
for i=1:number_of_provocation_events_per_run
    wait_for_provocation4(i) = rand+(State.monetary.deadline-State.revenge.deadline-2.5); %%% originaly: rand*(State.monetary.deadline-State.revenge.deadline-1.5)
end

for i=1:number_of_provocation_events_per_run
    wait_for_provocation3(i) = rand+(State.monetary.deadline-State.revenge.deadline-2.5);
end

for i=1:number_of_provocation_events_per_run
    wait_for_provocation2(i) = rand+(State.monetary.deadline-State.revenge.deadline-2.5);
end

for i=1:number_of_provocation_events_per_run
    wait_for_provocation1(i) = rand+(State.monetary.deadline-State.revenge.deadline-2.5);
end

save ('wait_for_provocation.mat','wait_for_provocation1','wait_for_provocation2','wait_for_provocation3','wait_for_provocation4');