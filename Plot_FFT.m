%% FFt 
function Plot_FFT(resp,t,ds,v)
    y = fft(resp);
    z = fftshift(2*y/length(t));
    Fs = 1/ds;
    ly = length(y);
    f = (-ly/2:ly/2-1)/ly*Fs;
    figure(1);
    stem(f,abs(z),'m')
    str = "Frequency Spectrum - Transient Response ";
    title(append(str,num2str(round(v,3)),' $\frac{m}{s}$'), ...
        'interpreter','latex')
    xlabel("Frequency - [Hz]")
    xlim([0,100])
    ylabel('Aceleration [ $\frac{m}{s^2}$ ]','Interpreter', ...
        'latex','FontSize',14,'FontWeight','bold')
    %r  = rectangle('Position',[0 0 10 60],'EdgeColor','r','LineWidth',3);
    txt = '\leftarrow';
    ht = text(50,10,txt,'FontSize',11);
    set(ht,'Rotation',90)
    txt = 'f_{max}';
    text(50,15,txt,'FontSize',10);

    grid on;
    
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
    figure_property.Bounds= 'tight';
    figure_property.LockAxes= 'off';
    figure_property.LockAxesTicks= 'off';
    figure_property.ShowUI= 'off';
    figure_property.SeparateText= 'off';
    chosen_figure=gcf;
    set(chosen_figure,'PaperUnits','inches');
    set(chosen_figure,'PaperPositionMode','auto');
    set(chosen_figure,'PaperSize',[str2num(figure_property.Width) ...
        str2num(figure_property.Height)]); 
    set(chosen_figure,'Units','inches');
    hgexport(gcf,append(num2str(round(3.6*v)),'km.pdf'),figure_property);
end