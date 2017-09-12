

clear;clc;clf;         %清空以前数据
tic
global Distance;

cities = 200;       %城市数量
generations = 5000;  %进化代数
population = 400;   %种群数量
mutationrate = 0.2; %变异概率
crossrate = 1;    %杂交概率

%用于保存每一代的最优个体以及这个个体的路径总长度
BestSolutions = zeros(generations+1,cities+1);

%随机生成 n 个城市的位置矩阵
Distribution = TspCitiesInitial(cities);
plot(Distribution(:,1)', Distribution(:,2)', 'bo')
title('最优路径')
pause(1)
hold on

%计算距离矩阵
Distance = zeros(cities);
for i = 1:cities
    for j = 1:cities
        Distance(i,j) = norm(Distribution(i,:)-Distribution(j,:));
    end
end

%生成初始种群（population个旅行方案）
Solutions = zeros(population,cities);
for i = 1:population
    Solutions(i,:) = randperm(cities);
end
SolutionValue = TspTotalDist(Solutions);SolutionAndValue = [Solutions,SolutionValue];
x = 0;
y = 0;
p = plot(x,y,'-r*');
%=================种群进化过程====================%
h = waitbar(0,'Please wait...')
for g = 1:generations
    str = ['进化代数:' num2str(g)];
    waitbar(g/generations,h,str)
    for i = 1:population
        
        %变异操作
        if rand() <= mutationrate   %每个个体以mutationrate的概率变异
            NewOne = SolutionAndValue(i,1:cities);                      %初始化变异个体
            %随机选择个体中的某一段位置的基因插入到其他位置上
            RandLocation = randnorepeat(2,cities);
            
% %             tempvalue = NewOne(RandLocation(1));
% %             NewOne(RandLocation(1)) = NewOne(RandLocation(2));
% %             NewOne(RandLocation(2)) = tempvalue;
            
            SortLocation = sort(RandLocation);
            SegmentSelect = NewOne(SortLocation(1):SortLocation(2));    %选取的基因片段
            SegmentSelect = fliplr(SegmentSelect);
            for k = SortLocation(1):SortLocation(2)
                NewOne(k) = SegmentSelect(k-SortLocation(1)+1);
            end
% %             for k = 1:length(SegmentSelect)
% %                 NewOne(SortLocation(1)) = [];                           %剩余的基因片段
% %             end
% %             NewOne = [SegmentSelect NewOne];                            %基因重组的个体
            
            %变异后选择
            OldOneValue = SolutionAndValue(i,(1+cities));
            NewOneValue = TspTotalDist(NewOne);
            if OldOneValue > NewOneValue
                SolutionAndValue(i,:) = [NewOne,NewOneValue];
            end
        end
        SolutionsBak = SolutionAndValue;
        
        %杂交操作
         if rand() <= crossrate
            %选择杂交父本和母本
            FatherSolution = SolutionAndValue(i,:);
            MotherSolution = SolutionsBak(unidrnd(population),:);
            Father = FatherSolution(1:cities);
            Mother = MotherSolution(1:cities);
            %选取杂交点
            crosspoint = unidrnd(cities);
            if crosspoint == 1
                Kid = Mother;
            else
                %单点交叉产生子代
                KidHead = Father(1:(crosspoint-1));
                KidTail = Mother(crosspoint:cities);
                FatherTail = Father(crosspoint:cities);
                %修补子代
                for fixpoint = 1:(crosspoint-1)
                    while 1
                        location = find(KidTail==(KidHead(fixpoint)));
                        if isempty(location)
                            break;
                        else
                            KidHead(fixpoint) = FatherTail(location);
                        end
                    end
                end
                Kid = [KidHead,KidTail];
            end
            KidValue = TspTotalDist(Kid);
            if (FatherSolution(cities+1) > KidValue)
                SolutionAndValue(i,:) = [Kid,KidValue];
            end
         end
    end
    SolutionAndValue = sortrows(SolutionAndValue, cities+1);
    BestSolution = SolutionAndValue(1,:);
    BestPath = BestSolution(1:cities);
    
    PathOfCities = zeros(cities+1,2);
    for i=1:cities
        PathOfCities(i,:) = Distribution(BestPath(i),:);
    end
    PathOfCities(cities+1,:) = Distribution(BestPath(1),:);
    if mod(g, 2) == 0
        x = PathOfCities(:,1)';
        y = PathOfCities(:,2)';
        set(p,'XData',x,'YData',y)
        drawnow
    end
end
close(h);
Time = toc
    