function [time, echo] = olfactometer_web_command(command, IP)
%% Send a command to an olfactometer
%
% Sends a string to the olfactometer to be caught by the LabVIEW code
% running a web service.
%
% 'IP' should contain the IP address of the host computer INCLUDING the port
% number (e.g. 127.0.0.1:8001 for a local process). LabVIEW normally runs
% a "test server" on port 8001 or a "program server" on port 8080.
%
% 'time' is the time in seconds that it takes to revieve a command
%
% If the web service is changed, the http path
% should be changed accordingly.
%
% -Ethan 2016-06-02
t = tic;
if exist('webread', 'file')
    echo = webread(['http://', IP, '/Sniff-Webcommand/Web-Commands?Command=',command]);
else
    echo = urlread(['http://', IP, '/Sniff-Webcommand/Web-Commands?Command=',command]);
end
time = toc(t);
end