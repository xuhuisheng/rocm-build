#!/bin/python3

import numpy as np
import torch
import torch.nn as nn
import torch.utils.data as Data
import torch.optim as optim
from torch.nn import init
import time

index = 0

num_inputs = 2
# num_examples = 1000
num_examples = 6
true_w = [1, 1]
true_b = 10
# features = torch.tensor(np.random.normal(0, 1, (num_examples, num_inputs)), dtype = torch.float)
features = torch.tensor(np.ones((num_examples, num_inputs)), dtype = torch.float)
labels = true_w[0] * features[:, 0] + true_w[1] * features[:, 1] + true_b
# labels += torch.tensor(np.random.normal(0, 0.01, size = labels.size()), dtype = torch.float)

batch_size = 2
dataset = Data.TensorDataset(features, labels)
data_iter = Data.DataLoader(dataset, batch_size, shuffle = True)

device = torch.device("cuda")

net = nn.Sequential(
    nn.Linear(num_inputs, 1)
).to(device)

print(net)

# init.normal_(net[0].weight, mean = 0, std = 0.01)
init.constant_(net[0].weight, val = 1)
init.constant_(net[0].bias, val = 10)

loss = nn.MSELoss()

optimizer = optim.SGD(net.parameters(), lr = 0.03)
print(optimizer)
print(true_w, net[0].weight)
print(true_b, net[0].bias)

# num_epochs = 10
num_epochs = 1
for epoch in range(1, num_epochs + 1):
    for X, Y in data_iter:
        X = X.to(device)
        Y = Y.to(device)
        output = net(X)
        l = loss(output, Y.view(-1, 1))
        
        if l.item() > 0:
            print("       ###########################")
            print("     X %s" % X)
            print("     Y %s" % Y)
            print("weight %s" % net[0].weight.data)
            print("  bias %s" % net[0].bias.data)
            print("output %s" % output)
            print("     l %s" % l)

        time.sleep(1)
        # print("before %s, %s, %s" % (l.item(), net[0].weight.data, net[0].bias.data))
        print("before %s" % l.item())
        print("   before zero grad")
        optimizer.zero_grad()
        print("   before backward")
        l.backward()
        # print("after %s, %s, %s" % (l.item(), net[0].weight.data, net[0].bias.data))
        # print("after %s" % l.item())
        print("   before opti step")
        optimizer.step()
        index += 1
        if index == 2:
            print("")
            print("")
            print("")
            print("")
            print("")
            print("     X %s" % X)
            print("     Y %s" % Y)
            print("weight %s %s" % (net[0].weight.data, net[0].weight.grad))
            print("  bias %s %s" % (net[0].bias.data, net[0].bias.grad))
            print("output %s" % output)
            print("     l %s" % l)
            print("")
            print("")
            print("")
            print("")
            print("")

    print('epoch %d, loss: %f' % (epoch, l.item()))

dense = net[0]
print(true_w, dense.weight)
print(true_b, dense.bias)

