s = createInputSession('both');
lh = addlistener(s,'DataAvailable', @plotData); %create listener
s.IsContinuous = true;
s.Rate=100;
s.startBackground(); % start acquiring, will call plotData when it gets data.
%% stop

 s.stop
 s.release