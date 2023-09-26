%% Resposta transitória no tempo 
function Plot_transitorio(resp,t,v)
    info = lsiminfo(resp,t);
    figure(3);
    plot(t,resp,'m');
    hold on;    
    plot([info.TransientTime info.TransientTime], ylim, 'black--');
    ylim([-300 250])
    title(append('Time Transient Response - ', ...
        num2str(round(v,3)),' $\frac{m}{s}$'), ...
        'interpreter','latex');
    xlabel("Time [s]")
    ylabel('Aceleration [ $\frac{m}{s^2}$ ]','Interpreter', ...
        'latex','FontSize',14,'FontWeight','bold')
    %txt = 'Transient Time \rightarrow '; 
    %text(0.18,150,txt,'FontSize',10)
    txt = num2str(info.TransientTime);
    text(0.11,-230,txt,'FontSize',10)
    line([0.01 0.26],[-250 -250], 'Color', 'black', ...
        'LineStyle', '--');
    txt = '\leftarrow '; 
    text(0,-250,txt,'FontSize',10)
    txt = '\rightarrow '; 
    text(0.26,-250,txt,'FontSize',10)
    txt = 'Measurement Window (Transient Time) '; 
    text(0.05,-260,txt,'FontSize',10)

    hold off;
    grid on; 
    
    %Propriedades da figura
    clear figure_property;
    figure_property.units = 'inches';
    figure_property.format = 'pdf';
    figure_property.Preview= 'none';
    figure_property.Width= '8';
    figure_property.Height= '11';
    figure_property.Units= 'inches';
    figure_property.Color= 'rgb';
    figure_property.Background= 'w';
    figure_property.FixedfontSize= '12';
    figure_property.ScaledfontSize= 'auto';
    figure_property.FontMode= 'scaled';
    figure_property.FontSizeMin= '12';
    figure_property.FixedLineWidth= '1';
    figure_property.ScaledLineWidth= 'auto';
    figure_property.LineMode= 'none';
    figure_property.LineWidthMin= '0.1';
    figure_property.FontName= 'Times New Roman';
    figure_property.FontWeight= 'auto';
    figure_property.FontAngle= 'auto';
    figure_property.FontEncoding= 'latin1';
    figure_property.PSLevel= '3';
    figure_property.Renderer= 'painters';
    figure_property.Resolution= '600';
    figure_property.LineStyleMap= 'none';
    figure_property.ApplyStyle= '0';
    figure_property.Bounds= 'tight';
    figure_property.LockAxes= 'off';
    figure_property.LockAxesTicks= 'off';
    figure_property.ShowUI= 'off';
    figure_property.SeparateText= 'off';
    chosen_figure=gcf;
    set(chosen_figure,'PaperUnits','inches');
    set(chosen_figure,'PaperPositionMode','auto');
    set(chosen_figure,'PaperSize',[str2double(figure_property.Width) ...
        str2double(figure_property.Height)]); 
    set(chosen_figure,'Units','inches');
    hgexport(gcf,append('resposta_tempo_',num2str(round(3.6*v)),'.pdf'), ...
        figure_property);
end