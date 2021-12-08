%% Here I'm creating a map of the three distinct regions of the Bellingshausen Sea which I am analysing. 


cd /Users/srishtidasarathy/Documents/'Documents - Srishti’s MacBook Pro '/Bowman/SouthernOcean_Causal_Analysis

%%
fig = figure(1);clf; 
% hold on
% m_proj('lambert','lon',[-100 -54],'lat',[-75 -60]); 
% hold on
m_proj('lambert','lon',[-100 -56],'lat',[-74 -60]);

% lat_Bsea = [-59.5*ones(1,48) -75.5*ones(1,48) -59.5 -75.5]; % Outline of a box
% lon_Bsea = [-100.5:-53.5 -53.5:-1:-100.5 -100.5 -100.5];

% m_line(lon_Bsea,lat_Bsea,'linewi',3,'color','magenta');     % Area outline ...

 lat_BSea = [-60*ones(1,21) -63*ones(1,21) -60 -63]; % Outline of a box
 lon_BSea = [-100:-80 -80:-1:-100 -100 -100];

 m_line(lon_BSea,lat_BSea,'linewi',2,'color','k');     % Area outline ...

 
 lat_BSea_chl = [-66*ones(1,21) -69*ones(1,21) -66 -69]; % Outline of a box
 lon_BSea_chl = [-87:-67 -67:-1:-87 -87 -87];

 m_line(lon_BSea_chl,lat_BSea_chl,'linewi',2,'color','k');     % Area outline ...

 lat_BSea_extra = [-73*ones(1,21) -70*ones(1,21) -70 -73]; % Outline of a box
 lon_BSea_extra = [-95:-75 -75:-1:-95 -95 -95];
 m_line(lon_BSea_extra,lat_BSea_extra,'linewi',2,'color','k');     % Area outline ...

m_gshhs_i('color','k');              % Coastline...

m_grid('fontsize', 20,...
    'xtick',8,...
    'tickdir','in',...
    'YaxisLocation', 'left',...
    'XaxisLocation', 'top',...
    'ylabeldir', 'end',...
    'linest','none', ...
    'gridcolor', 'black',...
    'linewidth', 1,...
    'ytick',5);%...
    %'yticklabels',[]);
%  m_coast('patch',[.7 .7 .7],'edgecolor','k');

title({'Spatial Subsets'; '\newline'}, 'FontSize',18);

m_text(-94,-61.5,'Region A','FontSize',25,'color','b','Rotation', 10,'fontweight','normal');
m_text(-81,-67.5,'Region B','FontSize',25,'color','b','fontweight','normal');
m_text(-90,-71.6,'Region C','FontSize',25,'color','b','Rotation', 7,'fontweight','normal');


