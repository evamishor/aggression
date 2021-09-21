function [records_out] = WriteRecoeds(experimentStart,sessionTime,run_num, amount, state)
%WRITERECOEDS Summary of this function goes here
%   Detailed explanation goes here

record1 = sessionTime-experimentStart; %start of session
record2 = amount; %current amount
record3 = state; %current state
record4 = run_num; %which run

records_out = {record1, record2, record3, record4, NaN};
end

