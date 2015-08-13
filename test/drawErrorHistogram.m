function  drawErrorHistogram( error, name,outputPath, fileName)


if( strcmp( fileName, 'double'))
    range = -11 : 1 : -4;
else
    range = -13 :1: -7;
end
HH = figure(1);
set(HH, 'Position', [   516   287   835   763]);

edges = ( 10.^range ); 

h=histc(error, edges );
bar(  edges  , h/sum(h), 'histc' );
set(gca, 'XScale', 'log')

hh = findobj(gca,'Type','line');
set(hh, 'Marker', 'none');
set(gcf,'color','w');
% title( [name, ' error'] );
% ylabel([name, ' error']);
set(gca,'fontsize', 25);

xlabel(['log_{10} of error in ', name],'FontWeight','bold');
ylabel('Frequency','FontWeight','bold');
xlim([edges(1),edges(end)]);
if(~strcmp(fileName, 'double'))
    ylim([0,0.66]);
else
    ylim([0,0.55]);
end

 a=[cellstr(num2str(get(gca,'ytick')'*100))]; 
pct = char(ones(size(a,1),1)*'%'); 
new_yticks = [char(a),pct];
set(gca,'yticklabel',new_yticks,'FontWeight','bold') ;

set(gca,'XTick',edges(2:2:end-1));

% set(gcf, 'Renderer', 'opengl')
% export_fig( fullfile(outputPath, [fileName, '_' , name, '.eps']), '-a4');
export_fig( fullfile(outputPath, [fileName, '_' , name, '.png']), '-r900');
% print( fullfile(outputPath, [fileName, '_' , name]), '-dpng', '-r900');