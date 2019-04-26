function report_all_adesanya(solution)
figure('Position',[100  0 900 800])
for i = 1:length(solution)
    subplot(2,2,i)
    report_C_adesanya(solution{i})
    subplot(2,2,i+2)
    report_cell_adesanya(solution{i})
end