%计算旅行方案的总距离
function d = TspTotalDist(solution)
global Distance;
[row,col] = size(solution);
d = zeros(row, 1);
for i = 1:row
    x = 0;
    for j = 1:(col-1)
        x = x+Distance(solution(i,j),solution(i,j+1));
    end
    x = x+Distance(solution(i,1),solution(i,col));
    d(i) = x;
end