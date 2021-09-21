function plotData(src,event)
    figure(1);
     plot(event.TimeStamps,event.Data,'-k');
     hold on;
     %size(event.Data)
end