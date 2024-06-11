function plotPrices_sol(row)
    
    S = load('Ex04_House.mat');
    Yrs = 1997:2012;
    figure
    plot(Yrs, S.pricesToWages{row, :}, 'LineWidth', 2, 'Marker', '*')
    xlabel('Year')
    ylabel('House Price to Median Earnings Ratio')
    title(sprintf('Data for %s', ...
        S.pricesToWages.Properties.RowNames{row}), 'FontWeight', 'Bold')
    grid
    
end