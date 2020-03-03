function fun_plot_discrete_hist(data,varargin)
% bar형태가 아닌 원형태의 histogram을 그려주는 함수

params = inputParser;
params.CaseSensitive = false;
params.addParameter('mksize', 10);
params.addParameter('mkfcolor', [0.8, 0.8, 0.8]);
params.parse(varargin{:});
%Extract values from the inputParser
mksize = params.Results.mksize;
mkfcolor = params.Results.mkfcolor;

k_data = unique(data);

for i_data = 1:length(k_data)
    idx = data == k_data(i_data);
    find_idx = find(idx);
    for j_data = 1:length(find_idx)
       plot(k_data(i_data), j_data ,'o','markersize',mksize,'markeredgecolor','k','markerfacecolor',mkfcolor);
       hold on;
    end
end