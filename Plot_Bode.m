%% Diagrama de bode
function Plot_Bode(TransferFunctionUnsprung,natural_freq)
    
    figure(2)
    
    opts = bodeoptions;
    opts.FreqUnits = 'Hz';
    opts.PhaseVisible = 'off';
    opts.MagUnits ='db';
    cutoff_frequency = bandwidth(TransferFunctionUnsprung)/(2*pi);
    bode(TransferFunctionUnsprung,opts,'m')

    title('System Bode Diagram');
    xlabel('Frequency');
    ylabel('Magnitude (dB)');
    
    grid;


    h = get(gcf,'Children');

    xline(h(3),cutoff_frequency,'black--');
    txt = 'Natural Frequency \rightarrow '; 
    text(1,-10,txt,'FontSize',10,'Parent',h(3))

    xline(h(3),natural_freq,'black--');
    txt = '\leftarrow Cutoff frequency '; 
    text(15,-40,txt,'FontSize',10,'Parent',h(3))
    
    % Propriedades da figura
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
    figure_property.Bounds= 'loose';
    figure_property.LockAxes= 'off';
    figure_property.LockAxesTicks= 'off';
    figure_property.ShowUI= 'off';
    figure_property.SeparateText= 'off';
    chosen_figure=gcf;
    set(chosen_figure,'PaperUnits','inches');
    set(chosen_figure,'PaperPositionMode','auto');
    set(chosen_figure,'PaperSize', ...
        [str2num(figure_property.Width) str2num(figure_property.Height)]);
    set(chosen_figure,'Units','inches');
    hgexport(gcf,'Bode.pdf',figure_property);
end 