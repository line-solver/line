model = Network('model');

node{1} = DelayStation(model, 'Delay');
%node{1} = QueueingStation(model, 'Queue0', SchedStrategy.PS);
node{2} = QueueingStation(model, 'Queue1', SchedStrategy.PS);
node{3} = QueueingStation(model, 'Queue2', SchedStrategy.FCFS);
node{3}.setNumServers(3);

% Default: scheduling is set as FCFS everywhere, routing as Random
jobclass{1} = ClosedClass(model, 'Class1', 2, node{1}, 0);
jobclass{2} = ClosedClass(model, 'Class2', 1, node{1}, 0);
jobclass{3} = ClosedClass(model, 'Class3', 1, node{1}, 0);
jobclass{4} = ClosedClass(model, 'Class4', 1, node{1}, 0);

model.addLink(node{1}, node{1});
model.addLink(node{1}, node{2});
model.addLink(node{1}, node{3});
model.addLink(node{2}, node{1});
model.addLink(node{2}, node{2});
model.addLink(node{3}, node{1});

node{1}.setService(jobclass{1}, Exp(1));
node{1}.setService(jobclass{2}, Exp(1));
node{1}.setService(jobclass{3}, Exp(1));
node{1}.setService(jobclass{4}, Exp(1));

node{2}.setService(jobclass{1}, Exp(1));
node{2}.setService(jobclass{2}, Exp(1));
node{2}.setService(jobclass{3}, Exp(1));
node{2}.setService(jobclass{4}, Exp(1));

node{3}.setService(jobclass{1}, Exp(1));
node{3}.setService(jobclass{2}, Erlang(1,2));
node{3}.setService(jobclass{3}, Exp(1));
node{3}.setService(jobclass{4}, Exp(1));

M = model.getNumberOfStations();
K = model.getNumberOfClasses();

myP = cell(K,K);
myP{1,1} = [0,0.5,0;
    1,0,0;
    1,0,0];
myP{1,2} = [0,0.5,0;
    0,0,0;
    0,0,0];
myP{2,2} = [0,0,0;
    1,0,0;
    1,0,0];
myP{2,1} = [0,1,0;
    0,0,0;
    0,0,0];
myP{1,3} = zeros(3);
myP{2,3} = zeros(3);
myP{1,4} = zeros(3);
myP{2,4} = zeros(3);

myP{3,3} = [0,0.25,0.25;
    1,0,0;
    1,0,0];
myP{3,4} = [0,0.5,0;
    0,0,0;
    0,0,0];
myP{4,4} = [0,0,0;
    1,0,0;
    1,0,0];
myP{4,3} = [0,1,0;
    0,0,0;
    0,0,0];
myP{3,1} = zeros(3);
myP{4,1} = zeros(3);
myP{3,2} = zeros(3);
myP{4,2} = zeros(3);

model.linkNetwork(myP);
%
spaceRunning = State.fromMarginalAndRunning(model,3,[2,1,1,1],[2,1,0,0]);
spaceStarted = State.fromMarginalAndStarted(model,3,[2,1,1,1],[2,1,0,0]);
space = State.fromMarginal(model,3,[2,1,1,1],[2,1,0,0]);