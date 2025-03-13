% function plotAcquisition_3D(acqResults)
%     % 提取数据
%     dopplerFreq = acqResults.carrFreq;    % Doppler frequency
%     codePhase = acqResults.codePhase;     % Code phase
%     peakMetric = acqResults.peakMetric;   % Acquisition metric
% 
%     % 检查数据是否有效
%     if isempty(dopplerFreq) || isempty(codePhase) || isempty(peakMetric)
%         error('Acquisition results are empty or invalid.');
%     end
% 
%     % 构建网格
%     dopplerUnique = unique(dopplerFreq);   % 唯一的 Doppler 值
%     codePhaseUnique = unique(codePhase);  % 唯一的 Code phase 值
%     [dopplerGrid, codePhaseGrid] = meshgrid(dopplerUnique, codePhaseUnique);
% 
%     % 初始化 Acquisition metric 矩阵
%     acquisitionMetric = zeros(size(dopplerGrid));
% 
%     % 填充 Acquisition metric 矩阵
%     for i = 1:length(peakMetric)
%         % 找到对应的 Doppler 和 Code phase 索引
%         dopplerIdx = dopplerUnique == dopplerFreq(i);
%         codePhaseIdx = codePhaseUnique == codePhase(i);
% 
%         % 填充 Acquisition metric 值
%         acquisitionMetric(codePhaseIdx, dopplerIdx) = peakMetric(i);
%     end
% 
%     % 绘制 3D 图形
%     figure;
%     surf(dopplerGrid, codePhaseGrid, acquisitionMetric);
%     title('3D Acquisition Results');
%     xlabel('Doppler Frequency [Hz]');
%     ylabel('Code Phase [samples]');
%     zlabel('Acquisition Metric');
%     colormap('jet');      % 设置颜色映射
%     shading interp;       % 平滑显示
%     colorbar;             % 显示颜色条
% end

function plotAcquisition_3D(acqResults)
    % 提取数据
    dopplerFreq = acqResults.carrFreq;    % Doppler frequency
    codePhase = acqResults.codePhase;     % Code phase
    peakMetric = acqResults.peakMetric;   % Acquisition metric

    % 检查数据是否有效
    if isempty(dopplerFreq) || isempty(codePhase) || isempty(peakMetric)
        error('Acquisition results are empty or invalid.');
    end

    % 确定网格范围
    dopplerMin = min(dopplerFreq);
    dopplerMax = max(dopplerFreq);
    codePhaseMin = min(codePhase);
    codePhaseMax = max(codePhase);

    % 构建网格（确保网格均匀分布）
    dopplerUnique = linspace(dopplerMin, dopplerMax, 100);   % 100 个点
    codePhaseUnique = linspace(codePhaseMin, codePhaseMax, 100); % 100 个点
    [dopplerGrid, codePhaseGrid] = meshgrid(dopplerUnique, codePhaseUnique);

    % 初始化 Acquisition metric 矩阵
    acquisitionMetric = zeros(size(dopplerGrid));

    % 填充 Acquisition metric 矩阵
    for i = 1:length(peakMetric)
        % 找到最接近的网格点索引
        [~, dopplerIdx] = min(abs(dopplerUnique - dopplerFreq(i)));
        [~, codePhaseIdx] = min(abs(codePhaseUnique - codePhase(i)));

        % 填充 Acquisition metric 值
        acquisitionMetric(codePhaseIdx, dopplerIdx) = peakMetric(i);
    end

    % 绘制 3D 图形
    figure;
    surf(dopplerGrid, codePhaseGrid, acquisitionMetric);
    title('3D Acquisition Results');
    xlabel('Doppler Frequency [Hz]');
    ylabel('Code Phase [samples]');
    zlabel('Acquisition Metric');
    colormap('jet');      % 设置颜色映射
    shading interp;       % 平滑显示
    colorbar;             % 显示颜色条
end