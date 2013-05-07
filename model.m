%function[avggen] = modelV1(ampsize)

ampsize = 2;
maxtime = 10^5;

time = 1:maxtime;
%Env = ampsize.*(round(rand(length(time),1)).*2 - 1);
Env = ampsize.*(-1).^(round(time./10));
%Env = ampsize.*sin(time./1000);
popsize = 1000;
avggen = zeros(maxtime,1);
Hmean = zeros(maxtime,1);

Pop = zeros(popsize,3);
Pop(1,1) = 1; %isogenic initial pop
Pop(1,2) = 0; %center at mean
Pop(1,3) = 0.1;

mutrate = .05;
mutmag = [0.05, 0.05];
extinct = 0.001;
newstrain = 0.01;

for i = 1:maxtime
    
    %Population growth
    temp3 = find(Pop(:,1) ~=0);
    Pop(temp3,1) = Pop(temp3,1).*exp(normpdf(Env(i),Pop(temp3,2),Pop(temp3,3)));
    Pop(:,1) = Pop(:,1)./sum(Pop(:,1));
    
    %Calculate average stdev
    avggen(i) = sum(Pop(:,1).*Pop(:,3));

    %extinction
    Pop(Pop(:,1)<extinct) = 0;
        
    %Mutation
    if sum(Pop(:,1)~=0) < popsize
        if rand(1) < mutrate
            temp = find(Pop(:,1)>0);
            newmut = randperm(sum(Pop(:,1)>0));
            temp2 = find(Pop(:,1) == 0);
            Pop(temp2(1),1) = newstrain;
            Pop(temp2(1),2) = mutmag(1).*randn(1)+Pop(temp(newmut(1)),2);
            Pop(temp2(1),3) = abs(mutmag(2).*randn(1)+Pop(temp(newmut(1)),3));
        end
    end
%     
%     if rem(i,1000) == 0
%         figure(1)
%         bar(sort(Pop(:,1),'descend'))
%     end
end
