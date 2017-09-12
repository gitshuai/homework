

clear;clc;clf;         %�����ǰ����
tic
global Distance;

cities = 200;       %��������
generations = 5000;  %��������
population = 400;   %��Ⱥ����
mutationrate = 0.2; %�������
crossrate = 1;    %�ӽ�����

%���ڱ���ÿһ�������Ÿ����Լ���������·���ܳ���
BestSolutions = zeros(generations+1,cities+1);

%������� n �����е�λ�þ���
Distribution = TspCitiesInitial(cities);
plot(Distribution(:,1)', Distribution(:,2)', 'bo')
title('����·��')
pause(1)
hold on

%����������
Distance = zeros(cities);
for i = 1:cities
    for j = 1:cities
        Distance(i,j) = norm(Distribution(i,:)-Distribution(j,:));
    end
end

%���ɳ�ʼ��Ⱥ��population�����з�����
Solutions = zeros(population,cities);
for i = 1:population
    Solutions(i,:) = randperm(cities);
end
SolutionValue = TspTotalDist(Solutions);SolutionAndValue = [Solutions,SolutionValue];
x = 0;
y = 0;
p = plot(x,y,'-r*');
%=================��Ⱥ��������====================%
h = waitbar(0,'Please wait...')
for g = 1:generations
    str = ['��������:' num2str(g)];
    waitbar(g/generations,h,str)
    for i = 1:population
        
        %�������
        if rand() <= mutationrate   %ÿ��������mutationrate�ĸ��ʱ���
            NewOne = SolutionAndValue(i,1:cities);                      %��ʼ���������
            %���ѡ������е�ĳһ��λ�õĻ�����뵽����λ����
            RandLocation = randnorepeat(2,cities);
            
% %             tempvalue = NewOne(RandLocation(1));
% %             NewOne(RandLocation(1)) = NewOne(RandLocation(2));
% %             NewOne(RandLocation(2)) = tempvalue;
            
            SortLocation = sort(RandLocation);
            SegmentSelect = NewOne(SortLocation(1):SortLocation(2));    %ѡȡ�Ļ���Ƭ��
            SegmentSelect = fliplr(SegmentSelect);
            for k = SortLocation(1):SortLocation(2)
                NewOne(k) = SegmentSelect(k-SortLocation(1)+1);
            end
% %             for k = 1:length(SegmentSelect)
% %                 NewOne(SortLocation(1)) = [];                           %ʣ��Ļ���Ƭ��
% %             end
% %             NewOne = [SegmentSelect NewOne];                            %��������ĸ���
            
            %�����ѡ��
            OldOneValue = SolutionAndValue(i,(1+cities));
            NewOneValue = TspTotalDist(NewOne);
            if OldOneValue > NewOneValue
                SolutionAndValue(i,:) = [NewOne,NewOneValue];
            end
        end
        SolutionsBak = SolutionAndValue;
        
        %�ӽ�����
         if rand() <= crossrate
            %ѡ���ӽ�������ĸ��
            FatherSolution = SolutionAndValue(i,:);
            MotherSolution = SolutionsBak(unidrnd(population),:);
            Father = FatherSolution(1:cities);
            Mother = MotherSolution(1:cities);
            %ѡȡ�ӽ���
            crosspoint = unidrnd(cities);
            if crosspoint == 1
                Kid = Mother;
            else
                %���㽻������Ӵ�
                KidHead = Father(1:(crosspoint-1));
                KidTail = Mother(crosspoint:cities);
                FatherTail = Father(crosspoint:cities);
                %�޲��Ӵ�
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
    